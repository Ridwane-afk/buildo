from odoo import models, fields, api, _


class ChantierPhoto(models.Model):
    _name = 'chantier.photo'
    _description = 'Photo de chantier'
    _order = 'date desc, id desc'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    tache_id = fields.Many2one('chantier.tache', 'Tâche liée', ondelete='set null')
    name = fields.Char('Titre', required=True)
    date = fields.Date('Date', default=fields.Date.today)
    image = fields.Image('Photo', max_width=1920, max_height=1920)
    auteur_id = fields.Many2one('res.users', 'Pris par', default=lambda self: self.env.user)
    description = fields.Text('Description')

    @api.onchange('tache_id')
    def _onchange_tache_id(self):
        if self.tache_id:
            self.chantier_id = self.tache_id.chantier_id

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('tache_id') and not vals.get('chantier_id'):
                vals['chantier_id'] = self.env['chantier.tache'].browse(vals['tache_id']).chantier_id.id
        photos = super().create(vals_list)
        self.env['chantier.journal']._enregistrer(
            'photo_ajoutee', photos, ouvrier=lambda p: p.auteur_id,
            description=lambda p: _("Tâche : %s", p.tache_id.name) if p.tache_id else p.name)
        return photos
