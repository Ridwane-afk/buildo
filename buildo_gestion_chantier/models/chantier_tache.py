from odoo import models, fields, api
from odoo.exceptions import UserError, ValidationError


class ChantierTache(models.Model):
    _name = 'chantier.tache'
    _description = 'Tâche planifiée du chantier'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _order = 'sequence, id'

    name = fields.Char('Nom de la tâche', required=True, tracking=True)
    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade')
    sequence = fields.Integer('Séquence', default=10)
    date_debut = fields.Date('Date de début', tracking=True)
    date_fin = fields.Date('Date de fin prévue', tracking=True)
    date_fin_reelle = fields.Date('Date de fin réelle', tracking=True, readonly=True)
    responsable_id = fields.Many2one('res.users', 'Responsable', tracking=True)
    description = fields.Text('Description')
    state = fields.Selection([
        ('a_faire', 'À faire'),
        ('en_cours', 'En cours'),
        ('fait', 'Fait'),
        ('bloque', 'Bloqué'),
    ], default='a_faire', string='État', tracking=True)
    note = fields.Text('Notes')
    photo_ids = fields.One2many('chantier.photo', 'tache_id', string='Photos de preuve')
    checklist_ids = fields.One2many('chantier.tache.checklist', 'tache_id', string='Sous-tâches')
    document_ids = fields.One2many('chantier.tache.document', 'tache_id', string='Documents')
    estimation_materiau_ids = fields.One2many('chantier.estimation.materiau', 'tache_id', string='Matériaux nécessaires')
    estimation_outil_ids = fields.One2many('chantier.estimation.outil', 'tache_id', string='Outils nécessaires')
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    montant_facturable = fields.Monetary('Montant facturable', currency_field='currency_id', tracking=True)
    facture_id = fields.Many2one('account.move', 'Facture', readonly=True, copy=False, tracking=True)
    facture_state = fields.Selection(related='facture_id.state', string='État de la facture', tracking=False)
    avancement = fields.Integer('Avancement (%)', default=0, tracking=True)

    @api.constrains('avancement')
    def _check_avancement(self):
        for rec in self:
            if not 0 <= rec.avancement <= 100:
                raise ValidationError("L'avancement doit être compris entre 0 et 100.")

    def _sync_avancement_from_checklist(self):
        """Recalcule l'avancement à partir des sous-tâches cochées, si la tâche en a."""
        for rec in self:
            if rec.checklist_ids:
                items = rec.checklist_ids
                rec.avancement = round(100 * len(items.filtered('fait')) / len(items))

    @api.model_create_multi
    def create(self, vals_list):
        taches = super().create(vals_list)
        direction_partners = self.env.ref('buildo_gestion_chantier.group_direction').all_user_ids.mapped('partner_id')
        if direction_partners:
            taches.message_subscribe(partner_ids=direction_partners.ids)
        return taches

    def action_demarrer(self):
        self.write({'state': 'en_cours', 'date_fin_reelle': False})

    def action_valider(self):
        self.ensure_one()
        self.write({'state': 'fait', 'date_fin_reelle': fields.Date.today(), 'avancement': 100})
        return {
            'type': 'ir.actions.act_window',
            'name': 'Photo de preuve',
            'res_model': 'chantier.photo',
            'view_mode': 'form',
            'target': 'new',
            'context': {
                'default_chantier_id': self.chantier_id.id,
                'default_tache_id': self.id,
                'default_name': "Preuve - %s" % self.name,
            },
        }

    def action_bloquer(self):
        self.ensure_one()
        self.write({'state': 'bloque'})
        return {
            'type': 'ir.actions.act_window',
            'name': 'Photo de preuve du blocage',
            'res_model': 'chantier.photo',
            'view_mode': 'form',
            'target': 'new',
            'context': {
                'default_chantier_id': self.chantier_id.id,
                'default_tache_id': self.id,
                'default_name': "Blocage - %s" % self.name,
            },
        }

    def action_remettre_a_faire(self):
        self.write({'state': 'a_faire', 'date_fin_reelle': False, 'avancement': 0})

    def action_facturer(self):
        self.ensure_one()
        if self.facture_id and self.facture_id.state != 'cancel':
            raise UserError("Cette tâche a déjà été facturée.")
        if self.state != 'fait':
            raise UserError("Seule une tâche terminée peut être facturée.")
        if not self.montant_facturable:
            raise UserError("Indiquez un montant facturable avant de facturer cette tâche.")
        facture = self.env['account.move'].create({
            'move_type': 'out_invoice',
            'partner_id': self.chantier_id.client_id.id,
            'chantier_id': self.chantier_id.id,
            'invoice_line_ids': [(0, 0, {
                'name': self.name,
                'quantity': 1,
                'price_unit': self.montant_facturable,
            })],
        })
        self.facture_id = facture.id
        return {
            'type': 'ir.actions.act_window',
            'res_model': 'account.move',
            'res_id': facture.id,
            'view_mode': 'form',
        }

    def action_view_facture(self):
        self.ensure_one()
        return {
            'type': 'ir.actions.act_window',
            'res_model': 'account.move',
            'res_id': self.facture_id.id,
            'view_mode': 'form',
        }

    def action_open_form(self):
        self.ensure_one()
        return {
            'type': 'ir.actions.act_window',
            'name': self.name,
            'res_model': 'chantier.tache',
            'res_id': self.id,
            'view_mode': 'form',
        }
