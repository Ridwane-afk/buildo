from odoo import models, fields, api
from odoo.exceptions import ValidationError


class ChantierDevis(models.Model):
    _name = 'chantier.devis'
    _description = 'Devis pour un chantier'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _order = 'date desc, id desc'

    name = fields.Char('Référence', readonly=True, copy=False, default='Nouveau')
    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    client_id = fields.Many2one('res.partner', 'Client', related='chantier_id.client_id', readonly=True)
    date = fields.Date('Date du devis', required=True, default=fields.Date.today)
    date_validite = fields.Date('Valide jusqu\'au')
    state = fields.Selection([
        ('brouillon', 'Brouillon'),
        ('envoye', 'Envoyé'),
        ('accepte', 'Accepté'),
        ('refuse', 'Refusé'),
        ('annule', 'Annulé'),
    ], default='brouillon', string='État', tracking=True)
    ligne_ids = fields.One2many('chantier.devis.ligne', 'devis_id', 'Lignes du devis')
    avenant_ids = fields.One2many('chantier.avenant', 'devis_id', 'Avenants')
    facture_ids = fields.One2many('chantier.facture', 'devis_id', 'Factures')
    montant_ht = fields.Monetary('Montant HT', compute='_compute_montants', store=True,
                                 currency_field='currency_id')
    tva = fields.Monetary('TVA (21%)', compute='_compute_montants', store=True,
                          currency_field='currency_id')
    montant_ttc = fields.Monetary('Montant TTC', compute='_compute_montants', store=True,
                                  currency_field='currency_id')
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    note = fields.Text('Conditions et remarques')

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('name', 'Nouveau') == 'Nouveau':
                vals['name'] = self.env['ir.sequence'].next_by_code('chantier.devis') or 'Nouveau'
        return super().create(vals_list)

    @api.constrains('date', 'date_validite')
    def _check_dates(self):
        for rec in self:
            if rec.date and rec.date_validite and rec.date_validite < rec.date:
                raise ValidationError("La date de validité ne peut pas être antérieure à la date du devis.")

    @api.depends('ligne_ids.sous_total', 'ligne_ids.quantite', 'ligne_ids.prix_unitaire')
    def _compute_montants(self):
        for rec in self:
            rec.montant_ht = sum(rec.ligne_ids.mapped('sous_total'))
            rec.tva = rec.montant_ht * 0.21
            rec.montant_ttc = rec.montant_ht + rec.tva

    def action_envoyer(self):
        self.write({'state': 'envoye'})

    def action_accepter(self):
        self.write({'state': 'accepte'})

    def action_refuser(self):
        self.write({'state': 'refuse'})

    def action_annuler(self):
        self.write({'state': 'annule'})

    def action_reset_draft(self):
        self.write({'state': 'brouillon'})
