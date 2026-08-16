from odoo import models, fields


class ChantierTacheChecklist(models.Model):
    _name = 'chantier.tache.checklist'
    _description = 'Sous-tâche / point de contrôle'
    _order = 'sequence, id'

    tache_id = fields.Many2one('chantier.tache', 'Tâche', required=True, ondelete='cascade')
    sequence = fields.Integer('Séquence', default=10)
    name = fields.Char('Intitulé', required=True)
    fait = fields.Boolean('Fait')
