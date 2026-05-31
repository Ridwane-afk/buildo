from odoo import models, fields, api


class ChantierCommandeFournisseurLigne(models.Model):
    _name = 'chantier.commande.fournisseur.ligne'
    _description = 'Ligne de commande fournisseur'
    _order = 'sequence, id'

    commande_id = fields.Many2one('chantier.commande.fournisseur', 'Commande',
                                  required=True, ondelete='cascade')
    sequence = fields.Integer('Séquence', default=10)
    materiau_id = fields.Many2one('chantier.materiau', 'Matériau')
    description = fields.Char('Description', required=True)
    quantite = fields.Float('Quantité', default=1.0)
    unite = fields.Char('Unité')
    prix_unitaire = fields.Monetary('Prix unitaire (€)', currency_field='currency_id')
    currency_id = fields.Many2one('res.currency', related='commande_id.currency_id')
    sous_total = fields.Monetary('Sous-total', compute='_compute_sous_total', store=True,
                                 currency_field='currency_id')

    @api.depends('quantite', 'prix_unitaire')
    def _compute_sous_total(self):
        for rec in self:
            rec.sous_total = rec.quantite * rec.prix_unitaire
