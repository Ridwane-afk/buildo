from odoo import models, fields, api


class ChantierAvenant(models.Model):
    _name = 'chantier.avenant'
    _description = 'Avenant à un devis'
    _order = 'date desc, id desc'

    name = fields.Char('Référence avenant', readonly=True, copy=False, default='Nouveau')
    devis_id = fields.Many2one('chantier.devis', 'Devis initial', required=True, ondelete='cascade')
    chantier_id = fields.Many2one('chantier.chantier', related='devis_id.chantier_id', readonly=True)
    date = fields.Date('Date', required=True, default=fields.Date.today)
    motif = fields.Text('Motif de la modification', required=True)
    montant_ht = fields.Monetary('Montant HT de l\'avenant', currency_field='currency_id')
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    state = fields.Selection([
        ('brouillon', 'Brouillon'),
        ('accepte', 'Accepté'),
        ('refuse', 'Refusé'),
    ], default='brouillon', string='État')
    note = fields.Text('Note')

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('name', 'Nouveau') == 'Nouveau':
                vals['name'] = self.env['ir.sequence'].next_by_code('chantier.avenant') or 'Nouveau'
        return super().create(vals_list)

    def action_accepter(self):
        self.write({'state': 'accepte'})

    def action_refuser(self):
        self.write({'state': 'refuse'})
