from datetime import date, timedelta

from freezegun import freeze_time

from odoo.exceptions import UserError, ValidationError
from odoo.tests import tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestDemandeOutil(ChantierTestCommon):
    """Demande d'outil par l'ouvrier, suivi des sorties et des retards."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.ouvrier = cls._create_buildo_user('dem_ouvrier', 'buildo_gestion_chantier.group_ouvrier')
        cls.collegue = cls._create_buildo_user('dem_collegue', 'buildo_gestion_chantier.group_ouvrier')
        cls.chef = cls._create_buildo_user('dem_chef', 'buildo_gestion_chantier.group_chef_chantier')
        cls.chantier.write({'state': 'en_cours', 'chef_chantier_id': cls.chef.id})
        cls.env['chantier.tache'].create({'name': 'Carrelage', 'chantier_id': cls.chantier.id,
                                          'ouvrier_ids': [(6, 0, (cls.ouvrier | cls.collegue).ids)]})
        cls.outil = cls.env['chantier.outil'].create({'name': 'Disqueuse Makita'})
        cls.Demande = cls.env['chantier.demande.materiel'].with_user(cls.ouvrier)

    def _demander_outil(self):
        demande = self.Demande.create({'type_demande': 'outil', 'outil_id': self.outil.id})
        demande.action_soumettre()
        return demande

    def test_chantier_et_description_remplis_automatiquement(self):
        demande = self._demander_outil()
        self.assertEqual(demande.chantier_id, self.chantier, "Seul chantier en cours de l'ouvrier")
        self.assertEqual(demande.description, 'Disqueuse Makita')

    def test_demande_d_outil_sans_outil_refusee(self):
        with self.assertRaises(ValidationError):
            self.Demande.create({'type_demande': 'outil', 'description': 'Une disqueuse'})

    def test_accepter_confie_l_outil_et_previent_l_ouvrier(self):
        demande = self._demander_outil()
        demande.with_user(self.chef).action_valider()
        self.assertEqual(self.outil.attribue_a_id, self.ouvrier)
        self.assertEqual(self.outil.chantier_actuel_id, self.chantier)
        self.assertEqual(demande.attribution_id.date_retour_prevue, date.today() + timedelta(days=7))
        message = demande.message_ids.filtered(lambda m: self.ouvrier.partner_id in m.partner_ids)
        self.assertIn('acceptée', message.body)

    def test_accepter_un_outil_deja_sorti_est_bloque(self):
        self.outil.with_user(self.collegue).action_scan_prendre()
        demande = self._demander_outil()
        with self.assertRaisesRegex(UserError, 'dem_collegue'):
            demande.with_user(self.chef).action_valider()
        self.assertEqual(demande.state, 'soumis')

    def test_refus_previent_l_ouvrier_avec_le_motif(self):
        demande = self._demander_outil()
        self.env['chantier.wizard.refus'].with_user(self.chef).with_context(
            active_model=demande._name, active_ids=demande.ids,
        ).create({'motif': 'Déjà une disqueuse sur place'}).action_confirmer()
        message = demande.message_ids.filtered(lambda m: self.ouvrier.partner_id in m.partner_ids)
        self.assertIn('Déjà une disqueuse sur place', message.body)
        self.assertEqual(self.outil.etat, 'disponible')

    def test_rendre_depuis_mes_outils(self):
        self.outil.with_user(self.ouvrier).action_scan_prendre()
        attribution = self.env['chantier.attribution.outil'].with_user(self.ouvrier).search(
            [('ouvrier_id', '=', self.ouvrier.id), ('state', '=', 'attribue')])
        attribution.action_rendre()
        self.assertEqual(attribution.state, 'retourne')
        self.outil.with_user(self.collegue).action_scan_prendre()
        attribution = self.outil.attribution_ids.filtered(lambda a: a.state == 'attribue')
        with self.assertRaises(UserError):
            attribution.with_user(self.ouvrier).action_rendre()

    def test_outil_en_retard(self):
        self.outil.with_user(self.ouvrier).action_scan_prendre()
        Outil = self.env['chantier.outil']
        Attribution = self.env['chantier.attribution.outil']
        self.assertFalse(self.outil.en_retard)
        with freeze_time(date.today() + timedelta(days=8)):
            self.outil.invalidate_recordset(['en_retard'])
            self.assertTrue(self.outil.en_retard)
            self.assertIn(self.outil, Outil.search([('en_retard', '=', True)]))
            self.assertNotIn(self.outil, Outil.search([('en_retard', '=', False)]))
            self.assertTrue(Attribution.search([('outil_id', '=', self.outil.id), ('en_retard', '=', True)]))
