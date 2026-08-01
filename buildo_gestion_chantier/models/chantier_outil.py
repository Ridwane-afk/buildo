from odoo import models, fields, api


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
    attribution_ids = fields.One2many('chantier.attribution.outil', 'outil_id', string='Attributions')
    attribue_a_id = fields.Many2one(
        'res.users',
        string='Attribué à',
        compute='_compute_attribution_en_cours',
        store=True,
    )
    date_retour_prevue = fields.Date(
        string='Date de retour prévue',
        compute='_compute_attribution_en_cours',
        store=True,
    )

    @api.depends('attribution_ids.state', 'attribution_ids.ouvrier_id', 'attribution_ids.date_retour_prevue')
    def _compute_attribution_en_cours(self):
        for outil in self:
            attribution_en_cours = outil.attribution_ids.filtered(lambda a: a.state == 'attribue')[:1]
            outil.attribue_a_id = attribution_en_cours.ouvrier_id
            outil.date_retour_prevue = attribution_en_cours.date_retour_prevue
