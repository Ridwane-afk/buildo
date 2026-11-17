from odoo import models, fields


class ChantierWizardScanOutil(models.TransientModel):
    _name = 'chantier.wizard.scan.outil'
    _description = "Sortie d'un outil après scan du QR code"

    outil_id = fields.Many2one('chantier.outil', 'Outil', required=True, readonly=True)
    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True,
                                  domain=[('state', '=', 'en_cours')])
    ouvrier_id = fields.Many2one('res.users', 'Pour', required=True, default=lambda self: self.env.user,
                                 domain=lambda self: [('group_ids', 'in', self.env.ref('buildo_gestion_chantier.group_ouvrier').id)])

    def action_confirmer(self):
        return self.outil_id.action_scan_prendre(self.chantier_id.id, self.ouvrier_id.id)
