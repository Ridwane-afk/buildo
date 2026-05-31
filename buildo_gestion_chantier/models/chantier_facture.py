from odoo import models, fields, api
from odoo.exceptions import UserError


class ChantierFacture(models.Model):
    _name = 'chantier.facture'
    _description = 'Facture de chantier (proforma + finale)'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _order = 'date desc, id desc'

    name = fields.Char('Numéro de facture', readonly=True, copy=False, default='Nouveau')
    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    devis_id = fields.Many2one('chantier.devis', 'Devis lié',
                               domain="[('chantier_id', '=', chantier_id), ('state', '=', 'accepte')]")
    client_id = fields.Many2one('res.partner', 'Client', related='chantier_id.client_id', readonly=True)
    date = fields.Date('Date de facturation', required=True, default=fields.Date.today)
    date_echeance = fields.Date('Date d\'échéance')
    type_facture = fields.Selection([
        ('proforma', 'Proforma'),
        ('avancement', 'Par avancement'),
        ('finale', 'Finale'),
    ], string='Type', default='avancement', required=True)
    pourcentage_avancement = fields.Float('Avancement facturé (%)')
    montant_ht = fields.Monetary('Montant HT', currency_field='currency_id')
    tva = fields.Monetary('TVA (21%)', compute='_compute_tva', store=True, currency_field='currency_id')
    montant_total = fields.Monetary('Montant TTC', compute='_compute_total', store=True,
                                    currency_field='currency_id')
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    state = fields.Selection([
        ('brouillon', 'Brouillon'),
        ('envoyee', 'Envoyée'),
        ('payee', 'Payée'),
        ('annulee', 'Annulée'),
    ], default='brouillon', string='État', tracking=True)
    note = fields.Text('Note')

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('name', 'Nouveau') == 'Nouveau':
                vals['name'] = self.env['ir.sequence'].next_by_code('chantier.facture') or 'Nouveau'
        return super().create(vals_list)

    @api.depends('montant_ht')
    def _compute_tva(self):
        for rec in self:
            rec.tva = rec.montant_ht * 0.21

    @api.depends('montant_ht', 'tva')
    def _compute_total(self):
        for rec in self:
            rec.montant_total = rec.montant_ht + rec.tva

    def action_envoyer(self):
        self.write({'state': 'envoyee'})

    def action_marquer_payee(self):
        self.write({'state': 'payee'})

    def action_annuler(self):
        if self.state == 'payee':
            raise UserError("Impossible d'annuler une facture déjà payée.")
        self.write({'state': 'annulee'})
