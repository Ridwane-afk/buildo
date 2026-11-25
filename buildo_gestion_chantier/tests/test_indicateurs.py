from lxml import etree

from odoo.tests import tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestIndicateursCliquables(ChantierTestCommon):
    """Les cartes « Indicateurs financiers » ouvrent les pièces derrière chaque chiffre."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.ouvrier = cls._create_buildo_user('kpi_ouvrier', 'buildo_gestion_chantier.group_ouvrier')
        cls.chef = cls._create_buildo_user('kpi_chef', 'buildo_gestion_chantier.group_chef_chantier')
        cls.admin = cls._create_buildo_user('kpi_admin', 'buildo_gestion_chantier.group_service_administratif')
        cls.direction = cls._create_buildo_user('kpi_direction', 'buildo_gestion_chantier.group_direction')
        cls.chantier.write({'state': 'en_cours', 'chef_chantier_id': cls.chef.id})
        cls.autre = cls.chantier.copy({'name': 'Autre chantier'})
        Heure = cls.env['chantier.heure.prestee']
        cls.validee = Heure.create({'chantier_id': cls.chantier.id, 'ouvrier_id': cls.ouvrier.id,
                                    'nb_heures': 8, 'state': 'valide'})
        Heure.create({'chantier_id': cls.chantier.id, 'ouvrier_id': cls.ouvrier.id, 'nb_heures': 3})
        Heure.create({'chantier_id': cls.autre.id, 'ouvrier_id': cls.ouvrier.id, 'nb_heures': 5, 'state': 'valide'})

    def _ouvrir(self, user, methode):
        action = getattr(self.chantier.with_user(user), methode)()
        model = self.env[action['res_model']].with_user(user)
        if 'views' not in action:
            model.get_views([(False, mode) for mode in action['view_mode'].split(',')])
        return model.search(action['domain'])

    def _boutons(self, user):
        arch = self.env['chantier.chantier'].with_user(user).get_views([(False, 'form')])['views']['form']['arch']
        return set(etree.fromstring(arch).xpath("//div[hasclass('o_buildo_kpis')]//button/@name"))

    def test_main_d_oeuvre_ne_montre_que_les_heures_validees_du_chantier(self):
        self.assertEqual(self._ouvrir(self.chef, 'action_voir_main_oeuvre'), self.validee)
        self.assertEqual(self.chantier.with_user(self.chef).cout_main_oeuvre, self.validee.montant)

    def test_chaque_role_ouvre_ce_qu_il_peut_lire(self):
        self.assertEqual(self._boutons(self.ouvrier), {'action_voir_taches'})
        self.assertEqual(self._boutons(self.chef), {'action_voir_taches', 'action_voir_main_oeuvre'})
        self.assertEqual(self._boutons(self.admin), {
            'action_voir_taches', 'action_voir_main_oeuvre', 'action_voir_achats', 'action_voir_encaissements'})
        self.assertEqual(self._boutons(self.direction), {
            'action_voir_taches', 'action_voir_main_oeuvre', 'action_voir_achats', 'action_voir_encaissements',
            'action_voir_analyse_marge'})
        self._ouvrir(self.ouvrier, 'action_voir_taches')
        self._ouvrir(self.admin, 'action_voir_achats')
        self._ouvrir(self.admin, 'action_voir_encaissements')
        self.assertEqual(self._ouvrir(self.direction, 'action_voir_analyse_marge'), self.chantier)
