import operator as py_operator

from odoo import models, fields, api
from odoo.tools.sql import column_exists

OPERATEURS = {
    '=': py_operator.eq, '!=': py_operator.ne,
    '<': py_operator.lt, '<=': py_operator.le,
    '>': py_operator.gt, '>=': py_operator.ge,
}


def rechercher_par_calcul(records, fname, operator, value):
    """Recherche sur un champ calculé non stocké, en le calculant pour chaque enregistrement."""
    if operator not in OPERATEURS:
        return NotImplemented
    test = OPERATEURS[operator]
    ids = records.search([]).filtered(lambda r: test(r[fname], value)).ids
    return [('id', 'in', ids)]


class ChantierMateriau(models.Model):
    _name = 'chantier.materiau'
    _description = 'Catalogue des matériaux'
    _order = 'name'

    name = fields.Char('Nom du matériau', required=True)
    ref_interne = fields.Char('Référence interne')
    product_id = fields.Many2one(
        'product.product',
        'Produit Odoo',
        domain=[('type', 'in', ['consu', 'product'])],
    )
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
    # Le stock d'un produit Odoo (qty_available) est recalculé à chaque lecture et ne déclenche
    # aucun recalcul ailleurs : on le lit donc en direct au lieu de le recopier en base.
    stock_disponible = fields.Float(
        'Stock disponible',
        compute='_compute_stock_disponible',
        inverse='_inverse_stock_disponible',
        search='_search_stock_disponible',
        help="Stock réel de l'Inventaire si un produit Odoo est lié, sinon saisi à la main.",
    )
    stock_manuel = fields.Float('Stock saisi à la main')
    seuil_alerte = fields.Float('Seuil d\'alerte stock')
    description = fields.Text('Description')
    actif = fields.Boolean('Actif', default=True)
    en_alerte = fields.Boolean(
        'Sous le seuil d\'alerte',
        compute='_compute_en_alerte',
        search='_search_en_alerte',
    )

    def init(self):
        # Reprend une seule fois le stock saisi avant que le champ ne soit plus stocké.
        if column_exists(self.env.cr, self._table, 'stock_disponible'):
            self.env.cr.execute("""
                UPDATE chantier_materiau SET stock_manuel = stock_disponible
                 WHERE stock_manuel IS NULL AND stock_disponible IS NOT NULL
            """)

    @api.depends('product_id', 'stock_manuel')
    @api.depends_context('company')
    def _compute_stock_disponible(self):
        # Le chef et l'ouvrier n'ont pas les droits Inventaire : lire le stock d'un produit
        # parcourt les mouvements de stock, d'où le sudo (lecture seule, aucun droit accordé).
        for rec in self:
            rec.stock_disponible = rec.product_id.sudo().qty_available if rec.product_id else rec.stock_manuel

    def _inverse_stock_disponible(self):
        for rec in self.filtered(lambda r: not r.product_id):
            rec.stock_manuel = rec.stock_disponible

    def _search_stock_disponible(self, operator, value):
        return rechercher_par_calcul(self, 'stock_disponible', operator, value)

    def _search_en_alerte(self, operator, value):
        if operator not in ('=', '!=') or not isinstance(value, bool):
            return NotImplemented
        return rechercher_par_calcul(self, 'en_alerte', operator, value)

    @api.depends('stock_disponible', 'seuil_alerte')
    def _compute_en_alerte(self):
        for rec in self:
            rec.en_alerte = rec.stock_disponible <= rec.seuil_alerte
