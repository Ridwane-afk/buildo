from odoo import models, fields, api


class ChantierEstimationOutil(models.Model):
    _name = 'chantier.estimation.outil'
    _description = 'Estimation d\'outils pour un chantier'
    _order = 'chantier_id, outil_id'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    tache_id = fields.Many2one('chantier.tache', 'Tâche liée', ondelete='set null')
    outil_id = fields.Many2one('chantier.outil', 'Outil', required=True)
    date_debut_prevue = fields.Date('Début d\'utilisation prévue')
    date_fin_prevue = fields.Date('Fin d\'utilisation prévue')
    etat_outil = fields.Selection(related='outil_id.etat', readonly=True)
    note = fields.Text('Note')

    @api.onchange('tache_id')
    def _onchange_tache_id(self):
        if self.tache_id and not self.chantier_id:
            self.chantier_id = self.tache_id.chantier_id

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if not vals.get('chantier_id') and vals.get('tache_id'):
                vals['chantier_id'] = self.env['chantier.tache'].browse(vals['tache_id']).chantier_id.id
        return super().create(vals_list)
