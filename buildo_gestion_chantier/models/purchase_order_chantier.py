from odoo import models, fields


class PurchaseOrder(models.Model):
    _inherit = 'purchase.order'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', ondelete='set null', tracking=True)
