import base64
import logging

import requests

from odoo import models, fields
from odoo.exceptions import UserError

_logger = logging.getLogger(__name__)


class ChantierAssistantIA(models.TransientModel):
    _name = 'chantier.assistant.ia'
    _description = 'Assistant IA — Analyse de chantier'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True)
    question = fields.Text('Question / Description du problème', required=True)
    image = fields.Binary('Photo du problème')
    image_name = fields.Char()
    reponse = fields.Text('Réponse de l\'assistant', readonly=True)

    def _get_api_key(self):
        key = self.env['ir.config_parameter'].sudo().get_param('buildo.openai.api_key')
        if not key:
            raise UserError(
                "Clé API OpenAI non configurée. Allez dans Paramètres > "
                "Paramètres techniques > Paramètres système et ajoutez "
                "la clé 'buildo.openai.api_key'."
            )
        return key

    def _construire_contexte(self):
        c = self.chantier_id
        etats = dict(c._fields['state'].selection)
        taches = c.tache_ids.filtered(lambda t: t.state == 'en_cours').mapped('name')
        manquants = c.estimation_materiau_ids.filtered(lambda e: e.quantite_manquante > 0)
        lignes = [
            f"{e.materiau_id.name} ({e.quantite_manquante:.1f} {e.unite})"
            for e in manquants
        ]
        return (
            f"Chantier : {c.name}\n"
            f"État : {etats.get(c.state, c.state)}\n"
            f"Adresse : {c.adresse or 'non renseignée'}\n"
            f"Budget initial : {c.budget_initial:.2f} {c.currency_id.symbol}\n"
            f"Coût réel : {c.cout_reel:.2f} {c.currency_id.symbol}\n"
            f"Marge : {c.marge:.2f} {c.currency_id.symbol}\n"
            f"Heures validées : {c.nb_heures:.1f} h\n"
            f"Avancement : {c.avancement:.1f} %\n"
            f"Tâches en cours : {', '.join(taches) or 'aucune'}\n"
            f"Matériaux manquants : {', '.join(lignes) or 'aucun'}"
        )

    def action_analyser(self):
        api_key = self._get_api_key()
        contexte = self._construire_contexte()

        system_prompt = (
            "Tu es un expert en bâtiment et travaux publics (BTP) spécialisé "
            "pour le marché belge. Tu maîtrises les techniques de construction, "
            "les normes belges (NBN), la prévention et sécurité sur chantier, "
            "les matériaux et leur mise en œuvre. Tu analyses les problèmes de "
            "chantier avec pragmatisme et proposes des solutions concrètes.\n\n"
            f"Contexte du chantier :\n{contexte}\n\n"
            "Réponds en français, de façon précise et pratique. Si une photo "
            "est fournie, commence par décrire ce que tu observes avant de "
            "proposer une solution."
        )

        user_content = [{'type': 'text', 'text': self.question}]

        if self.image:
            image_b64 = base64.b64encode(self.image).decode('utf-8')
            mime = 'image/jpeg'
            if self.image_name:
                ext = self.image_name.lower().rsplit('.', 1)[-1]
                mime = {
                    'png': 'image/png',
                    'gif': 'image/gif',
                    'webp': 'image/webp',
                }.get(ext, 'image/jpeg')
            user_content.append({
                'type': 'image_url',
                'image_url': {'url': f'data:{mime};base64,{image_b64}'},
            })

        try:
            resp = requests.post(
                'https://api.openai.com/v1/chat/completions',
                headers={
                    'Authorization': f'Bearer {api_key}',
                    'Content-Type': 'application/json',
                },
                json={
                    'model': 'gpt-4o',
                    'messages': [
                        {'role': 'system', 'content': system_prompt},
                        {'role': 'user', 'content': user_content},
                    ],
                    'max_tokens': 1000,
                },
                timeout=30,
            )
            resp.raise_for_status()
            self.reponse = resp.json()['choices'][0]['message']['content']
        except requests.exceptions.Timeout:
            raise UserError(
                "L'API OpenAI n'a pas répondu dans le délai imparti. Réessayez."
            )
        except requests.exceptions.HTTPError:
            raise UserError(
                f"Erreur API OpenAI ({resp.status_code}) : {resp.text[:300]}"
            )
        except Exception as e:
            _logger.exception("Erreur inattendue lors de l'appel OpenAI")
            raise UserError(f"Erreur inattendue : {e}")

        return {
            'type': 'ir.actions.act_window',
            'res_model': self._name,
            'res_id': self.id,
            'view_mode': 'form',
            'target': 'new',
        }
