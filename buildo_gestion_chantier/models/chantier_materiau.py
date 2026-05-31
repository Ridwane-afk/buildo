from odoo import models, fields


class ChantierMateriau(models.Model):
    _name = 'chantier.materiau'
    _description = 'Catalogue des matériaux'
    _order = 'name'

    name = fields.Char('Nom du matériau', required=True)
    ref_interne = fields.Char('Référence interne')
    categorie = fields.Selection([
        ('beton', 'Béton / Ciment'),
        ('bois', 'Bois'),
        ('metal', 'Métal / Acier'),
        ('isolation', 'Isolation'),
        ('toiture', 'Toiture'),
        ('finition', 'Finition'),
        ('electricite', 'Électricité'),
        ('plomberie', 'Plomberie'),
        ('autre', 'Autre'),
    ], string='Catégorie', default='autre')
    unite = fields.Selection([
        ('m', 'm'),
        ('m2', 'm²'),
        ('m3', 'm³'),
        ('kg', 'kg'),
        ('tonne', 'tonne'),
        ('piece', 'pièce'),
        ('sac', 'sac'),
        ('litre', 'litre'),
    ], string='Unité', default='piece')
    prix_unitaire = fields.Monetary('Prix unitaire (€)', currency_field='currency_id')
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    stock_disponible = fields.Float('Stock disponible')
    seuil_alerte = fields.Float('Seuil d\'alerte stock')
    description = fields.Text('Description')
    actif = fields.Boolean('Actif', default=True)
