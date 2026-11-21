from datetime import date, timedelta

from freezegun import freeze_time

from odoo.tests import tagged

from .common import ChantierTestCommon

MARDI = date(2026, 11, 17)
LUNDI = date(2026, 11, 16)


@tagged('post_install', '-at_install')
class TestAlertesAuto(ChantierTestCommon):
    """Rappels du matin (outil en retard, heures oubliées, budget dépassé) et sortie de stock."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        g = 'buildo_gestion_chantier.group_%s'
        cls.ouvrier = cls._create_buildo_user('auto_ouvrier', g % 'ouvrier')
        cls.collegue = cls._create_buildo_user('auto_collegue', g % 'ouvrier')
        cls.chef = cls._create_buildo_user('auto_chef', g % 'chef_chantier')
        cls.chantier.write({'state': 'en_cours', 'chef_chantier_id': cls.chef.id})
        cls.env['chantier.tache'].create({'name': 'Plafonnage', 'chantier_id': cls.chantier.id,
                                          'ouvrier_ids': [(6, 0, (cls.ouvrier | cls.collegue).ids)]})
        cls.Chantier = cls.env['chantier.chantier']

    def _activites(self, type_xmlid, user):
        return self.env['mail.activity'].search([
            ('activity_type_id', '=', self.env.ref('buildo_gestion_chantier.%s' % type_xmlid).id),
            ('user_id', '=', user.id)])

    # --- Outil en retard ---------------------------------------------------------------

    def test_outil_en_retard_rappel_puis_cloture_au_retour(self):
        outil = self.env['chantier.outil'].create({'name': 'Ponceuse girafe'})
        attribution = self.env['chantier.attribution.outil'].create({
            'chantier_id': self.chantier.id, 'outil_id': outil.id, 'ouvrier_id': self.ouvrier.id,
            'date_sortie': date.today() - timedelta(days=10), 'date_retour_prevue': date.today() - timedelta(days=2),
        })
        self.Chantier._cron_alertes_quotidiennes()
        rappel = self._activites('activite_outil_a_rendre', self.ouvrier)
        self.assertEqual(rappel.res_id, attribution.id)
        self.assertIn('Ponceuse girafe', rappel.summary)
        self.Chantier._cron_alertes_quotidiennes()
        self.assertEqual(len(self._activites('activite_outil_a_rendre', self.ouvrier)), 1, "Pas de doublon")
        outil.with_user(self.ouvrier).action_scan_rendre()
        self.assertFalse(self._activites('activite_outil_a_rendre', self.ouvrier))

    # --- Heures oubliées ---------------------------------------------------------------

    def test_heures_oubliees_la_veille(self):
        self.env['chantier.heure.prestee'].create({
            'chantier_id': self.chantier.id, 'ouvrier_id': self.collegue.id, 'date': LUNDI, 'nb_heures': 8})
        with freeze_time(MARDI):
            self.Chantier._cron_alertes_quotidiennes()
            self.Chantier._cron_alertes_quotidiennes()
        rappel = self._activites('activite_heures_a_encoder', self.ouvrier)
        self.assertEqual(len(rappel), 1)
        self.assertIn('16/11/2026', rappel.summary)
        self.assertFalse(self._activites('activite_heures_a_encoder', self.collegue), "Il a encodé lundi")
        # Encoder ferme le rappel.
        self.env['chantier.heure.prestee'].with_user(self.ouvrier).create(
            {'chantier_id': self.chantier.id, 'date': LUNDI, 'nb_heures': 7.5})
        self.assertFalse(self._activites('activite_heures_a_encoder', self.ouvrier))

    def test_le_lundi_on_verifie_le_vendredi(self):
        self.env['chantier.heure.prestee'].create({
            'chantier_id': self.chantier.id, 'ouvrier_id': self.ouvrier.id, 'date': date(2026, 11, 13), 'nb_heures': 8})
        with freeze_time(LUNDI):
            self.Chantier._cron_alertes_quotidiennes()
        self.assertFalse(self._activites('activite_heures_a_encoder', self.ouvrier), "Vendredi encodé")
        self.assertIn('13/11/2026', self._activites('activite_heures_a_encoder', self.collegue).summary)

    def test_pas_de_rappel_hors_periode_de_la_tache(self):
        autre = self._create_buildo_user('auto_plus_tard', 'buildo_gestion_chantier.group_ouvrier')
        self.env['chantier.tache'].create({'name': 'Peinture', 'chantier_id': self.chantier.id,
                                           'date_debut': date(2026, 12, 1), 'ouvrier_ids': [(6, 0, autre.ids)]})
        with freeze_time(MARDI):
            self.Chantier._cron_alertes_quotidiennes()
        self.assertFalse(self._activites('activite_heures_a_encoder', autre))

    # --- Budget dépassé ----------------------------------------------------------------

    def _depenser(self, heures):
        self.env['chantier.heure.prestee'].create({
            'chantier_id': self.chantier.id, 'ouvrier_id': self.ouvrier.id, 'nb_heures': heures,
            'taux_horaire': 100, 'state': 'valide'})

    def test_budget_depasse_alerte_le_chef_puis_se_ferme(self):
        self.chantier.budget_initial = 1000
        self._depenser(8)
        self.Chantier._cron_alertes_quotidiennes()
        self.assertFalse(self._activites('activite_budget_depasse', self.chef), "800 sur 1000 : dans le budget")
        self._depenser(4)
        self.Chantier._cron_alertes_quotidiennes()
        self.Chantier._cron_alertes_quotidiennes()
        alerte = self._activites('activite_budget_depasse', self.chef)
        self.assertEqual(len(alerte), 1)
        self.assertIn('20 %', alerte.summary)
        self.chantier.budget_initial = 2000
        self.Chantier._cron_alertes_quotidiennes()
        self.assertFalse(self._activites('activite_budget_depasse', self.chef))

    def test_points_d_attention_dans_le_resume(self):
        self.Chantier._cron_resume_quotidien()
        self.chantier.budget_initial = 100
        self._depenser(2)
        self.env['chantier.heure.prestee'].create({
            'chantier_id': self.chantier.id, 'ouvrier_id': self.ouvrier.id, 'nb_heures': 1})
        message = self.Chantier._cron_resume_quotidien()
        self.assertIn("Points d'attention", message.body)
        self.assertIn('Budget dépassé', message.body)
        self.assertIn(self.chantier.name, message.body)

    # --- Sortie de stock ---------------------------------------------------------------

    def test_demande_acceptee_sort_le_materiau_du_stock(self):
        produit = self.env['product.product'].create({'name': 'Plâtre 25 kg', 'is_storable': True})
        entrepot = self.env['stock.warehouse'].search([('company_id', '=', self.env.company.id)], limit=1)
        self.env['stock.quant'].with_context(inventory_mode=True).create({
            'product_id': produit.id, 'location_id': entrepot.lot_stock_id.id, 'inventory_quantity': 50,
        }).action_apply_inventory()
        materiau = self.env['chantier.materiau'].create({'name': 'Plâtre', 'product_id': produit.id})
        demande = self.env['chantier.demande.materiel'].with_user(self.ouvrier).create(
            {'materiau_id': materiau.id, 'quantite': 12})
        demande.action_soumettre()
        demande.with_user(self.chef).action_valider()
        self.assertEqual(demande.picking_id.state, 'done')
        self.assertIn(self.chantier.ref, demande.picking_id.origin)
        self.assertEqual(materiau.stock_disponible, 38)

    def test_materiau_sans_produit_ne_touche_pas_au_stock(self):
        demande = self.env['chantier.demande.materiel'].with_user(self.ouvrier).create(
            {'description': 'Cales en bois', 'quantite': 5})
        demande.action_soumettre()
        demande.with_user(self.chef).action_valider()
        self.assertEqual(demande.state, 'valide')
        self.assertFalse(demande.picking_id)
