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
        if 'ouvrier_id' in vals and vals['ouvrier_id'] != self.env.uid:
            raise AccessError(_("Un ouvrier ne peut encoder que pour lui-même."))

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            self._check_droit_validation(vals)
        return super().create(vals_list)

    def write(self, vals):
        self._check_droit_validation(vals)
        if not self._est_chef() and any(rec.state == 'valide' for rec in self):
            raise AccessError(_("Un enregistrement validé ne peut être modifié que par un chef de chantier."))
        res = super().write(vals)
        if vals.get('state') == 'soumis':
            self._planifier_activite_validation()
        elif 'state' in vals:
            self._cloturer_activite_validation()
        return res

    # ------------------------------------------------------------------
    # Alerte au chef de chantier : une activité « à valider » par soumission,
    # clôturée automatiquement dès qu'il valide, refuse ou remet en brouillon.
    # ------------------------------------------------------------------

    def _activites_validation(self, chef):
        todo = self.env.ref('mail.mail_activity_data_todo')
        return self.activity_ids.filtered(lambda a: a.activity_type_id == todo and a.user_id == chef)

    def _planifier_activite_validation(self):
        for rec in self.sudo():
            chef = rec.chantier_id.chef_chantier_id
            # Pas d'alerte au chef qui encode lui-même, ni de doublon si une activité est déjà ouverte.
            if not chef or chef == self.env.user or rec._activites_validation(chef):
                continue
            rec.activity_schedule(
                'mail.mail_activity_data_todo',
                user_id=chef.id,
                summary=_("À valider : %(objet)s", objet=rec.display_name),
                note=_("Soumis par %(auteur)s sur le chantier %(chantier)s.",
                       auteur=self.env.user.name, chantier=rec.chantier_id.name),
            )

    def _cloturer_activite_validation(self):
        etats = dict(self._fields['state']._description_selection(self.env))
        for rec in self.sudo():
            activites = rec._activites_validation(rec.chantier_id.chef_chantier_id)
            if activites:
                activites.action_feedback(feedback=etats.get(rec.state, rec.state))
