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
