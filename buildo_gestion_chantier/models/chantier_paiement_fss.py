from odoo import models, fields


class ChantierPaiementFss(models.Model):
    _name = 'chantier.paiement.fss'
    _description = 'Paiement Fonds de Sécurité d\'Existence (FSS)'
    _order = 'date desc, id desc'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    ouvrier_id = fields.Many2one('res.users', 'Ouvrier concerné', required=True)
    date = fields.Date('Date du paiement', required=True, default=fields.Date.today)
    periode = fields.Char('Période (ex: Q1 2026)', required=True)
    montant = fields.Monetary('Montant FSS (€)', currency_field='currency_id', required=True)
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    state = fields.Selection([
        ('a_payer', 'À payer'),
        ('paye', 'Payé'),
    ], default='a_payer', string='État')
    reference_paiement = fields.Char('Référence de paiement')
    note = fields.Text('Note')

    def action_marquer_paye(self):
        self.write({'state': 'paye'})
