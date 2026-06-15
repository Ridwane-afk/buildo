from odoo import models, fields, api
from odoo.exceptions import ValidationError


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
        """Génère une commande fournisseur pour les matériaux manquants (F15)."""
        lignes_manquantes = self.filtered(lambda r: r.quantite_manquante > 0)
        if not lignes_manquantes:
            return
        chantier = lignes_manquantes[0].chantier_id
        commande = self.env['chantier.commande.fournisseur'].create({
            'chantier_id': chantier.id,
            'date': fields.Date.today(),
            'ligne_ids': [(0, 0, {
                'materiau_id': ligne.materiau_id.id,
                'quantite': ligne.quantite_manquante,
                'prix_unitaire': ligne.prix_unitaire,
            }) for ligne in lignes_manquantes],
        })
        return {
            'type': 'ir.actions.act_window',
            'res_model': 'chantier.commande.fournisseur',
            'res_id': commande.id,
            'view_mode': 'form',
        }
