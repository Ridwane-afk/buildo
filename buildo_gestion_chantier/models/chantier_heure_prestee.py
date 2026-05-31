from odoo import models, fields, api


class ChantierHeurePrestee(models.Model):
    _name = 'chantier.heure.prestee'
    _description = "Heures prestées par un ouvrier sur un chantier"
    _order = 'date desc, id desc'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    ouvrier_id = fields.Many2one('res.users', 'Ouvrier', required=True, default=lambda self: self.env.user)
    date = fields.Date('Date', required=True, default=fields.Date.today)
    nb_heures = fields.Float('Nombre d\'heures', required=True)
    taux_horaire = fields.Monetary('Taux horaire (€/h)', currency_field='currency_id', default=15.0)
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    montant = fields.Monetary('Montant', compute='_compute_montant', store=True, currency_field='currency_id')
    description = fields.Char('Description du travail')
    state = fields.Selection([
        ('brouillon', 'Brouillon'),
        ('soumis', 'Soumis'),
        ('valide', 'Validé'),
        ('refuse', 'Refusé'),
    ], default='brouillon', string='État')
    validateur_id = fields.Many2one('res.users', 'Validé par', readonly=True)
    note_refus = fields.Text('Motif du refus')

    @api.depends('nb_heures', 'taux_horaire')
    def _compute_montant(self):
        for rec in self:
            rec.montant = rec.nb_heures * rec.taux_horaire

    def action_soumettre(self):
        self.write({'state': 'soumis'})

    def action_valider(self):
        self.write({'state': 'valide', 'validateur_id': self.env.user.id})

    def action_refuser(self):
        self.write({'state': 'refuse'})

    def action_reset(self):
        self.write({'state': 'brouillon', 'validateur_id': False, 'note_refus': False})
