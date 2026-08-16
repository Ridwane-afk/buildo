from odoo import models, fields, api

MODELES_AUDITES = {
    'chantier.chantier': 'Chantier',
    'chantier.tache': 'Tâche',
    'chantier.demande.materiel': 'Demande de matériel',
    'chantier.heure.prestee': 'Heure prestée',
    'chantier.avenant': 'Avenant',
    'chantier.paiement.fss': 'Paiement FSS',
}


class MailMessageAudit(models.Model):
    _inherit = 'mail.message'

    model_label = fields.Char('Type d\'enregistrement', compute='_compute_model_label')

    def _compute_model_label(self):
        for rec in self:
            rec.model_label = MODELES_AUDITES.get(rec.model, rec.model)


class MailTrackingValueAudit(models.Model):
    _inherit = 'mail.tracking.value'

    message_date = fields.Datetime(related='mail_message_id.date', store=True, string='Date')
    message_author_id = fields.Many2one(related='mail_message_id.author_id', store=True, string='Modifié par')
    res_model = fields.Char(related='mail_message_id.model', store=True, string='Modèle')
    record_name = fields.Char(related='mail_message_id.record_name', string='Enregistrement')
    model_label = fields.Char('Type d\'enregistrement', compute='_compute_model_label', store=True)
    old_value_display = fields.Char('Ancienne valeur', compute='_compute_value_display')
    new_value_display = fields.Char('Nouvelle valeur', compute='_compute_value_display')

    @api.depends('res_model')
    def _compute_model_label(self):
        for rec in self:
            rec.model_label = MODELES_AUDITES.get(rec.res_model, rec.res_model)

    @api.depends('old_value_char', 'old_value_text', 'old_value_integer', 'old_value_float', 'old_value_datetime',
                 'new_value_char', 'new_value_text', 'new_value_integer', 'new_value_float', 'new_value_datetime')
    def _compute_value_display(self):
        for rec in self:
            rec.old_value_display = rec._get_first_value('old')
            rec.new_value_display = rec._get_first_value('new')

    def _get_first_value(self, prefix):
        self.ensure_one()
        for suffix in ('char', 'text', 'datetime', 'float', 'integer'):
            value = getattr(self, f'{prefix}_value_{suffix}')
            if value:
                return str(value)
        return ''
