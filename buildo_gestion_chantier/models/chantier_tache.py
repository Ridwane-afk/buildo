from odoo import models, fields


class ChantierTache(models.Model):
    _name = 'chantier.tache'
    _description = 'Tâche planifiée du chantier'
    _order = 'sequence, id'

    name = fields.Char('Nom de la tâche', required=True)
    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    sequence = fields.Integer('Séquence', default=10)
    date_debut = fields.Date('Date de début')
    date_fin = fields.Date('Date de fin prévue')
    responsable_id = fields.Many2one('res.users', 'Responsable')
    description = fields.Text('Description')
    state = fields.Selection([
        ('a_faire', 'À faire'),
        ('en_cours', 'En cours'),
        ('fait', 'Fait'),
        ('bloque', 'Bloqué'),
    ], default='a_faire', string='État')
    note = fields.Text('Notes')
