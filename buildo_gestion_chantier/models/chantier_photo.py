from odoo import models, fields


class ChantierPhoto(models.Model):
    _name = 'chantier.photo'
    _description = 'Photo de chantier'
    _order = 'date desc, id desc'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    name = fields.Char('Titre', required=True)
    date = fields.Date('Date', default=fields.Date.today)
    image = fields.Image('Photo', max_width=1920, max_height=1920)
    auteur_id = fields.Many2one('res.users', 'Pris par', default=lambda self: self.env.user)
    description = fields.Text('Description')
