from odoo import models, fields, api


class ChantierDevisLigne(models.Model):
    _name = 'chantier.devis.ligne'
    _description = 'Ligne de devis'
    _order = 'sequence, id'

    devis_id = fields.Many2one('chantier.devis', 'Devis', required=True, ondelete='cascade')
    sequence = fields.Integer('Séquence', default=10)
    type_ligne = fields.Selection([
        ('main_oeuvre', 'Main d\'œuvre'),
        ('materiau', 'Matériau'),
        ('prestation', 'Prestation'),
        ('forfait', 'Forfait'),
    ], string='Type', default='prestation', required=True)
    name = fields.Char('Description', required=True)
    quantite = fields.Float('Quantité', default=1.0)
    unite = fields.Char('Unité')
    prix_unitaire = fields.Monetary('Prix unitaire (€)', currency_field='currency_id')
    currency_id = fields.Many2one('res.currency', related='devis_id.currency_id')
    sous_total = fields.Monetary('Sous-total', compute='_compute_sous_total', store=True,
                                 currency_field='currency_id')

    @api.depends('quantite', 'prix_unitaire')
    def _compute_sous_total(self):
        for rec in self:
            rec.sous_total = rec.quantite * rec.prix_unitaire
