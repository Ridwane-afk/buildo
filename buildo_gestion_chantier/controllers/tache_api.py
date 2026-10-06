import json

from odoo import http
from odoo.http import request
from odoo.exceptions import AccessError, MissingError, UserError, ValidationError

from .chantier_api import ApiAuthError, _authenticate, _json_error, _json_response

# Champs acceptés en écriture sur chantier.tache. Comme pour les chantiers,
# l'état (state) passe par les actions métier (Démarrer / Valider / Bloquer)
# et n'est pas modifiable directement par l'API.
WRITABLE_FIELDS = [
    'name', 'chantier_id', 'responsable_id', 'ouvrier_ids',
    'date_debut', 'date_fin', 'description', 'avancement',
]


def _tache_to_dict(tache):
    return {
        'id': tache.id,
        'name': tache.name,
        'chantier': {'id': tache.chantier_id.id, 'name': tache.chantier_id.name},
        'responsable': {'id': tache.responsable_id.id, 'name': tache.responsable_id.name}
            if tache.responsable_id else None,
        'ouvriers': [{'id': u.id, 'name': u.name} for u in tache.ouvrier_ids],
        'state': tache.state,
        'avancement': tache.avancement,
        'date_debut': tache.date_debut,
        'date_fin': tache.date_fin,
        'date_fin_reelle': tache.date_fin_reelle,
        'description': tache.description,
    }


def _extract_writable_vals(payload):
    vals = {k: v for k, v in payload.items() if k in WRITABLE_FIELDS}
    if 'ouvrier_ids' in vals:
        # Liste d'ids d'utilisateurs : remplace l'équipe assignée
        vals['ouvrier_ids'] = [(6, 0, vals['ouvrier_ids'] or [])]
    return vals


def _read_payload():
    try:
        return json.loads(request.httprequest.data or b'{}')
    except json.JSONDecodeError:
        return None


class TacheApiController(http.Controller):

    @http.route('/api/v1/taches', type='http', auth='public', methods=['GET'], csrf=False)
    def list_taches(self, **kwargs):
        try:
            uid = _authenticate()
            request.update_env(user=uid)

            domain = []
            try:
                if kwargs.get('chantier_id'):
                    domain.append(('chantier_id', '=', int(kwargs['chantier_id'])))
                limit = min(int(kwargs.get('limit', 80)), 200)
                offset = int(kwargs.get('offset', 0))
            except ValueError:
                return _json_error("Les paramètres 'chantier_id', 'limit' et 'offset' doivent être des entiers.")
            if kwargs.get('state'):
                domain.append(('state', '=', kwargs['state']))

            Tache = request.env['chantier.tache']
            taches = Tache.search(domain, limit=limit, offset=offset)
            return _json_response({
                'total': Tache.search_count(domain),
                'limit': limit,
                'offset': offset,
                'results': [_tache_to_dict(t) for t in taches],
            })
        except ApiAuthError as e:
            return _json_error(e.message, status=e.status)
        except AccessError as e:
            return _json_error(str(e), status=403)

    @http.route('/api/v1/taches/<int:tache_id>', type='http', auth='public', methods=['GET'], csrf=False)
    def get_tache(self, tache_id, **kwargs):
        try:
            uid = _authenticate()
            request.update_env(user=uid)
            tache = request.env['chantier.tache'].browse(tache_id)
            tache.check_access('read')
            return _json_response(_tache_to_dict(tache))
        except ApiAuthError as e:
            return _json_error(e.message, status=e.status)
        except AccessError as e:
            return _json_error(str(e), status=403)
        except MissingError:
            return _json_error("Tâche introuvable.", status=404)

    @http.route('/api/v1/taches', type='http', auth='public', methods=['POST'], csrf=False)
    def create_tache(self, **kwargs):
        try:
            uid = _authenticate()
            request.update_env(user=uid)
            payload = _read_payload()
            if payload is None:
                return _json_error("Corps de requête JSON invalide.")
            if not payload.get('name') or not payload.get('chantier_id'):
                return _json_error("Les champs 'name' et 'chantier_id' sont obligatoires.")

            tache = request.env['chantier.tache'].create(_extract_writable_vals(payload))
            return _json_response(_tache_to_dict(tache), status=201)
        except ApiAuthError as e:
            return _json_error(e.message, status=e.status)
        except AccessError as e:
            return _json_error(str(e), status=403)
        except (UserError, ValidationError) as e:
            return _json_error(str(e), status=400)

    @http.route('/api/v1/taches/<int:tache_id>', type='http', auth='public', methods=['PUT'], csrf=False)
    def update_tache(self, tache_id, **kwargs):
        try:
            uid = _authenticate()
            request.update_env(user=uid)
            tache = request.env['chantier.tache'].browse(tache_id)
            tache.check_access('write')
            payload = _read_payload()
            if payload is None:
                return _json_error("Corps de requête JSON invalide.")

            vals = _extract_writable_vals(payload)
            if not vals:
                return _json_error(
                    "Aucun champ modifiable fourni. Champs autorisés : %s" % ', '.join(WRITABLE_FIELDS)
                )
            tache.write(vals)
            return _json_response(_tache_to_dict(tache))
        except ApiAuthError as e:
            return _json_error(e.message, status=e.status)
        except AccessError as e:
            return _json_error(str(e), status=403)
        except MissingError:
            return _json_error("Tâche introuvable.", status=404)
        except (UserError, ValidationError) as e:
            return _json_error(str(e), status=400)

    @http.route('/api/v1/taches/<int:tache_id>', type='http', auth='public', methods=['DELETE'], csrf=False)
    def delete_tache(self, tache_id, **kwargs):
        try:
            uid = _authenticate()
            request.update_env(user=uid)
            tache = request.env['chantier.tache'].browse(tache_id)
            tache.check_access('unlink')
            name = tache.name
            tache.unlink()
            return _json_response({'deleted': True, 'id': tache_id, 'name': name})
        except ApiAuthError as e:
            return _json_error(e.message, status=e.status)
        except AccessError as e:
            return _json_error(str(e), status=403)
        except MissingError:
            return _json_error("Tâche introuvable.", status=404)
        except (UserError, ValidationError) as e:
            return _json_error(str(e), status=400)
