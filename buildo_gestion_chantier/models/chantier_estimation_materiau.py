from odoo import models, fields, api
from odoo.exceptions import ValidationError, UserError


class ChantierEstimationMateriau(models.Model):
    _name = 'chantier.estimation.materiau'
    _description = 'Estimation de matériaux pour un chantier'
    _order = 'chantier_id, materiau_id'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    materiau_id = fields.Many2one('chantier.materiau', 'Matériau', required=True)
    quantite_estimee = fields.Float('Quantité estimée', required=True)
    unite = fields.Selection(related='materiau_id.unite', readonly=True)
    prix_unitaire = fields.Monetary('Prix unitaire', related='materiau_id.prix_unitaire',
                                    currency_field='currency_id', readonly=True)
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    montant_estime = fields.Monetary('Montant estimé', compute='_compute_montant', store=True,
                                     currency_field='currency_id')
    stock_disponible = fields.Float('Stock disponible', related='materiau_id.stock_disponible', readonly=True)
    quantite_manquante = fields.Float('Quantité manquante', compute='_compute_manquant', store=True)
    note = fields.Text('Note')

    @api.constrains('quantite_estimee')
    def _check_quantite(self):
        for rec in self:
            if rec.quantite_estimee <= 0:
                raise ValidationError("La quantité estimée doit être supérieure à 0.")

    @api.depends('quantite_estimee', 'prix_unitaire')
    def _compute_montant(self):
        for rec in self:
            rec.montant_estime = rec.quantite_estimee * rec.prix_unitaire

    @api.depends('quantite_estimee', 'stock_disponible')
    def _compute_manquant(self):
        for rec in self:
            manquant = rec.quantite_estimee - rec.stock_disponible
            rec.quantite_manquante = manquant if manquant > 0 else 0.0

    def action_generer_commande(self):
        lignes = self.filtered(
            lambda r: r.quantite_manquante > 0 and r.materiau_id.product_id
        )
        if not lignes:
            raise UserError(
                "Aucune ligne avec stock insuffisant et produit Odoo lié. "
                "Associez un produit Odoo à chaque matériau pour générer une commande."
            )
        chantier = lignes[0].chantier_id
        po = self.env['purchase.order'].create({
            'chantier_id': chantier.id,
            'order_line': [(0, 0, {
                'product_id': ligne.materiau_id.product_id.id,
                'name': ligne.materiau_id.name,
                'product_qty': ligne.quantite_manquante,
                'price_unit': ligne.prix_unitaire,
                'date_planned': fields.Datetime.now(),
            }) for ligne in lignes],
        })
        return {
            'type': 'ir.actions.act_window',
            'res_model': 'purchase.order',
            'res_id': po.id,
            'view_mode': 'form',
        }
