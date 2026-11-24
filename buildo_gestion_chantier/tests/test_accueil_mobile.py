from odoo.tests import HttpCase, tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestAccueilMobile(HttpCase, ChantierTestCommon):
    """À la connexion, l'ouvrier arrive sur ses heures, sans la discussion OdooBot."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.ouvrier = cls._create_buildo_user('accueil_ouvrier', 'buildo_gestion_chantier.group_ouvrier')
        cls.chef = cls._create_buildo_user('accueil_chef', 'buildo_gestion_chantier.group_chef_chantier')
        for user in cls.ouvrier | cls.chef:
            user.password = user.login
        cls.mes_heures = cls.env.ref('buildo_gestion_chantier.action_mes_heures')

    def _accueil(self, user):
        self.authenticate(user.login, user.login)
        return self.make_jsonrpc_request('/web/session/get_session_info')['home_action_id']

    def test_ouvrier_arrive_sur_mes_heures(self):
        self.assertEqual(self._accueil(self.ouvrier), self.mes_heures.id)

    def test_chef_et_accueil_choisi_inchanges(self):
        self.assertFalse(self._accueil(self.chef))
        tableau = self.env.ref('buildo_gestion_chantier.action_chantier_tache')
        self.ouvrier.action_id = tableau.id
        self.assertEqual(self._accueil(self.ouvrier), tableau.id, "Un accueil choisi par l'admin est respecté")

    def test_pas_de_discussion_odoobot(self):
        self.assertFalse(self.ouvrier.odoobot_state)
        self.ouvrier.with_user(self.ouvrier)._on_webclient_bootstrap()
        self.assertEqual(self.ouvrier.odoobot_state, 'disabled')
        odoobot = self.env.ref('base.partner_root')
        chat = self.env['discuss.channel'].search([
            ('channel_type', '=', 'chat'), ('channel_member_ids.partner_id', '=', self.ouvrier.partner_id.id),
            ('channel_member_ids.partner_id', '=', odoobot.id)])
        self.assertFalse(chat)
