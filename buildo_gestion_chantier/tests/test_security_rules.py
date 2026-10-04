from odoo.exceptions import AccessError
from odoo.tests import tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestSecurityRules(ChantierTestCommon):
    """Vérifie le cloisonnement par chantier (ir.rule) entre chefs de chantier,
    et son levée pour le service administratif / la direction."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.chef1 = cls._create_buildo_user('chef1_test', 'buildo_gestion_chantier.group_chef_chantier')
        cls.chef2 = cls._create_buildo_user('chef2_test', 'buildo_gestion_chantier.group_chef_chantier')
        cls.admin_service = cls._create_buildo_user(
            'admin_service_test', 'buildo_gestion_chantier.group_service_administratif',
        )

        cls.chantier1 = cls.env['chantier.chantier'].create({
            'name': 'Chantier de chef1', 'client_id': cls.client.id, 'chef_chantier_id': cls.chef1.id,
        })
        cls.chantier2 = cls.env['chantier.chantier'].create({
            'name': 'Chantier de chef2', 'client_id': cls.client.id, 'chef_chantier_id': cls.chef2.id,
        })

    def test_chef_sees_only_own_chantiers(self):
        Chantier = self.env['chantier.chantier'].with_user(self.chef1)
        found = Chantier.search([('id', 'in', (self.chantier1 | self.chantier2).ids)])
        self.assertEqual(found, self.chantier1)

    def test_chef_cannot_write_other_chantier(self):
        chantier2_as_chef1 = self.chantier2.with_user(self.chef1)
        with self.assertRaises(AccessError):
            chantier2_as_chef1.write({'description': 'Tentative non autorisée'})

    def test_chef_can_write_own_chantier(self):
        chantier1_as_chef1 = self.chantier1.with_user(self.chef1)
        chantier1_as_chef1.write({'description': 'Mise à jour autorisée'})
        self.assertEqual(self.chantier1.description, 'Mise à jour autorisée')

    def test_admin_service_sees_all_chantiers(self):
        Chantier = self.env['chantier.chantier'].with_user(self.admin_service)
        found = Chantier.search([('id', 'in', (self.chantier1 | self.chantier2).ids)])
        self.assertEqual(found, self.chantier1 | self.chantier2)

    def test_tache_cloisonnement_via_nested_domain(self):
        tache1 = self.env['chantier.tache'].create({
            'name': 'Tâche chantier1', 'chantier_id': self.chantier1.id,
        })
        tache2 = self.env['chantier.tache'].create({
            'name': 'Tâche chantier2', 'chantier_id': self.chantier2.id,
        })
        Tache = self.env['chantier.tache'].with_user(self.chef1)
        found = Tache.search([('id', 'in', (tache1 | tache2).ids)])
        self.assertEqual(found, tache1)

    def test_heure_prestee_ouvrier_sees_only_own(self):
        ouvrier1 = self._create_buildo_user('ouvrier1_test', 'buildo_gestion_chantier.group_ouvrier')
        ouvrier2 = self._create_buildo_user('ouvrier2_test', 'buildo_gestion_chantier.group_ouvrier')
        heure1 = self.env['chantier.heure.prestee'].create({
            'chantier_id': self.chantier1.id, 'ouvrier_id': ouvrier1.id, 'nb_heures': 4, 'taux_horaire': 20,
        })
        heure2 = self.env['chantier.heure.prestee'].create({
            'chantier_id': self.chantier1.id, 'ouvrier_id': ouvrier2.id, 'nb_heures': 4, 'taux_horaire': 20,
        })
        Heure = self.env['chantier.heure.prestee'].with_user(ouvrier1)
        found = Heure.search([('id', 'in', (heure1 | heure2).ids)])
        self.assertEqual(found, heure1)

    def test_ouvrier_cannot_validate_own_records(self):
        ouvrier = self._create_buildo_user('ouvrier_valid_test', 'buildo_gestion_chantier.group_ouvrier')
        Heure = self.env['chantier.heure.prestee'].with_user(ouvrier)
        heure = Heure.create({'chantier_id': self.chantier1.id, 'nb_heures': 8, 'taux_horaire': 20})
        heure.action_soumettre()
        self.assertEqual(heure.state, 'soumis')
        with self.assertRaises(AccessError):
            heure.action_valider()
        with self.assertRaises(AccessError):
            heure.write({'state': 'refuse'})
        with self.assertRaises(AccessError):
            Heure.create({'chantier_id': self.chantier1.id, 'nb_heures': 1, 'state': 'valide'})
        demande = self.env['chantier.demande.materiel'].with_user(ouvrier).create({
            'chantier_id': self.chantier1.id, 'description': 'Sacs de ciment',
        })
        with self.assertRaises(AccessError):
            demande.action_valider()

    def test_ouvrier_cannot_modify_validated_record(self):
        ouvrier = self._create_buildo_user('ouvrier_modif_test', 'buildo_gestion_chantier.group_ouvrier')
        heure = self.env['chantier.heure.prestee'].with_user(ouvrier).create({
            'chantier_id': self.chantier1.id, 'nb_heures': 8, 'taux_horaire': 20,
        })
        heure.action_soumettre()
        heure.with_user(self.chef1).action_valider()
        self.assertEqual(heure.state, 'valide')
        self.assertEqual(heure.validateur_id, self.chef1)
        with self.assertRaises(AccessError):
            heure.with_user(ouvrier).write({'nb_heures': 80})

    def test_smart_buttons_hidden_without_finance_access(self):
        ouvrier = self._create_buildo_user('ouvrier_form_test', 'buildo_gestion_chantier.group_ouvrier')
        for user in (ouvrier, self.chef1):
            arch = self.env['chantier.chantier'].with_user(user).get_views([(False, 'form')])['views']['form']['arch']
            self.assertNotIn('action_view_devis', arch)
        arch = self.env['chantier.chantier'].with_user(self.admin_service).get_views([(False, 'form')])['views']['form']['arch']
        self.assertIn('action_view_devis', arch)
        self.chantier1.with_user(self.admin_service).read(['devis_ids', 'facture_ids', 'commande_fournisseur_ids'])

    def _read_form_as(self, user, record):
        """Lit la fiche comme le client web : tous les champs de la vue formulaire."""
        Model = self.env[record._name].with_user(user)
        fields_spec = Model.get_views([(False, 'form')])['models'][record._name]['fields']
        return record.with_user(user).web_read({name: {} for name in fields_spec})

    def test_ouvrier_cannot_read_chantier_finances(self):
        ouvrier = self._create_buildo_user('ouvrier_fin_test', 'buildo_gestion_chantier.group_ouvrier')
        self.env['chantier.tache'].create({'name': 'Maçonnerie', 'chantier_id': self.chantier1.id,
                                           'ouvrier_ids': [(6, 0, ouvrier.ids)]})
        data = self._read_form_as(ouvrier, self.chantier1)[0]
        for name in ('marge', 'montant_facture', 'cout_reel', 'budget_initial', 'paiement_fss_ids'):
            self.assertNotIn(name, data)
        with self.assertRaises(AccessError):
            self.chantier1.with_user(ouvrier).read(['marge'])
        with self.assertRaises(AccessError):
            self.env['chantier.avenant'].with_user(ouvrier).search([])

    def test_chef_reads_chantier_finances(self):
        data = self._read_form_as(self.chef1, self.chantier1)[0]
        self.assertIn('marge', data)
        self.assertNotIn('paiement_fss_ids', data)
