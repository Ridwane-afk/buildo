from odoo import models, fields


class ChantierOutil(models.Model):
    _name = 'chantier.outil'
    _description = 'Catalogue des outils'
    _order = 'name'

    name = fields.Char('Nom de l\'outil', required=True)
    ref_interne = fields.Char('Référence interne')
    categorie = fields.Selection([
        ('outillage_main', 'Outillage à main'),
        ('outillage_electrique', 'Outillage électrique'),
        ('levage', 'Levage / Manutention'),
        ('mesure', 'Mesure'),
        ('securite', 'Sécurité'),
        ('autre', 'Autre'),
    ], string='Catégorie', default='autre')
    etat = fields.Selection([
        ('disponible', 'Disponible'),
        ('attribue', 'Attribué'),
        ('maintenance', 'En maintenance'),
        ('hors_service', 'Hors service'),
    ], default='disponible', string='État')
    valeur_achat = fields.Monetary('Valeur d\'achat (€)', currency_field='currency_id')
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    date_achat = fields.Date('Date d\'achat')
    description = fields.Text('Description')
    actif = fields.Boolean('Actif', default=True)
