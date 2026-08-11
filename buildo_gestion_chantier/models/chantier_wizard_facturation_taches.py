from odoo import models, fields, api
from odoo.exceptions import UserError


class ChantierWizardFacturationTaches(models.TransientModel):
    _name = 'chantier.wizard.facturation.taches'
    _description = 'Sélection des tâches terminées à facturer'

    move_id = fields.Many2one('account.move', required=True)
    tache_ids = fields.Many2many(
        'chantier.tache',
        relation='chantier_wizard_facturation_tache_rel',
        string='Tâches à facturer',
    )

    @api.model
    def default_get(self, fields_list):
        vals = super().default_get(fields_list)
        move = self.env['account.move'].browse(self.env.context.get('active_id'))
        vals['move_id'] = move.id
        vals['tache_ids'] = [(6, 0, move.tache_a_facturer_ids.ids)]
        return vals

    def action_ajouter(self):
        self.ensure_one()
        if not self.tache_ids:
            raise UserError("Sélectionnez au moins une tâche à facturer.")
        self.move_id.invoice_line_ids = [(0, 0, {
            'name': tache.name,
            'quantity': 1,
            'price_unit': tache.montant_facturable,
        }) for tache in self.tache_ids]
        self.tache_ids.write({'facture_id': self.move_id.id})
        return {'type': 'ir.actions.act_window_close'}
