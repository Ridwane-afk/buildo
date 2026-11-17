from werkzeug.exceptions import NotFound

from odoo import http
from odoo.http import request


class OutilQrController(http.Controller):

    @http.route('/buildo/outil/<string:token>', type='http', auth='user')
    def scan_outil(self, token, **kwargs):
        """Lien du QR code collé sur l'outil : ouvre sa fiche, avec les boutons Prendre / Rendre."""
        outil = request.env['chantier.outil'].search([('qr_token', '=', token)], limit=1)
        if not outil:
            raise NotFound()
        return request.redirect('/odoo/action-buildo_gestion_chantier.action_chantier_outil/%s' % outil.id)
