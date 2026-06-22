from odoo import models, fields, api
from odoo.exceptions import ValidationError


class ChantierDemandeMateriel(models.Model):
    _name = 'chantier.demande.materiel'
    _description = 'Demande de matériel par un ouvrier'
    _order = 'date desc, id desc'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    ouvrier_id = fields.Many2one('res.users', 'Ouvrier', required=True, default=lambda self: self.env.user)
    date = fields.Date('Date de demande', required=True, default=fields.Date.today)
    materiau_id = fields.Many2one('chantier.materiau', 'Matériau (optionnel)')
    description = fields.Char('Description du besoin', required=True)
    quantite = fields.Float('Quantité demandée', default=1.0)
    urgence = fields.Selection([
        ('normale', 'Normale'),
        ('urgente', 'Urgente'),
    ], default='normale', string='Urgence')
    state = fields.Selection([
        ('brouillon', 'Brouillon'),
        ('soumis', 'Soumis'),
        ('valide', 'Validé'),
        ('refuse', 'Refusé'),
    ], default='brouillon', string='État')
    validateur_id = fields.Many2one('res.users', 'Validé par', readonly=True)
    note = fields.Text('Note')

    @api.constrains('quantite')
    def _check_quantite(self):
        for rec in self:
            if rec.quantite <= 0:
                raise ValidationError("La quantité demandée doit être supérieure à 0.")

    def action_soumettre(self):
        self.write({'state': 'soumis'})

    def action_valider(self):
        self.write({'state': 'valide', 'validateur_id': self.env.user.id})

    def action_refuser(self):
        return {
            'type': 'ir.actions.act_window',
            'res_model': 'chantier.wizard.refus',
            'view_mode': 'form',
            'target': 'new',
            'context': {'active_model': self._name, 'active_ids': self.ids},
        }

    def action_reset(self):
        self.write({'state': 'brouillon', 'validateur_id': False})
