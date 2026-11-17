import base64
import io
import secrets

import qrcode

from odoo import models, fields, api, _
from odoo.exceptions import UserError


class ChantierOutil(models.Model):
    _name = 'chantier.outil'
    _description = 'Catalogue des outils'
    _order = 'name'

    name = fields.Char('Nom de l\'outil', required=True)
    ref_interne = fields.Char('Référence interne')
    categorie = fields.Selection([
        ('outillage_main', 'Outillage à main'),
        ('outillage_electrique', 'Outillage électrique'),
        ('levage', 'Levage / Manutention'),
        ('mesure', 'Mesure'),
        ('securite', 'Sécurité'),
        ('autre', 'Autre'),
    ], string='Catégorie', default='autre')
    etat = fields.Selection([
        ('disponible', 'Disponible'),
        ('attribue', 'Attribué'),
        ('maintenance', 'En maintenance'),
        ('hors_service', 'Hors service'),
    ], default='disponible', string='État')
    valeur_achat = fields.Monetary('Valeur d\'achat (€)', currency_field='currency_id')
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    date_achat = fields.Date('Date d\'achat')
    description = fields.Text('Description')
    actif = fields.Boolean('Actif', default=True)
    attribution_ids = fields.One2many('chantier.attribution.outil', 'outil_id', string='Attributions')
    attribue_a_id = fields.Many2one(
        'res.users',
        string='Attribué à',
        compute='_compute_attribution_en_cours',
        store=True,
    )
    date_retour_prevue = fields.Date(
        string='Date de retour prévue',
        compute='_compute_attribution_en_cours',
        store=True,
    )
    qr_token = fields.Char('Jeton QR', copy=False, readonly=True, index=True,
                           help="Identifiant secret encodé dans le QR code collé sur l'outil.")
    qr_url = fields.Char('Lien du QR code', compute='_compute_qr')
    qr_code = fields.Binary('QR code', compute='_compute_qr')

    _qr_token_uniq = models.Constraint('UNIQUE(qr_token)', "Chaque outil doit avoir son propre QR code.")

    def init(self):
        # Outils créés avant l'ajout du QR code : un jeton différent pour chacun.
        self.env.cr.execute("""
            UPDATE chantier_outil
               SET qr_token = md5(random()::text || clock_timestamp()::text || id::text)
             WHERE qr_token IS NULL
        """)

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            vals.setdefault('qr_token', secrets.token_hex(16))
        return super().create(vals_list)

    @api.depends('qr_token')
    def _compute_qr(self):
        base_url = self.get_base_url()
        for outil in self:
            if not outil.qr_token:
                outil.qr_url = outil.qr_code = False
                continue
            outil.qr_url = '%s/buildo/outil/%s' % (base_url, outil.qr_token)
            image = qrcode.make(outil.qr_url, box_size=8, border=2)
            buffer = io.BytesIO()
            image.save(buffer, format='PNG')
            outil.qr_code = base64.b64encode(buffer.getvalue())

    def action_regenerer_qr(self):
        """Invalide l'ancienne étiquette (perdue ou volée) : il faudra en imprimer une nouvelle."""
        for outil in self:
            outil.qr_token = secrets.token_hex(16)

    # --- Scan du QR code sur le chantier -------------------------------------------------

    def _est_chef(self):
        return self.env.user.has_group('buildo_gestion_chantier.group_chef_chantier')

    def action_scan_prendre(self, chantier_id=False, ouvrier_id=False):
        """Sortie de l'outil en un scan : l'ouvrier le prend pour lui sur son chantier du jour."""
        self.ensure_one()
        if self.etat != 'disponible':
            raise UserError(_("%(outil)s n'est pas disponible (%(etat)s).", outil=self.name,
                              etat=dict(self._fields['etat'].selection)[self.etat]))
        Heure = self.env['chantier.heure.prestee']
        chantier = self.env['chantier.chantier'].browse(chantier_id) if chantier_id else (
            Heure._pointage_ouvert().chantier_id or Heure._chantiers_du_jour())
        if len(chantier) != 1 or (self._est_chef() and not ouvrier_id):
            # Chantier à choisir, ou chef qui peut confier l'outil à un ouvrier.
            return {
                'type': 'ir.actions.act_window',
                'name': _("Sortir %s", self.name),
                'res_model': 'chantier.wizard.scan.outil',
                'view_mode': 'form',
                'target': 'new',
                'context': {'default_outil_id': self.id, 'default_chantier_id': chantier[:1].id},
            }
        ouvrier = self.env['res.users'].browse(ouvrier_id) if ouvrier_id and self._est_chef() else self.env.user
        # L'ouvrier n'a que la lecture sur les attributions : la sortie passe en sudo après les contrôles.
        self.env['chantier.attribution.outil'].sudo().create({
            'chantier_id': chantier.id,
            'outil_id': self.id,
            'ouvrier_id': ouvrier.id,
        })
        return Heure._notifier(_("%(outil)s sorti pour %(ouvrier)s sur %(chantier)s.",
                                 outil=self.name, ouvrier=ouvrier.name, chantier=chantier.name))

    def action_scan_rendre(self):
        """Retour de l'outil en un scan, par l'ouvrier qui l'a ou par un chef."""
        self.ensure_one()
        attribution = self.sudo().attribution_ids.filtered(lambda a: a.state == 'attribue')[:1]
        if not attribution:
            raise UserError(_("%s n'est attribué à personne.", self.name))
        if attribution.ouvrier_id != self.env.user and not self._est_chef():
            raise UserError(_("%(outil)s est attribué à %(ouvrier)s : lui seul ou un chef peut le rendre.",
                              outil=self.name, ouvrier=attribution.ouvrier_id.name))
        attribution.action_retour()
        return self.env['chantier.heure.prestee']._notifier(_("%s rendu, merci !", self.name))

    @api.depends('attribution_ids.state', 'attribution_ids.ouvrier_id', 'attribution_ids.date_retour_prevue')
    def _compute_attribution_en_cours(self):
        for outil in self:
            attribution_en_cours = outil.attribution_ids.filtered(lambda a: a.state == 'attribue')[:1]
            outil.attribue_a_id = attribution_en_cours.ouvrier_id
            outil.date_retour_prevue = attribution_en_cours.date_retour_prevue
