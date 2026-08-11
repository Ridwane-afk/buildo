from odoo import models, fields, api


class AccountMove(models.Model):
    _inherit = 'account.move'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', ondelete='set null', tracking=True)
    pourcentage_avancement = fields.Float('Avancement facturé (%)')
    tache_a_facturer_ids = fields.Many2many(
        'chantier.tache',
        compute='_compute_tache_a_facturer',
        string='Tâches terminées à facturer',
    )

    @api.depends('partner_id', 'move_type')
    def _compute_tache_a_facturer(self):
        Tache = self.env['chantier.tache']
        for move in self:
            if move.move_type == 'out_invoice' and move.partner_id:
                move.tache_a_facturer_ids = Tache.search([
                    ('chantier_id.client_id.commercial_partner_id', '=', move.partner_id.commercial_partner_id.id),
                    ('state', '=', 'fait'),
                    '|',
                        ('facture_id', '=', False),
                        ('facture_id.state', '=', 'cancel'),
                ])
            else:
                move.tache_a_facturer_ids = False

    def action_ouvrir_wizard_taches(self):
        self.ensure_one()
        return {
            'type': 'ir.actions.act_window',
            'res_model': 'chantier.wizard.facturation.taches',
            'view_mode': 'form',
            'target': 'new',
            'context': {'active_id': self.id},
        }
