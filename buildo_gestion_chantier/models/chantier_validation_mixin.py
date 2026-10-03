from odoo import models, api, _
from odoo.exceptions import AccessError


class ChantierValidationMixin(models.AbstractModel):
    """Workflow brouillon → soumis → validé/refusé réservé au chef de chantier.

    Un ouvrier peut créer, modifier et soumettre ses propres enregistrements,
    mais seul un chef de chantier peut les valider, les refuser ou modifier
    un enregistrement déjà validé. Le contrôle est fait côté serveur pour
    couvrir aussi les appels RPC, pas seulement les boutons de la vue.
    """
    _name = 'chantier.validation.mixin'
    _description = 'Validation par le chef de chantier'

    def _est_chef(self):
        return self.env.su or self.env.user.has_group('buildo_gestion_chantier.group_chef_chantier')

    def _check_droit_validation(self, vals):
        if self._est_chef():
            return
        if vals.get('state') in ('valide', 'refuse') or vals.get('validateur_id'):
            raise AccessError(_("Seul un chef de chantier peut valider ou refuser."))

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            self._check_droit_validation(vals)
        return super().create(vals_list)

    def write(self, vals):
        self._check_droit_validation(vals)
        if not self._est_chef() and any(rec.state == 'valide' for rec in self):
            raise AccessError(_("Un enregistrement validé ne peut être modifié que par un chef de chantier."))
        return super().write(vals)
