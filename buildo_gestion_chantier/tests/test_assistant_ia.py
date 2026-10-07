import base64
from unittest.mock import MagicMock, patch

from odoo.exceptions import UserError
from odoo.tests import tagged

from .common import ChantierTestCommon

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
