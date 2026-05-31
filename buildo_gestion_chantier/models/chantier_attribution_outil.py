from odoo import models, fields, api
from odoo.exceptions import UserError


class ChantierAttributionOutil(models.Model):
    _name = 'chantier.attribution.outil'
    _description = 'Attribution d\'un outil à un ouvrier'
    _order = 'date_sortie desc'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    outil_id = fields.Many2one('chantier.outil', 'Outil', required=True,
                               domain=[('etat', '=', 'disponible')])
    ouvrier_id = fields.Many2one('res.users', 'Ouvrier', required=True)
    date_sortie = fields.Date('Date de sortie', required=True, default=fields.Date.today)
    date_retour_prevue = fields.Date('Date de retour prévue')
    date_retour_reelle = fields.Date('Date de retour réelle')
    state = fields.Selection([
        ('attribue', 'Attribué'),
        ('retourne', 'Retourné'),
    ], default='attribue', string='État')
    note = fields.Text('Note')

    @api.model_create_multi
    def create(self, vals_list):
        records = super().create(vals_list)
        for rec in records:
            rec.outil_id.write({'etat': 'attribue'})
        return records

    def action_retour(self):
        for rec in self:
            if rec.state != 'attribue':
                raise UserError("Cet outil a déjà été retourné.")
            rec.write({'state': 'retourne', 'date_retour_reelle': fields.Date.today()})
            rec.outil_id.write({'etat': 'disponible'})
