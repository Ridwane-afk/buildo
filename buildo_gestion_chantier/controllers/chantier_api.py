import json

from odoo import http
from odoo.http import request
from odoo.exceptions import AccessError, MissingError, UserError, ValidationError

API_SCOPE = 'buildo_rest'

# Champs acceptés en écriture (création et modification) sur chantier.chantier.
# L'état (state) n'est volontairement pas modifiable ici : il passe par les
# actions métier (action_start, action_terminate, action_cancel) dans l'UI,
# pas par une écriture brute qui contournerait la logique associée.
WRITABLE_FIELDS = [
    'name', 'client_id', 'chef_chantier_id', 'adresse',
    'date_debut', 'date_fin_prevue', 'budget_initial', 'description',
]


class ApiAuthError(Exception):
    def __init__(self, message, status=401):
        super().__init__(message)
        self.message = message
        self.status = status


def _json_response(data, status=200):
    return request.make_response(
        json.dumps(data, default=str),
        status=status,
        headers=[('Content-Type', 'application/json')],
    )


def _json_error(message, status=400):
    return _json_response({'error': message}, status=status)


def _authenticate():
    """Valide la clé API envoyée par le client et retourne l'uid correspondant.

    La clé est attendue soit dans l'en-tête ``Authorization: Bearer <clé>``,
    soit dans l'en-tête ``X-API-Key``.
    """
    auth_header = request.httprequest.headers.get('Authorization', '')
    api_key = None
    if auth_header.lower().startswith('bearer '):
        api_key = auth_header[7:].strip()
    if not api_key:
        api_key = request.httprequest.headers.get('X-API-Key')
    if not api_key:
        raise ApiAuthError("Clé API manquante (en-tête Authorization: Bearer <clé> ou X-API-Key).")

    uid = request.env['res.users.apikeys']._check_credentials(scope=API_SCOPE, key=api_key)
    if not uid:
        raise ApiAuthError("Clé API invalide ou expirée.", status=401)
    return uid


def _chantier_to_dict(chantier):
    return {
        'id': chantier.id,
        'ref': chantier.ref,
        'name': chantier.name,
        'state': chantier.state,
        'client': {'id': chantier.client_id.id, 'name': chantier.client_id.name} if chantier.client_id else None,
        'chef_chantier': {'id': chantier.chef_chantier_id.id, 'name': chantier.chef_chantier_id.name}
            if chantier.chef_chantier_id else None,
        'adresse': chantier.adresse,
        'date_debut': chantier.date_debut,
        'date_fin_prevue': chantier.date_fin_prevue,
        'date_fin_reelle': chantier.date_fin_reelle,
        'description': chantier.description,
        'currency': chantier.currency_id.name,
        'budget_initial': chantier.budget_initial,
        'montant_avenants_acceptes': chantier.montant_avenants_acceptes,
        'budget_revise': chantier.budget_revise,
        'cout_main_oeuvre': chantier.cout_main_oeuvre,
        'cout_materiaux': chantier.cout_materiaux,
        'cout_reel': chantier.cout_reel,
        'montant_facture': chantier.montant_facture,
        'marge': chantier.marge,
        'avancement': chantier.avancement,
        'nb_heures': chantier.nb_heures,
    }


def _extract_writable_vals(payload):
    return {k: v for k, v in payload.items() if k in WRITABLE_FIELDS}


class ChantierApiController(http.Controller):

    @http.route('/api/v1/chantiers', type='http', auth='public', methods=['GET'], csrf=False)
    def list_chantiers(self, **kwargs):
        try:
            uid = _authenticate()
            request.update_env(user=uid)

            domain = []
            if kwargs.get('state'):
                domain.append(('state', '=', kwargs['state']))

            try:
                limit = min(int(kwargs.get('limit', 80)), 200)
            except ValueError:
                return _json_error("Le paramètre 'limit' doit être un entier.")
            try:
                offset = int(kwargs.get('offset', 0))
            except ValueError:
                return _json_error("Le paramètre 'offset' doit être un entier.")

            Chantier = request.env['chantier.chantier']
            total = Chantier.search_count(domain)
            chantiers = Chantier.search(domain, limit=limit, offset=offset, order='date_debut desc, id desc')
            return _json_response({
                'total': total,
                'limit': limit,
                'offset': offset,
                'results': [_chantier_to_dict(c) for c in chantiers],
            })
        except ApiAuthError as e:
            return _json_error(e.message, status=e.status)
        except AccessError as e:
            return _json_error(str(e), status=403)

    @http.route('/api/v1/chantiers/<int:chantier_id>', type='http', auth='public', methods=['GET'], csrf=False)
    def get_chantier(self, chantier_id, **kwargs):
        try:
            uid = _authenticate()
            request.update_env(user=uid)
            chantier = request.env['chantier.chantier'].browse(chantier_id)
            chantier.check_access('read')
            return _json_response(_chantier_to_dict(chantier))
        except ApiAuthError as e:
            return _json_error(e.message, status=e.status)
        except AccessError as e:
            return _json_error(str(e), status=403)
        except MissingError:
            return _json_error("Chantier introuvable.", status=404)

    @http.route('/api/v1/chantiers', type='http', auth='public', methods=['POST'], csrf=False)
    def create_chantier(self, **kwargs):
        try:
            uid = _authenticate()
            request.update_env(user=uid)
            try:
                payload = json.loads(request.httprequest.data or b'{}')
            except json.JSONDecodeError:
                return _json_error("Corps de requête JSON invalide.")

            if not payload.get('name') or not payload.get('client_id'):
                return _json_error("Les champs 'name' et 'client_id' sont obligatoires.")

            vals = _extract_writable_vals(payload)
            chantier = request.env['chantier.chantier'].create(vals)
            return _json_response(_chantier_to_dict(chantier), status=201)
        except ApiAuthError as e:
            return _json_error(e.message, status=e.status)
        except AccessError as e:
            return _json_error(str(e), status=403)
        except (UserError, ValidationError) as e:
            return _json_error(str(e), status=400)

    @http.route('/api/v1/chantiers/<int:chantier_id>', type='http', auth='public', methods=['PUT'], csrf=False)
    def update_chantier(self, chantier_id, **kwargs):
        try:
            uid = _authenticate()
            request.update_env(user=uid)
            chantier = request.env['chantier.chantier'].browse(chantier_id)
            chantier.check_access('write')

            try:
                payload = json.loads(request.httprequest.data or b'{}')
            except json.JSONDecodeError:
                return _json_error("Corps de requête JSON invalide.")

            vals = _extract_writable_vals(payload)
            if not vals:
                return _json_error(
                    "Aucun champ modifiable fourni. Champs autorisés : %s" % ', '.join(WRITABLE_FIELDS)
                )
            chantier.write(vals)
            return _json_response(_chantier_to_dict(chantier))
        except ApiAuthError as e:
            return _json_error(e.message, status=e.status)
        except AccessError as e:
            return _json_error(str(e), status=403)
        except MissingError:
            return _json_error("Chantier introuvable.", status=404)
        except (UserError, ValidationError) as e:
            return _json_error(str(e), status=400)

    @http.route('/api/v1/chantiers/<int:chantier_id>', type='http', auth='public', methods=['DELETE'], csrf=False)
    def delete_chantier(self, chantier_id, **kwargs):
        try:
            uid = _authenticate()
            request.update_env(user=uid)
            chantier = request.env['chantier.chantier'].browse(chantier_id)
            chantier.check_access('unlink')
            name = chantier.name
            chantier.unlink()
            return _json_response({'deleted': True, 'id': chantier_id, 'name': name})
        except ApiAuthError as e:
            return _json_error(e.message, status=e.status)
        except AccessError as e:
            return _json_error(str(e), status=403)
        except MissingError:
            return _json_error("Chantier introuvable.", status=404)
        except (UserError, ValidationError) as e:
            return _json_error(str(e), status=400)
