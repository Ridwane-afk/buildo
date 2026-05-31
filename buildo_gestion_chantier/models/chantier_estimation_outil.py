from odoo import models, fields


class ChantierEstimationOutil(models.Model):
    _name = 'chantier.estimation.outil'
    _description = 'Estimation d\'outils pour un chantier'
    _order = 'chantier_id, outil_id'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    outil_id = fields.Many2one('chantier.outil', 'Outil', required=True)
    date_debut_prevue = fields.Date('Début d\'utilisation prévue')
    date_fin_prevue = fields.Date('Fin d\'utilisation prévue')
    etat_outil = fields.Selection(related='outil_id.etat', readonly=True)
    note = fields.Text('Note')
