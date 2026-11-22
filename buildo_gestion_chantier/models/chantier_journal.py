from odoo import models, fields, api, _
from odoo.exceptions import UserError
from odoo.http import request

ACTIONS = [
    ('connexion', 'Connexion'),
    ('pointage_arrivee', 'Pointage d\'arrivée'),
    ('pointage_depart', 'Pointage de départ'),
    ('heures_encodees', 'Heures encodées'),
    ('heures_modifiees', 'Heures modifiées'),
    ('heures_soumises', 'Heures soumises'),
    ('heures_supprimees', 'Heures supprimées'),
    ('demande_creee', 'Demande créée'),
    ('demande_envoyee', 'Demande envoyée au chef'),
    ('outil_pris', 'Outil sorti'),
    ('outil_rendu', 'Outil rendu'),
    ('photo_ajoutee', 'Photo ajoutée'),
    ('tache_etat', 'Changement d\'état d\'une tâche'),
    ('point_controle', 'Point de contrôle'),
]


class ChantierJournal(models.Model):
    """Journal d'audit des actions terrain : qui a fait quoi, quand et sur quel chantier.

    Le suivi des champs (mail.tracking.value) ne voit que les modifications : une heure encodée,
    une photo ajoutée ou une connexion n'y laissent aucune trace. Chaque action est donc écrite
    ici au moment où elle a lieu. Les lignes ne peuvent être ni modifiées ni supprimées.
    """
    _name = 'chantier.journal'
    _description = "Journal d'audit des actions terrain"
    _order = 'date desc, id desc'

    date = fields.Datetime('Date', required=True, readonly=True, index=True, default=fields.Datetime.now)
    user_id = fields.Many2one('res.users', 'Fait par', readonly=True, index=True, ondelete='set null')
    ouvrier_id = fields.Many2one('res.users', 'Ouvrier concerné', readonly=True, index=True, ondelete='set null')
    action = fields.Selection(ACTIONS, 'Action', required=True, readonly=True, index=True)
    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', readonly=True, index=True, ondelete='set null')
    res_model = fields.Char('Modèle', readonly=True)
    res_id = fields.Integer('ID de l\'enregistrement', readonly=True)
    record_name = fields.Char('Enregistrement', readonly=True)
    description = fields.Char('Détail', readonly=True)
    adresse_ip = fields.Char('Adresse IP', readonly=True)

    @api.model
    def _enregistrer(self, action, records=None, description=None, ouvrier=None, chantier=None):
        """Écrit une ligne par enregistrement (ou une seule sans enregistrement).

        `description`, `ouvrier` et `chantier` acceptent une valeur fixe ou une fonction
        appelée pour chaque enregistrement.
        """
        def valeur(param, rec):
            return param(rec) if callable(param) else param

        ip = request.httprequest.remote_addr if request else False
        lignes = []
        for rec in (records if records is not None else [None]):
            chantier_rec = valeur(chantier, rec)
            if chantier_rec is None and rec is not None and 'chantier_id' in rec._fields:
                chantier_rec = rec.chantier_id
            ouvrier_rec = valeur(ouvrier, rec)
            if ouvrier_rec is None and rec is not None and 'ouvrier_id' in rec._fields:
                ouvrier_rec = rec.ouvrier_id
            lignes.append({
                'user_id': self.env.uid,
                'ouvrier_id': ouvrier_rec.id if ouvrier_rec else self.env.uid,
                'action': action,
                'chantier_id': chantier_rec.id if chantier_rec else False,
                'res_model': rec._name if rec is not None else False,
                'res_id': rec.id if rec is not None else False,
                'record_name': rec.sudo().display_name if rec is not None else False,
                'description': valeur(description, rec),
                'adresse_ip': ip,
            })
        return self.sudo().create(lignes)

    def write(self, vals):
        raise UserError(_("Le journal d'audit ne peut pas être modifié."))

    def unlink(self):
        if not self.env.su:
            raise UserError(_("Le journal d'audit ne peut pas être effacé."))
        return super().unlink()

    def action_ouvrir(self):
        self.ensure_one()
        if not self.res_model or not self.env[self.res_model].browse(self.res_id).exists():
            raise UserError(_("Cet enregistrement n'existe plus."))
        return {
            'type': 'ir.actions.act_window',
            'res_model': self.res_model,
            'res_id': self.res_id,
            'view_mode': 'form',
            'target': 'current',
        }


class ResUsersJournal(models.Model):
    _inherit = 'res.users'

    @api.model
    def _update_last_login(self):
        super()._update_last_login()
        if self.env.user.has_group('buildo_gestion_chantier.group_ouvrier'):
            self.env['chantier.journal']._enregistrer('connexion')
