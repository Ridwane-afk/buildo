from odoo import models, fields


class ChantierTacheDocument(models.Model):
    _name = 'chantier.tache.document'
    _description = 'Document lié à une tâche de chantier'
    _order = 'date desc, id desc'

    tache_id = fields.Many2one('chantier.tache', 'Tâche', required=True, ondelete='cascade')
    name = fields.Char('Intitulé', required=True)
    date = fields.Date('Date', default=fields.Date.today)
    fichier = fields.Binary('Fichier', attachment=True, required=True)
    fichier_name = fields.Char('Nom du fichier')
    auteur_id = fields.Many2one('res.users', 'Ajouté par', default=lambda self: self.env.user)
