from odoo import models


class ResUsersAccueil(models.Model):
    _inherit = 'res.users'

    def _on_webclient_bootstrap(self):
        # OdooBot ouvre une discussion de bienvenue à la première connexion : sur téléphone,
        # elle recouvre tout l'écran avant même que l'ouvrier puisse pointer.
        if self.odoobot_state in (False, 'not_initialized') and self.has_group('buildo_gestion_chantier.group_ouvrier'):
            self.sudo().odoobot_state = 'disabled'
        super()._on_webclient_bootstrap()


class IrHttpAccueil(models.AbstractModel):
    _inherit = 'ir.http'

    def session_info(self):
        info = super().session_info()
        # Sans page d'accueil choisie, Odoo ouvre la messagerie. L'ouvrier arrive plutôt sur
        # « Mes heures », là où se trouvent Arrivée et Départ. Le chef garde l'accueil d'Odoo.
        user = self.env.user
        if (not info.get('home_action_id') and user.has_group('buildo_gestion_chantier.group_ouvrier')
                and not user.has_group('buildo_gestion_chantier.group_chef_chantier')):
            info['home_action_id'] = self.env.ref('buildo_gestion_chantier.action_mes_heures').id
        return info
