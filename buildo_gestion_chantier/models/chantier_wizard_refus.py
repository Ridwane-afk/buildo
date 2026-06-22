from odoo import models, fields, api
from odoo.exceptions import ValidationError


class ChantierWizardRefus(models.TransientModel):
    _name = 'chantier.wizard.refus'
    _description = 'Motif de refus'

    motif = fields.Text('Motif du refus', required=True)

    @api.constrains('motif')
    def _check_motif(self):
        for rec in self:
            if not rec.motif or len(rec.motif.strip()) < 10:
                raise ValidationError("Le motif doit contenir au moins 10 caractères.")

    def action_confirmer(self):
        ctx = self.env.context
        model = ctx.get('active_model')
        ids = ctx.get('active_ids', [])
        records = self.env[model].browse(ids)
        if model == 'chantier.heure.prestee':
            records.write({'state': 'refuse', 'note_refus': self.motif})
        elif model == 'chantier.demande.materiel':
            records.write({'state': 'refuse', 'note': self.motif})
        return {'type': 'ir.actions.act_window_close'}
