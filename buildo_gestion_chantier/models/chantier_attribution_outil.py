from datetime import timedelta

from odoo import models, fields, api, _
from odoo.exceptions import UserError


class ChantierAttributionOutil(models.Model):
    _name = 'chantier.attribution.outil'
    _description = 'Attribution d\'un outil à un ouvrier'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _order = 'date_sortie desc'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    outil_id = fields.Many2one('chantier.outil', 'Outil', required=True,
                               domain=[('etat', '=', 'disponible')])
    categorie = fields.Selection(related='outil_id.categorie', string='Catégorie')
    ouvrier_id = fields.Many2one('res.users', 'Ouvrier', required=True)
    date_sortie = fields.Date('Date de sortie', required=True, default=fields.Date.today)
    date_retour_prevue = fields.Date('Date de retour prévue',
                                     default=lambda self: fields.Date.today() + timedelta(days=7))
    date_retour_reelle = fields.Date('Date de retour réelle')
    state = fields.Selection([
        ('attribue', 'Attribué'),
        ('retourne', 'Retourné'),
    ], default='attribue', string='État')
    note = fields.Text('Note')
    en_retard = fields.Boolean('En retard', compute='_compute_en_retard', search='_search_en_retard')

    @api.depends('state', 'date_retour_prevue')
    def _compute_en_retard(self):
        today = fields.Date.context_today(self)
        for rec in self:
            rec.en_retard = rec.state == 'attribue' and bool(rec.date_retour_prevue) and rec.date_retour_prevue < today

    def _search_en_retard(self, operator, value):
        if operator not in ('=', '!=') or not isinstance(value, bool):
            return NotImplemented
        domaine = [('state', '=', 'attribue'), ('date_retour_prevue', '<', fields.Date.context_today(self))]
        return domaine if (operator == '=') == value else ['!', '&'] + domaine

    @api.model_create_multi
    def create(self, vals_list):
        records = super().create(vals_list)
        for rec in records:
            rec.outil_id.write({'etat': 'attribue'})
        self.env['chantier.journal']._enregistrer('outil_pris', records, description=lambda a: _(
            "%(outil)s, à rendre le %(date)s", outil=a.outil_id.sudo().display_name,
            date=a.date_retour_prevue.strftime('%d/%m/%Y') if a.date_retour_prevue else '-'))
        return records

    def action_rendre(self):
        """Bouton « Rendre » de Mes outils : mêmes contrôles que le scan du QR code."""
        self.ensure_one()
        return self.outil_id.action_scan_rendre()

    def action_retour(self):
        for rec in self:
            if rec.state != 'attribue':
                raise UserError(_("Cet outil a déjà été retourné."))
            rec.write({'state': 'retourne', 'date_retour_reelle': fields.Date.today()})
            rec.outil_id.write({'etat': 'disponible'})
        self.env['chantier.journal']._enregistrer('outil_rendu', self, description=lambda a: _(
            "%(outil)s, %(retard)s", outil=a.outil_id.sudo().display_name,
            retard=_("rendu en retard") if a.date_retour_prevue and a.date_retour_reelle > a.date_retour_prevue
            else _("rendu à temps")))
        # Le rappel « outil à rendre » n'a plus lieu d'être.
        self.env['chantier.chantier']._cloturer_alertes(
            self, 'buildo_gestion_chantier.activite_outil_a_rendre', feedback=_("Outil rendu"))
