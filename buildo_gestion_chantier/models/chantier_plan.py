from odoo import models, fields


class ChantierPlan(models.Model):
    _name = 'chantier.plan'
    _description = 'Plan de chantier (PDF ou image)'
    _order = 'date desc, id desc'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    name = fields.Char('Intitulé du plan', required=True)
    date = fields.Date('Date', default=fields.Date.today)
    version = fields.Char('Version', default='v1')
    fichier = fields.Binary('Fichier (PDF/image)', attachment=True)
    fichier_name = fields.Char('Nom du fichier')
    auteur_id = fields.Many2one('res.users', 'Ajouté par', default=lambda self: self.env.user)
    annotation = fields.Text('Annotations')
