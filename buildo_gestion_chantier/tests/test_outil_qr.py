import base64

from odoo.exceptions import UserError
from odoo.tests import HttpCase, tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestOutilQr(HttpCase, ChantierTestCommon):
    """QR code par outil : sortie et retour en un scan."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.ouvrier = cls._create_buildo_user('qr_ouvrier', 'buildo_gestion_chantier.group_ouvrier')
        cls.collegue = cls._create_buildo_user('qr_collegue', 'buildo_gestion_chantier.group_ouvrier')
        cls.chef = cls._create_buildo_user('qr_chef', 'buildo_gestion_chantier.group_chef_chantier')
        cls.ouvrier.password = 'qr_ouvrier'
        cls.chantier.write({'state': 'en_cours', 'chef_chantier_id': cls.chef.id})
        cls.env['chantier.tache'].create({'name': 'Coffrage', 'chantier_id': cls.chantier.id,
                                          'ouvrier_ids': [(6, 0, cls.ouvrier.ids)]})
        cls.outil = cls.env['chantier.outil'].create({'name': 'Perforateur Hilti', 'ref_interne': 'OUT-042'})

    def _attribution(self):
        return self.outil.attribution_ids.filtered(lambda a: a.state == 'attribue')

    def test_chaque_outil_a_son_qr_code(self):
        autre = self.env['chantier.outil'].create({'name': 'Niveau laser'})
        self.assertTrue(self.outil.qr_token)
        self.assertNotEqual(self.outil.qr_token, autre.qr_token)
        self.assertTrue(self.outil.qr_url.endswith('/buildo/outil/%s' % self.outil.qr_token))
        self.assertTrue(base64.b64decode(self.outil.qr_code).startswith(b'\x89PNG'))
        self.assertFalse(self.outil.copy().qr_token == self.outil.qr_token)

    def test_regenerer_invalide_l_ancien_qr(self):
        ancien = self.outil.qr_token
        self.outil.with_user(self.chef).action_regenerer_qr()
        self.assertNotEqual(self.outil.qr_token, ancien)

    def test_ouvrier_prend_puis_rend_en_un_scan(self):
        outil = self.outil.with_user(self.ouvrier)
        res = outil.action_scan_prendre()
        self.assertEqual(res['tag'], 'display_notification', "Chantier unique : pas de question")
        attribution = self._attribution()
        self.assertEqual(attribution.ouvrier_id, self.ouvrier)
        self.assertEqual(attribution.chantier_id, self.chantier)
        self.assertEqual(self.outil.etat, 'attribue')
        with self.assertRaises(UserError):
            outil.action_scan_prendre()
        outil.action_scan_rendre()
        self.assertEqual(attribution.state, 'retourne')
        self.assertEqual(self.outil.etat, 'disponible')

    def test_plusieurs_chantiers_demande_lequel(self):
        second = self.env['chantier.chantier'].create({'name': 'Chantier B', 'client_id': self.client.id,
                                                       'state': 'en_cours'})
        for chantier in self.chantier | second:
            self.env['chantier.tache'].create({'name': 'Pose', 'chantier_id': chantier.id,
                                               'ouvrier_ids': [(6, 0, self.collegue.ids)]})
        res = self.outil.with_user(self.collegue).action_scan_prendre()
        self.assertEqual(res['res_model'], 'chantier.wizard.scan.outil')
        wizard = self.env['chantier.wizard.scan.outil'].with_user(self.collegue).create({
            'outil_id': self.outil.id, 'chantier_id': self.chantier.id})
        wizard.action_confirmer()
        self.assertEqual(self._attribution().ouvrier_id, self.collegue)

    def test_seul_le_detenteur_ou_un_chef_peut_rendre(self):
        self.outil.with_user(self.ouvrier).action_scan_prendre()
        with self.assertRaises(UserError):
            self.outil.with_user(self.collegue).action_scan_rendre()
        self.outil.with_user(self.chef).action_scan_rendre()
        self.assertEqual(self.outil.etat, 'disponible')

    def test_chef_confie_l_outil_a_un_ouvrier(self):
        res = self.outil.with_user(self.chef).action_scan_prendre()
        self.assertEqual(res['res_model'], 'chantier.wizard.scan.outil')
        self.env['chantier.wizard.scan.outil'].with_user(self.chef).create({
            'outil_id': self.outil.id, 'chantier_id': self.chantier.id, 'ouvrier_id': self.collegue.id,
        }).action_confirmer()
        self.assertEqual(self.outil.attribue_a_id, self.collegue)

    def test_un_ouvrier_ne_peut_pas_sortir_pour_un_autre(self):
        self.outil.with_user(self.ouvrier).action_scan_prendre(self.chantier.id, self.collegue.id)
        self.assertEqual(self.outil.attribue_a_id, self.ouvrier)

    def test_lien_du_qr_ouvre_la_fiche(self):
        self.authenticate('qr_ouvrier', 'qr_ouvrier')
        res = self.url_open('/buildo/outil/%s' % self.outil.qr_token, allow_redirects=False)
        self.assertIn(res.status_code, (302, 303))
        self.assertTrue(res.headers['Location'].endswith('action_chantier_outil/%s' % self.outil.id))
        self.assertEqual(self.url_open('/buildo/outil/inconnu', allow_redirects=False).status_code, 404)

    def test_etiquettes_imprimables(self):
        html, _type = self.env['ir.actions.report']._render_qweb_html(
            'buildo_gestion_chantier.action_report_etiquette_outil', self.outil.ids)
        self.assertIn(b'Perforateur Hilti', html)
        self.assertIn(b'data:image/png;base64', html)
