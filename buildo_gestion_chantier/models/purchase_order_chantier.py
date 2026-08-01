from odoo import models, fields, api


class PurchaseOrder(models.Model):
    _inherit = 'purchase.order'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', ondelete='set null', tracking=True)

    @api.model_create_multi
    def create(self, vals_list):
        orders = super().create(vals_list)
        orders._enregistrer_fournisseur_materiaux()
        return orders

    def write(self, vals):
        res = super().write(vals)
        if 'partner_id' in vals:
            self._enregistrer_fournisseur_materiaux()
        return res

    def _enregistrer_fournisseur_materiaux(self):
        """Mémorise le fournisseur choisi sur les produits commandés, pour
        que la prochaine génération de commande (chantier.estimation.materiau)
        le propose automatiquement."""
        for order in self:
            if not order.chantier_id or not order.partner_id:
                continue
            for line in order.order_line:
                if not line.product_id:
                    continue
                template = line.product_id.product_tmpl_id
                deja_connu = template.seller_ids.filtered(lambda s: s.partner_id == order.partner_id)
                if not deja_connu:
                    self.env['product.supplierinfo'].create({
                        'partner_id': order.partner_id.id,
                        'product_tmpl_id': template.id,
                        'price': line.price_unit,
                    })
