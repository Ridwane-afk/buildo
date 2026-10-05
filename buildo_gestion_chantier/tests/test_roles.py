from odoo.exceptions import AccessError
from odoo.tests import tagged
from odoo.tools.safe_eval import safe_eval

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestRoles(ChantierTestCommon):
    """Vérifie, pour chacun des 5 rôles BUILDO, les droits par modèle,
    le cloisonnement des enregistrements, les menus et les actions métier."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        g = 'buildo_gestion_chantier.group_%s'
        cls.ouvrier1 = cls._create_buildo_user('role_ouvrier1', g % 'ouvrier')
        cls.ouvrier2 = cls._create_buildo_user('role_ouvrier2', g % 'ouvrier')
        cls.chef1 = cls._create_buildo_user('role_chef1', g % 'chef_chantier')
        cls.chef2 = cls._create_buildo_user('role_chef2', g % 'chef_chantier')
        cls.admin_service = cls._create_buildo_user('role_admin_service', g % 'service_administratif')
        cls.direction = cls._create_buildo_user('role_direction', g % 'direction')
        cls.admin_buildo = cls._create_buildo_user('role_admin_buildo', g % 'admin_buildo')
        cls.roles = {
            'ouvrier': cls.ouvrier1, 'chef': cls.chef1, 'admin_service': cls.admin_service,
            'direction': cls.direction, 'admin_buildo': cls.admin_buildo,
        }

        Chantier = cls.env['chantier.chantier']
        cls.chantier1 = Chantier.create({'name': 'Chantier rôle 1', 'client_id': cls.client.id,
                                         'chef_chantier_id': cls.chef1.id, 'budget_initial': 50000})
        cls.chantier2 = Chantier.create({'name': 'Chantier rôle 2', 'client_id': cls.client.id,
                                         'chef_chantier_id': cls.chef2.id, 'budget_initial': 80000})
        Tache = cls.env['chantier.tache']
        cls.tache1 = Tache.create({'name': 'Coffrage', 'chantier_id': cls.chantier1.id,
                                   'ouvrier_ids': [(6, 0, cls.ouvrier1.ids)], 'montant_facturable': 1200})
        cls.tache2 = Tache.create({'name': 'Ferraillage', 'chantier_id': cls.chantier2.id,
                                   'ouvrier_ids': [(6, 0, cls.ouvrier2.ids)]})
        Heure = cls.env['chantier.heure.prestee']
        cls.heure1 = Heure.create({'chantier_id': cls.chantier1.id, 'ouvrier_id': cls.ouvrier1.id,
                                   'nb_heures': 8, 'taux_horaire': 20})
        cls.heure2 = Heure.create({'chantier_id': cls.chantier2.id, 'ouvrier_id': cls.ouvrier2.id,
                                   'nb_heures': 6, 'taux_horaire': 25})
        Demande = cls.env['chantier.demande.materiel']
        cls.demande1 = Demande.create({'chantier_id': cls.chantier1.id, 'ouvrier_id': cls.ouvrier1.id,
                                       'description': 'Sacs de ciment'})
        cls.demande2 = Demande.create({'chantier_id': cls.chantier2.id, 'ouvrier_id': cls.ouvrier2.id,
                                       'description': 'Treillis'})
        # Devis créé par un autre utilisateur que le service administratif
        cls.devis = cls.env['sale.order'].create({'partner_id': cls.client.id, 'chantier_id': cls.chantier1.id,
                                                  'user_id': cls.env.ref('base.user_admin').id})
        cls.avenant = cls.env['chantier.avenant'].create({'chantier_id': cls.chantier1.id,
                                                          'sale_order_id': cls.devis.id,
                                                          'motif': 'Ajout d\'une cloison'})
        cls.fss = cls.env['chantier.paiement.fss'].create({'chantier_id': cls.chantier1.id,
                                                           'ouvrier_id': cls.ouvrier1.id,
                                                           'periode': 'Q1 2026', 'montant': 150})

    # ------------------------------------------------------------------
    # Matrice des droits (ir.model.access)
    # ------------------------------------------------------------------

    # R = lecture, W = écriture, C = création, D = suppression
    EXPECTED_ACL = {
        #                               ouvrier  chef    admin   direction admin_buildo
        'chantier.chantier':           ('R---', 'RWC-', 'RWC-', 'RWC-', 'RWCD'),
        'chantier.tache':              ('R---', 'RWCD', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.heure.prestee':      ('RWC-', 'RWCD', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.demande.materiel':   ('RWC-', 'RWCD', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.rapport.journalier': ('----', 'RWCD', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.photo':              ('R-C-', 'RWCD', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.plan':               ('----', 'RWCD', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.estimation.materiau': ('----', 'RWCD', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.estimation.outil':   ('----', 'RWCD', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.attribution.outil':  ('R---', 'RWCD', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.assistant.ia':       ('----', 'RWCD', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.materiau':           ('R---', 'RWC-', 'RWC-', 'RWC-', 'RWCD'),
        'chantier.outil':              ('R---', 'RWC-', 'RWC-', 'RWC-', 'RWCD'),
        'chantier.avenant':            ('----', '----', 'RWCD', 'RWCD', 'RWCD'),
        'chantier.paiement.fss':       ('----', '----', 'RWC-', 'RWCD', 'RWCD'),
        'sale.order':                  ('----', '----', 'RWC-', 'RWC-', 'RWC-'),
        'account.move':                ('----', '----', 'RWCD', 'RWCD', 'RWCD'),
        'purchase.order':              ('----', '----', 'RWCD', 'RWCD', 'RWCD'),
    }

    def test_acl_matrix(self):
        ops = ('read', 'write', 'create', 'unlink')
        for model, expected in self.EXPECTED_ACL.items():
            for role, acl in zip(self.roles, expected):
                Model = self.env[model].with_user(self.roles[role])
                got = ''.join(c if Model.has_access(op) else '-' for c, op in zip('RWCD', ops))
                with self.subTest(model=model, role=role):
                    self.assertEqual(got, acl)

    # ------------------------------------------------------------------
    # Menus
    # ------------------------------------------------------------------

    def _menus(self, user):
        Menu = self.env['ir.ui.menu'].with_user(user)
        visible = Menu.browse(Menu._visible_menu_ids())
        root = self.env.ref('buildo_gestion_chantier.menu_buildo_root')
        sections = visible.filtered(lambda m: m.parent_id == root)
        return set(sections.mapped('name'))

    def test_menus_per_role(self):
        expected = {
            'ouvrier': {'Chantiers', 'Terrain'},
            'chef': {'Chantiers', 'Terrain', 'Stock'},
            'admin_service': {'Chantiers', 'Terrain', 'Stock', 'Commercial'},
            'direction': {'Chantiers', 'Terrain', 'Stock', 'Commercial', 'Direction'},
            'admin_buildo': {'Chantiers', 'Terrain', 'Stock', 'Commercial', 'Direction', 'Administration'},
        }
        for role, sections in expected.items():
            with self.subTest(role=role):
                self.assertEqual(self._menus(self.roles[role]), sections)

    # ------------------------------------------------------------------
    # Ouvrier
    # ------------------------------------------------------------------

    def test_ouvrier_scope(self):
        Heure = self.env['chantier.heure.prestee'].with_user(self.ouvrier1)
        Demande = self.env['chantier.demande.materiel'].with_user(self.ouvrier1)
        ids = (self.heure1 | self.heure2).ids
        self.assertEqual(Heure.search([('id', 'in', ids)]), self.heure1)
        self.assertEqual(Demande.search([('id', 'in', (self.demande1 | self.demande2).ids)]), self.demande1)
        with self.assertRaises(AccessError):
            self.heure2.with_user(self.ouvrier1).read(['nb_heures'])
        with self.assertRaises(AccessError):
            self.heure2.with_user(self.ouvrier1).write({'nb_heures': 1})

    def test_ouvrier_workflow(self):
        heure = self.env['chantier.heure.prestee'].with_user(self.ouvrier1).create({
            'chantier_id': self.chantier1.id, 'nb_heures': 7.5,
        })
        self.assertEqual(heure.ouvrier_id, self.ouvrier1)
        heure.action_soumettre()
        self.assertEqual(heure.state, 'soumis')
        with self.assertRaises(AccessError):
            heure.action_valider()
        with self.assertRaises(AccessError):
            heure.unlink()

    def test_ouvrier_forbidden_actions(self):
        with self.assertRaises(AccessError):
            self.env['chantier.chantier'].with_user(self.ouvrier1).create({'name': 'X', 'client_id': self.client.id})
        with self.assertRaises(AccessError):
            self.chantier1.with_user(self.ouvrier1).read(['marge'])
        for record in (self.avenant, self.fss, self.devis):
            with self.subTest(model=record._name), self.assertRaises(AccessError):
                record.with_user(self.ouvrier1).read(['id'])

    def test_ouvrier_sees_only_assigned(self):
        Chantier = self.env['chantier.chantier'].with_user(self.ouvrier1)
        self.assertEqual(Chantier.search([('id', 'in', (self.chantier1 | self.chantier2).ids)]), self.chantier1)
        Tache = self.env['chantier.tache'].with_user(self.ouvrier1)
        self.assertEqual(Tache.search([('id', 'in', (self.tache1 | self.tache2).ids)]), self.tache1)
        with self.assertRaises(AccessError):
            self.chantier2.with_user(self.ouvrier1).read(['name'])
        with self.assertRaises(AccessError):
            self.tache2.with_user(self.ouvrier1).read(['name'])
        with self.assertRaises(AccessError):
            self.tache1.with_user(self.ouvrier1).write({'name': 'Renommée'})

    def test_ouvrier_menus(self):
        Menu = self.env['ir.ui.menu'].with_user(self.ouvrier1)
        visible = Menu.browse(Menu._visible_menu_ids())
        root = self.env.ref('buildo_gestion_chantier.menu_buildo_root')
        # Un sous-menu n'est atteignable que si sa section parente est elle-même visible
        leaves = visible.filtered(lambda m: m.action and m.parent_id in visible and m.parent_id.parent_id == root)
        self.assertEqual(set(leaves.mapped('name')),
                         {'Tous les chantiers', 'Tâches', 'Heures prestées', 'Mes demandes', 'Photos', 'Mes outils'})

    def test_mes_demandes(self):
        action = self.env.ref('buildo_gestion_chantier.action_mes_demandes_materiel')
        self.assertFalse(action.context and 'search_default' in action.context)
        brouillon = self.env['chantier.demande.materiel'].with_user(self.ouvrier1).create({
            'chantier_id': self.chantier1.id, 'description': 'Gants',
        })
        domain = safe_eval(action.domain, {'uid': self.ouvrier1.id})
        found = self.env['chantier.demande.materiel'].with_user(self.ouvrier1).search(domain)
        self.assertEqual(found, self.demande1 | brouillon)
        # Le chef voit les deux menus : ses propres demandes et celles à valider
        Menu = self.env['ir.ui.menu'].with_user(self.chef1)
        visible = Menu._visible_menu_ids()
        for xmlid in ('menu_mes_demandes_materiel', 'menu_demande_materiel'):
            self.assertIn(self.env.ref('buildo_gestion_chantier.' + xmlid).id, visible)

    def test_ouvrier_forms_hide_restricted_data(self):
        chantier = self._read_form_as(self.ouvrier1, self.chantier1)[0]
        for name in ('estimation_materiau_ids', 'estimation_outil_ids', 'rapport_journalier_ids', 'plan_ids', 'marge'):
            self.assertNotIn(name, chantier)
        tache = self._read_form_as(self.ouvrier1, self.tache1)[0]
        for name in ('estimation_materiau_ids', 'estimation_outil_ids', 'montant_facturable', 'facture_id'):
            self.assertNotIn(name, tache)
        self.assertEqual(tache['ouvrier_ids'], self.ouvrier1.ids)
        arch = self.env['chantier.chantier'].with_user(self.ouvrier1).get_views([(False, 'form')])['views']['form']['arch']
        for button in ('action_start', 'action_terminate', 'action_cancel', 'action_ouvrir_rapport_avancement'):
            self.assertNotIn(button, arch)

    def test_display_names(self):
        self.assertEqual(self.demande1.display_name, 'Sacs de ciment')
        self.assertIn(self.ouvrier1.name, self.heure1.display_name)

    def test_ouvrier_photo_on_assigned_task(self):
        Photo = self.env['chantier.photo'].with_user(self.ouvrier1)
        action = self.tache1.with_user(self.ouvrier1).action_ajouter_photo()
        photo = Photo.with_context(**action['context']).create({'name': 'Coffrage terminé'})
        self.assertEqual(photo.chantier_id, self.chantier1)
        self.assertEqual(photo.auteur_id, self.ouvrier1)
        # Sans chantier explicite, il est déduit de la tâche
        photo2 = Photo.create({'name': 'Vue d\'ensemble', 'tache_id': self.tache1.id})
        self.assertEqual(photo2.chantier_id, self.chantier1)
        with self.assertRaises(AccessError):
            Photo.create({'name': 'Pas ma tâche', 'tache_id': self.tache2.id})
        with self.assertRaises(AccessError):
            photo.unlink()

    def test_ouvrier_tools_history(self):
        outil = self.env['chantier.outil'].create({'name': 'Perforateur'})
        Attribution = self.env['chantier.attribution.outil']
        mine = Attribution.create({'chantier_id': self.chantier1.id, 'outil_id': outil.id, 'ouvrier_id': self.ouvrier1.id})
        other = Attribution.create({'chantier_id': self.chantier2.id, 'outil_id': outil.id, 'ouvrier_id': self.ouvrier2.id})
        found = Attribution.with_user(self.ouvrier1).search([('id', 'in', (mine | other).ids)])
        self.assertEqual(found, mine)
        with self.assertRaises(AccessError):
            mine.with_user(self.ouvrier1).write({'note': 'x'})

    def _read_form_as(self, user, record):
        Model = self.env[record._name].with_user(user)
        fields_spec = Model.get_views([(False, 'form')])['models'][record._name]['fields']
        return record.with_user(user).web_read({name: {} for name in fields_spec})

    # ------------------------------------------------------------------
    # Chef de chantier
    # ------------------------------------------------------------------

    def test_chef_scope(self):
        Chantier = self.env['chantier.chantier'].with_user(self.chef1)
        both = (self.chantier1 | self.chantier2).ids
        self.assertEqual(Chantier.search([('id', 'in', both)]), self.chantier1)
        Heure = self.env['chantier.heure.prestee'].with_user(self.chef1)
        self.assertEqual(Heure.search([('id', 'in', (self.heure1 | self.heure2).ids)]), self.heure1)
        Demande = self.env['chantier.demande.materiel'].with_user(self.chef1)
        self.assertEqual(Demande.search([('id', 'in', (self.demande1 | self.demande2).ids)]), self.demande1)
        with self.assertRaises(AccessError):
            self.heure2.with_user(self.chef1).action_valider()

    def test_chef_opens_task_form(self):
        data = self._read_form_as(self.chef1, self.tache1)[0]
        self.assertIn('montant_facturable', data)
        self.assertIn('estimation_materiau_ids', data)
        self.assertNotIn('facture_id', data)

    def test_avenants_reserved_to_admin_and_direction(self):
        with self.assertRaises(AccessError):
            self.avenant.with_user(self.chef1).read(['name'])
        with self.assertRaises(AccessError):
            self.avenant.with_user(self.chef1).action_accepter()
        with self.assertRaises(AccessError):
            self.chantier1.with_user(self.chef1).read(['avenant_ids'])
        # Le chef garde le budget révisé (synthèse chantier), sans voir les avenants eux-mêmes
        self.chantier1.with_user(self.chef1).read(['budget_revise', 'montant_avenants_acceptes'])
        for user in (self.admin_service, self.direction):
            avenant = self.env['chantier.avenant'].with_user(user).create({
                'chantier_id': self.chantier1.id, 'sale_order_id': self.devis.id, 'motif': 'Extension terrasse',
            })
            avenant.action_accepter()
            self.assertEqual(avenant.state, 'accepte')

    def test_chef_validates_own_site(self):
        self.heure1.with_user(self.chef1).action_valider()
        self.assertEqual(self.heure1.state, 'valide')
        self.assertEqual(self.heure1.validateur_id, self.chef1)
        self.assertEqual(self.chantier1.with_user(self.chef1).read(['marge'])[0]['marge'], -160.0)

    def test_chef_forbidden_actions(self):
        with self.assertRaises(AccessError):
            self.chantier1.with_user(self.chef1).read(['devis_ids'])
        with self.assertRaises(AccessError):
            self.chantier1.with_user(self.chef1).unlink()
        with self.assertRaises(AccessError):
            self.fss.with_user(self.chef1).read(['montant'])
        tache = self.env['chantier.tache'].create({'name': 'Gros œuvre', 'chantier_id': self.chantier1.id,
                                                   'state': 'fait', 'montant_facturable': 1000})
        with self.assertRaises(AccessError):
            tache.with_user(self.chef1).action_facturer()

    # ------------------------------------------------------------------
    # Service administratif
    # ------------------------------------------------------------------

    def test_admin_service_sees_everything(self):
        user = self.admin_service
        both = (self.chantier1 | self.chantier2).ids
        self.assertEqual(len(self.env['chantier.chantier'].with_user(user).search([('id', 'in', both)])), 2)
        Heure = self.env['chantier.heure.prestee'].with_user(user)
        self.assertEqual(len(Heure.search([('id', 'in', (self.heure1 | self.heure2).ids)])), 2)
        # Devis créé par un autre utilisateur : visible (« tous les documents »)
        self.assertEqual(self.env['sale.order'].with_user(user).search([('id', '=', self.devis.id)]), self.devis)
        data = self.chantier1.with_user(user).read(['devis_ids', 'paiement_fss_ids', 'marge'])[0]
        self.assertEqual(data['devis_ids'], self.devis.ids)

    def test_admin_service_fss(self):
        Fss = self.env['chantier.paiement.fss'].with_user(self.admin_service)
        fss = Fss.create({'chantier_id': self.chantier2.id, 'ouvrier_id': self.ouvrier2.id,
                          'periode': 'Q2 2026', 'montant': 90})
        fss.action_marquer_paye()
        self.assertEqual(fss.state, 'paye')
        with self.assertRaises(AccessError):
            fss.unlink()

    # ------------------------------------------------------------------
    # Direction et administrateur BUILDO
    # ------------------------------------------------------------------

    def test_direction(self):
        action = self.env.ref('buildo_gestion_chantier.action_chantier_dashboard')
        self.assertIn(self.env.ref('buildo_gestion_chantier.group_direction'), action.group_ids)
        self.fss.with_user(self.direction).unlink()
        self.assertFalse(self.fss.exists())
        with self.assertRaises(AccessError):
            self.chantier2.with_user(self.direction).unlink()

    def test_direction_invoices_task(self):
        tache = self.env['chantier.tache'].create({'name': 'Toiture', 'chantier_id': self.chantier1.id,
                                                   'state': 'fait', 'montant_facturable': 2500})
        tache.with_user(self.direction).action_facturer()
        self.assertTrue(tache.facture_id)
        self.assertEqual(tache.facture_id.chantier_id, self.chantier1)
        self.assertEqual(tache.facture_id.amount_untaxed, 2500)

    def test_admin_buildo_can_delete_chantier(self):
        chantier = self.env['chantier.chantier'].create({'name': 'À supprimer', 'client_id': self.client.id})
        chantier.with_user(self.admin_buildo).unlink()
        self.assertFalse(chantier.exists())
