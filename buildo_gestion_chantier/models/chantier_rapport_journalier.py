from odoo import models, fields


class ChantierRapportJournalier(models.Model):
    _name = 'chantier.rapport.journalier'
    _description = 'Rapport journalier de chantier'
    _order = 'date desc, id desc'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    auteur_id = fields.Many2one('res.users', 'Auteur', required=True, default=lambda self: self.env.user)
    date = fields.Date('Date', required=True, default=fields.Date.today)
    meteo = fields.Selection([
        ('soleil', 'Ensoleillé'),
        ('nuageux', 'Nuageux'),
        ('pluie', 'Pluie'),
        ('vent', 'Venteux'),
        ('neige', 'Neige'),
    ], string='Météo')
    nb_ouvriers = fields.Integer('Nombre d\'ouvriers présents')
    travaux_realises = fields.Text('Travaux réalisés', required=True)
    incidents = fields.Text('Incidents / Remarques')
    note = fields.Text('Notes complémentaires')
