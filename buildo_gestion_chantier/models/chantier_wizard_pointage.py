from odoo import models, fields


class ChantierWizardPointage(models.TransientModel):
    _name = 'chantier.wizard.pointage'
    _description = "Choix du chantier au pointage d'arrivée"

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True,
                                  domain=[('state', '=', 'en_cours')])

    def action_confirmer(self):
        return self.env['chantier.heure.prestee'].action_pointer_arrivee(self.chantier_id.id)
