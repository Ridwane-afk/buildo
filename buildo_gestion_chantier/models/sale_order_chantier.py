from odoo import models, fields


class SaleOrder(models.Model):
    _inherit = 'sale.order'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', ondelete='set null', tracking=True)
    avenant_ids = fields.One2many('chantier.avenant', 'sale_order_id', 'Avenants')
    pourcentage_avancement = fields.Float('Avancement chantier (%)')
