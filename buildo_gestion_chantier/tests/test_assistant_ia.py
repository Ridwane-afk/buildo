import base64
from unittest.mock import MagicMock, patch

from odoo.exceptions import UserError
from odoo.tests import tagged

from .common import ChantierTestCommon
from ..models.chantier_assistant_ia import markdown_vers_html

# Image PNG 1x1 pixel
PNG = base64.b64decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=='
)
REQUESTS_POST = 'odoo.addons.buildo_gestion_chantier.models.chantier_assistant_ia.requests.post'


@tagged('post_install', '-at_install')
class TestAssistantIA(ChantierTestCommon):

    def setUp(self):
        super().setUp()
        self.env['ir.config_parameter'].sudo().set_param('buildo.openai.api_key', 'cle-de-test')

    def _assistant(self, image):
        return self.env['chantier.assistant.ia'].create({
            'chantier_id': self.chantier.id, 'question': 'Fuite sous l\'évier, que faire ?',
            'image': base64.b64encode(image),
        })

    def test_photo_envoyee_correctement(self):
        """La photo part une seule fois encodée en base64, avec son vrai type MIME."""
        reponse = MagicMock()
        reponse.json.return_value = {'choices': [{'message': {'content': 'Couper l\'arrivée d\'eau.'}}]}
        with patch(REQUESTS_POST, return_value=reponse) as post:
            assistant = self._assistant(PNG)
            assistant.action_analyser()
        url = post.call_args.kwargs['json']['messages'][1]['content'][1]['image_url']['url']
        entete, donnees = url.split(',', 1)
        self.assertEqual(entete, 'data:image/png;base64')
        self.assertEqual(base64.b64decode(donnees), PNG)
        self.assertEqual(assistant.reponse, 'Couper l\'arrivée d\'eau.')

    def test_format_non_supporte_refuse_avant_appel(self):
        with patch(REQUESTS_POST) as post:
            with self.assertRaises(UserError):
                self._assistant(b'%PDF-1.4 ceci est un PDF').action_analyser()
        post.assert_not_called()

    def _payload_envoye(self, user):
        """Lance l'analyse avec l'utilisateur donné et renvoie ce qui part chez OpenAI."""
        reponse = MagicMock()
        reponse.json.return_value = {'choices': [{'message': {'content': 'ok'}}]}
        with patch(REQUESTS_POST, return_value=reponse) as post:
            self.env['chantier.assistant.ia'].with_user(user).create({
                'chantier_id': self.chantier.id, 'question': 'Quelle est la marge du chantier ?',
            }).action_analyser()
        return post.call_args.kwargs['json']['messages'][0]['content']

    def test_ouvrier_sans_donnees_financieres(self):
        g = 'buildo_gestion_chantier.group_%s'
        ouvrier = self._create_buildo_user('ia_ouvrier', g % 'ouvrier')
        chef = self._create_buildo_user('ia_chef', g % 'chef_chantier')
        self.chantier.chef_chantier_id = chef
        self.env['chantier.tache'].create({'name': 'Plomberie', 'chantier_id': self.chantier.id,
                                           'ouvrier_ids': [(6, 0, ouvrier.ids)]})
        # Le bouton Assistant IA est visible pour l'ouvrier
        arch = self.env['chantier.chantier'].with_user(ouvrier).get_views([(False, 'form')])['views']['form']['arch']
        self.assertIn('action_ouvrir_assistant', arch)

        prompt_ouvrier = self._payload_envoye(ouvrier)
        for interdit in ('Budget', 'Coût réel', 'Marge', 'Matériaux manquants'):
            self.assertNotIn(interdit, prompt_ouvrier)
        self.assertIn('Ton interlocuteur est un ouvrier', prompt_ouvrier)
        self.assertIn('Avancement', prompt_ouvrier)

        prompt_chef = self._payload_envoye(chef)
        self.assertIn('Budget initial : 10000.00', prompt_chef)
        self.assertNotIn('Ton interlocuteur est un ouvrier', prompt_chef)

    def test_reponse_mise_en_forme_et_securisee(self):
        html = markdown_vers_html("### Diagnostic\nLa **fuite** vient du raccord.\n1. Couper l'eau\n- Vérifier le joint\n"
                                  "<script>alert(1)</script>")
        self.assertIn('<h6>Diagnostic</h6>', html)
        self.assertIn('<strong>fuite</strong>', html)
        self.assertIn('<ol><li>', html)
        self.assertIn('<ul><li>', html)
        self.assertNotIn('<script>', html)
        self.assertIn('&lt;script&gt;', html)

    def test_nouvelle_question(self):
        assistant = self._assistant(PNG)
        action = assistant.action_nouvelle_question()
        self.assertEqual(action['res_model'], 'chantier.assistant.ia')
        self.assertFalse(action['res_id'])
        self.assertEqual(action['context'], {'default_chantier_id': self.chantier.id})
        self.assertEqual(action['name'], 'Assistant IA')

