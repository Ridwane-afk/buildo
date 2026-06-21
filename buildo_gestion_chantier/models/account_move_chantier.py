from odoo import models, fields


class AccountMove(models.Model):
    _inherit = 'account.move'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', ondelete='set null', tracking=True)
    pourcentage_avancement = fields.Float('Avancement facturé (%)')
