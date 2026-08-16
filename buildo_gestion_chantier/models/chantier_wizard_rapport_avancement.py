from odoo import models, fields, api
from odoo.exceptions import UserError


class ChantierWizardRapportAvancement(models.TransientModel):
    _name = 'chantier.wizard.rapport.avancement'
    _description = "Génération du rapport d'avancement chantier à envoyer au client"

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True)
    titre = fields.Char('Titre du rapport', required=True)
    message_client = fields.Text('Message au client')
    tache_ids = fields.Many2many(
        'chantier.tache',
        relation='chantier_wizard_rapport_tache_rel',
        string='Tâches à inclure',
    )
    photo_ids = fields.Many2many(
        'chantier.photo',
        relation='chantier_wizard_rapport_photo_rel',
        string='Photos à inclure',
    )
    rapport_journalier_ids = fields.Many2many(
        'chantier.rapport.journalier',
        relation='chantier_wizard_rapport_journalier_rel',
        string='Rapports journaliers à inclure',
    )
    plan_ids = fields.Many2many(
        'chantier.plan',
        relation='chantier_wizard_rapport_plan_rel',
        string='Plans à inclure',
    )

    @api.model
    def default_get(self, fields_list):
        vals = super().default_get(fields_list)
        chantier = self.env['chantier.chantier'].browse(self.env.context.get('active_id'))
        if chantier:
            vals['chantier_id'] = chantier.id
            vals['titre'] = "Rapport d'avancement - %s" % chantier.name
            vals['tache_ids'] = [(6, 0, chantier.tache_ids.ids)]
            vals['photo_ids'] = [(6, 0, chantier.photo_ids.ids)]
            vals['rapport_journalier_ids'] = [(6, 0, chantier.rapport_journalier_ids.ids)]
            vals['plan_ids'] = [(6, 0, chantier.plan_ids.ids)]
        return vals

    @api.onchange('tache_ids')
    def _onchange_tache_ids(self):
        self.photo_ids = self.chantier_id.photo_ids.filtered(
            lambda p: not p.tache_id or p.tache_id in self.tache_ids
        )

    def action_generate_pdf(self):
        self.ensure_one()
        if not self.tache_ids and not self.photo_ids and not self.rapport_journalier_ids and not self.plan_ids:
            raise UserError("Sélectionnez au moins un élément (tâche, photo, rapport ou plan) à inclure dans le rapport.")
        return self.env.ref('buildo_gestion_chantier.action_report_rapport_avancement').report_action(self)
