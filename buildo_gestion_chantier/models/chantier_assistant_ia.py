import base64
import logging
import re

import requests
from markupsafe import Markup, escape

from odoo import api, models, fields, _
from odoo.exceptions import UserError
from odoo.tools.mimetypes import guess_mimetype

_logger = logging.getLogger(__name__)

# Formats d'image acceptés par l'API OpenAI
FORMATS_IMAGE_ACCEPTES = ('image/png', 'image/jpeg', 'image/gif', 'image/webp')


def _markdown_inline(texte):
    """Gras, italique et code en ligne, après échappement du HTML."""
    texte = str(escape(texte))
    texte = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', texte)
    texte = re.sub(r'(?<!\*)\*(?!\s)(.+?)(?<!\s)\*(?!\*)', r'<em>\1</em>', texte)
    return re.sub(r'`(.+?)`', r'<code>\1</code>', texte)


def markdown_vers_html(texte):
    """Convertit le Markdown simple renvoyé par l'IA (titres, listes, gras) en HTML sûr.

    Tout le texte est échappé avant mise en forme : une réponse contenant du
    HTML ou du JavaScript est affichée comme du texte, jamais exécutée.
    """
    html, liste = [], None
    for ligne in (texte or '').splitlines():
        brut = ligne.strip()
        puce = re.match(r'^[-*•]\s+(.*)', brut)
        numero = re.match(r'^\d+[.)]\s+(.*)', brut)
        titre = re.match(r'^#{1,6}\s+(.*)', brut)
        type_liste = 'ul' if puce else 'ol' if numero else None
        if liste and type_liste != liste:
            html.append('</%s>' % liste)
            liste = None
        if type_liste:
            if not liste:
                html.append('<%s>' % type_liste)
                liste = type_liste
            html.append('<li>%s</li>' % _markdown_inline((puce or numero).group(1)))
        elif titre:
            html.append('<h6>%s</h6>' % _markdown_inline(titre.group(1)))
        elif brut:
            html.append('<p>%s</p>' % _markdown_inline(brut))
    if liste:
        html.append('</%s>' % liste)
    return Markup(''.join(html))


class ChantierAssistantIA(models.TransientModel):
    _name = 'chantier.assistant.ia'
    _description = 'Assistant IA — Analyse de chantier'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True)
    question = fields.Text('Question / Description du problème', required=True)
    image = fields.Binary('Photo du problème')
    image_name = fields.Char()
    reponse = fields.Text('Réponse de l\'assistant', readonly=True)
    reponse_html = fields.Html('Réponse mise en forme', compute='_compute_reponse_html', sanitize=False)

    @api.depends('reponse')
    def _compute_reponse_html(self):
        for rec in self:
            rec.reponse_html = markdown_vers_html(rec.reponse)

    def _action_fenetre(self, res_id=False, context=None):
        return {
            'type': 'ir.actions.act_window',
            'name': _("Assistant IA"),
            'res_model': self._name,
            'res_id': res_id,
            'view_mode': 'form',
            'target': 'new',
            'context': context or {},
        }

    def action_nouvelle_question(self):
        """Rouvre l'assistant vide, sur le même chantier."""
        self.ensure_one()
        return self._action_fenetre(context={'default_chantier_id': self.chantier_id.id})

    def _get_api_key(self):
        key = self.env['ir.config_parameter'].sudo().get_param('buildo.openai.api_key')
        if not key:
            raise UserError(_(
                "Clé API OpenAI non configurée. Allez dans Paramètres > "
                "Paramètres techniques > Paramètres système et ajoutez "
                "la clé 'buildo.openai.api_key'."
            ))
        return key

    def _acces_finances(self):
        """Les données financières (et les estimations) sont réservées au chef de chantier et au-dessus."""
        return self.env.user.has_group('buildo_gestion_chantier.group_chef_chantier')

    def _construire_contexte(self):
        c = self.chantier_id
        etats = dict(c._fields['state'].selection)
        taches = c.tache_ids.filtered(lambda t: t.state == 'en_cours').mapped('name')
        lignes = [
            f"Chantier : {c.name}",
            f"État : {etats.get(c.state, c.state)}",
            f"Adresse : {c.adresse or 'non renseignée'}",
            f"Heures validées : {c.nb_heures:.1f} h",
            f"Avancement : {c.avancement:.1f} %",
            f"Tâches en cours : {', '.join(taches) or 'aucune'}",
        ]
        # Pour un ouvrier, aucune donnée financière n'est transmise à l'IA :
        # elle ne peut donc pas en révéler, même si on le lui demande.
        if self._acces_finances():
            manquants = c.estimation_materiau_ids.filtered(lambda e: e.quantite_manquante > 0)
            lignes += [
                f"Budget initial : {c.budget_initial:.2f} {c.currency_id.symbol}",
                f"Coût réel : {c.cout_reel:.2f} {c.currency_id.symbol}",
                f"Marge : {c.marge:.2f} {c.currency_id.symbol}",
                "Matériaux manquants : %s" % (', '.join(
                    f"{e.materiau_id.name} ({e.quantite_manquante:.1f} {e.unite})" for e in manquants
                ) or 'aucun'),
            ]
        return "\n".join(lignes)

    def action_analyser(self):
        api_key = self._get_api_key()
        contexte = self._construire_contexte()

        langue_reponse = {'nl_NL': 'néerlandais', 'nl_BE': 'néerlandais'}.get(self.env.user.lang, 'français')
        system_prompt = (
            "Tu es un expert en bâtiment et travaux publics (BTP) spécialisé "
            "pour le marché belge. Tu maîtrises les techniques de construction, "
            "les normes belges (NBN), la prévention et sécurité sur chantier, "
            "les matériaux et leur mise en œuvre. Tu analyses les problèmes de "
            "chantier avec pragmatisme et proposes des solutions concrètes.\n\n"
            f"Contexte du chantier :\n{contexte}\n\n"
            f"Réponds en {langue_reponse}, de façon précise et pratique. Si une "
            "photo est fournie, commence par décrire ce que tu observes avant de "
            "proposer une solution."
        )
        if not self._acces_finances():
            system_prompt += (
                "\n\nTon interlocuteur est un ouvrier. Ne donne aucune information "
                "financière (budget, coûts, marge, prix, montants, salaires). Si on te "
                "le demande, réponds que ces informations sont réservées au chef de "
                "chantier et concentre-toi sur la technique et la sécurité."
            )

        user_content = [{'type': 'text', 'text': self.question}]

        if self.image:
            # Un champ Binary Odoo contient déjà l'image encodée en base64 :
            # on l'envoie telle quelle (la ré-encoder la rendait illisible).
            image_b64 = self.image.decode() if isinstance(self.image, bytes) else self.image
            # Format détecté à partir du contenu, pas du nom de fichier
            mime = guess_mimetype(base64.b64decode(image_b64))
            if mime not in FORMATS_IMAGE_ACCEPTES:
                raise UserError(_(
                    "Format de photo non pris en charge (%(format)s). "
                    "Utilisez une image PNG, JPEG, GIF ou WEBP.",
                    format=mime,
                ))
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
            raise UserError(_(
                "L'API OpenAI n'a pas répondu dans le délai imparti. Réessayez."
            ))
        except requests.exceptions.HTTPError:
            raise UserError(_(
                "Erreur API OpenAI (%(status)s) : %(detail)s",
                status=resp.status_code, detail=resp.text[:300],
            ))
        except Exception as e:
            _logger.exception("Erreur inattendue lors de l'appel OpenAI")
            raise UserError(_("Erreur inattendue : %s", e))

        return self._action_fenetre(res_id=self.id)
