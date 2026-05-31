from odoo import models, fields, api


class ChantierCommandeFournisseur(models.Model):
    _name = 'chantier.commande.fournisseur'
    _description = 'Commande d\'achat fournisseur'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _order = 'date desc, id desc'

    name = fields.Char('Référence', readonly=True, copy=False, default='Nouveau')
    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    fournisseur_id = fields.Many2one('res.partner', 'Fournisseur',
                                     domain=[('supplier_rank', '>', 0)])
    date = fields.Date('Date', required=True, default=fields.Date.today)
    date_livraison_prevue = fields.Date('Date de livraison prévue')
    ligne_ids = fields.One2many('chantier.commande.fournisseur.ligne', 'commande_id', 'Lignes')
    montant_total = fields.Monetary('Montant total', compute='_compute_total', store=True,
                                    currency_field='currency_id')
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    state = fields.Selection([
        ('brouillon', 'Brouillon'),
        ('envoye', 'Envoyé'),
        ('recu', 'Reçu'),
        ('annule', 'Annulé'),
    ], default='brouillon', string='État', tracking=True)
    note = fields.Text('Note')

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('name', 'Nouveau') == 'Nouveau':
                vals['name'] = self.env['ir.sequence'].next_by_code('chantier.commande.fournisseur') or 'Nouveau'
        return super().create(vals_list)

    @api.depends('ligne_ids.sous_total')
    def _compute_total(self):
        for rec in self:
            rec.montant_total = sum(rec.ligne_ids.mapped('sous_total'))

    def action_envoyer(self):
        self.write({'state': 'envoye'})

    def action_receptionner(self):
        self.write({'state': 'recu'})
        for ligne in self.ligne_ids:
            if ligne.materiau_id:
                ligne.materiau_id.stock_disponible += ligne.quantite

    def action_annuler(self):
        self.write({'state': 'annule'})
