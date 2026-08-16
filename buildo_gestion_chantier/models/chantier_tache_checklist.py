from odoo import models, fields, api


class ChantierTacheChecklist(models.Model):
    _name = 'chantier.tache.checklist'
    _description = 'Sous-tâche / point de contrôle'
    _order = 'sequence, id'

    tache_id = fields.Many2one('chantier.tache', 'Tâche', required=True, ondelete='cascade')
    sequence = fields.Integer('Séquence', default=10)
    name = fields.Char('Intitulé', required=True)
    fait = fields.Boolean('Fait')
    fait_par_id = fields.Many2one('res.users', 'Validé par', readonly=True, copy=False)
    fait_le = fields.Datetime('Validé le', readonly=True, copy=False)
    note = fields.Text('Note')

    def write(self, vals):
        if vals.get('fait'):
            vals.setdefault('fait_par_id', self.env.user.id)
            vals.setdefault('fait_le', fields.Datetime.now())
        elif 'fait' in vals and not vals['fait']:
            vals['fait_par_id'] = False
            vals['fait_le'] = False
        result = super().write(vals)
        if 'fait' in vals:
            self.tache_id._sync_avancement_from_checklist()
        return result

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('fait'):
                vals.setdefault('fait_par_id', self.env.user.id)
                vals.setdefault('fait_le', fields.Datetime.now())
        records = super().create(vals_list)
        records.tache_id._sync_avancement_from_checklist()
        return records

    def unlink(self):
        taches = self.tache_id
        result = super().unlink()
        taches._sync_avancement_from_checklist()
        return result
