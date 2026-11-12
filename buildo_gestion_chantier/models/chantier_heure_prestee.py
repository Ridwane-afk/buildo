from odoo import models, fields, api, _
from odoo.exceptions import UserError, ValidationError


class ChantierHeurePrestee(models.Model):
    _name = 'chantier.heure.prestee'
    _description = "Heures prestées par un ouvrier sur un chantier"
    _inherit = ['mail.thread', 'mail.activity.mixin', 'chantier.validation.mixin']
    _order = 'date desc, id desc'

    # RESTRICT : les heures prestées alimentent le suivi social (salaires, ONSS) et doivent être
    # conservées 5 ans ; supprimer le chantier ne doit jamais les effacer. On archive le chantier.
    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='restrict')
    ouvrier_id = fields.Many2one('res.users', 'Ouvrier', required=True, default=lambda self: self.env.user)
    date = fields.Date('Date', required=True, default=fields.Date.today)
    nb_heures = fields.Float('Nombre d\'heures', required=True)
    # Pointage : l'ouvrier pointe son arrivée puis son départ, la durée est calculée.
    # Tant que le départ n'est pas pointé, nb_heures vaut 0 et la ligne ne peut pas être soumise.
    heure_arrivee = fields.Datetime('Arrivée', readonly=True, copy=False)
    heure_depart = fields.Datetime('Départ', readonly=True, copy=False)
    pointage_en_cours = fields.Boolean('Pointage en cours', compute='_compute_pointage_en_cours', store=True)
    taux_horaire = fields.Monetary('Taux horaire (€/h)', currency_field='currency_id', default=15.0,
                                   groups='buildo_gestion_chantier.group_chef_chantier')
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    montant = fields.Monetary('Montant', compute='_compute_montant', store=True, currency_field='currency_id',
                              groups='buildo_gestion_chantier.group_chef_chantier')
    description = fields.Char('Description du travail')
    state = fields.Selection([
        ('brouillon', 'Brouillon'),
        ('soumis', 'Soumis'),
        ('valide', 'Validé'),
        ('refuse', 'Refusé'),
    ], default='brouillon', string='État', tracking=True)
    validateur_id = fields.Many2one('res.users', 'Validé par', readonly=True)
    note_refus = fields.Text('Motif du refus')

    @api.constrains('nb_heures', 'taux_horaire')
    def _check_heures(self):
        for rec in self:
            if rec.nb_heures <= 0 and not rec.pointage_en_cours:
                raise ValidationError(_("Le nombre d'heures doit être supérieur à 0."))
            if rec.taux_horaire <= 0:
                raise ValidationError(_("Le taux horaire doit être supérieur à 0."))

    @api.depends('ouvrier_id', 'date', 'nb_heures')
    def _compute_display_name(self):
        for rec in self:
            minutes = round(rec.nb_heures * 60)
            rec.display_name = _("%(ouvrier)s — %(date)s (%(heures)s)", ouvrier=rec.ouvrier_id.name or '',
                                 date=rec.date or '', heures='%d:%02d' % divmod(minutes, 60))

    @api.depends('heure_arrivee', 'heure_depart')
    def _compute_pointage_en_cours(self):
        for rec in self:
            rec.pointage_en_cours = bool(rec.heure_arrivee and not rec.heure_depart)

    @api.depends('nb_heures', 'taux_horaire')
    def _compute_montant(self):
        for rec in self:
            rec.montant = rec.nb_heures * rec.taux_horaire

    def action_soumettre(self):
        if any(rec.pointage_en_cours for rec in self):
            raise UserError(_("Pointez d'abord votre départ avant de soumettre ces heures."))
        self.write({'state': 'soumis'})

    # ------------------------------------------------------------------
    # Saisie en un geste (boutons de la liste « Mes heures »)
    # Méthodes de recordset et pas @api.model : un bouton d'en-tête de liste
    # transmet les lignes cochées (souvent aucune), ignorées ici.
    # ------------------------------------------------------------------

    def _pointage_ouvert(self):
        return self.search([('ouvrier_id', '=', self.env.uid), ('pointage_en_cours', '=', True)], limit=1)

    @api.model
    def _chantiers_du_jour(self):
        """Chantiers en cours où l'utilisateur a une tâche pas encore terminée."""
        taches = self.env['chantier.tache'].search([
            ('ouvrier_ids', 'in', self.env.uid),
            ('state', '!=', 'fait'),
            ('chantier_id.state', '=', 'en_cours'),
        ])
        return taches.chantier_id

    @api.model
    def _notifier(self, message):
        return {
            'type': 'ir.actions.client',
            'tag': 'display_notification',
            'params': {'message': message, 'type': 'success', 'next': {'type': 'ir.actions.client', 'tag': 'soft_reload'}},
        }

    def action_pointer_arrivee(self, chantier_id=False):
        ouvert = self._pointage_ouvert()
        if ouvert:
            raise UserError(_("Vous êtes déjà pointé sur %(chantier)s. Pointez d'abord votre départ.",
                              chantier=ouvert.chantier_id.name))
        chantier = self.env['chantier.chantier'].browse(chantier_id) if chantier_id else self._chantiers_du_jour()
        if len(chantier) != 1:
            # Aucun ou plusieurs chantiers possibles : l'ouvrier choisit.
            return {
                'type': 'ir.actions.act_window',
                'name': _("Sur quel chantier arrivez-vous ?"),
                'res_model': 'chantier.wizard.pointage',
                'view_mode': 'form',
                'target': 'new',
                'context': {'default_chantier_id': chantier[:1].id},
            }
        self.create({'chantier_id': chantier.id, 'heure_arrivee': fields.Datetime.now(), 'nb_heures': 0})
        return self._notifier(_("Arrivée pointée sur %(chantier)s. Bonne journée !", chantier=chantier.name))

    def action_pointer_depart(self):
        rec = self._pointage_ouvert()
        if not rec:
            raise UserError(_("Aucune arrivée pointée : pointez d'abord votre arrivée."))
        maintenant = fields.Datetime.now()
        duree = (maintenant - rec.heure_arrivee).total_seconds() / 3600
        # Arrondi au quart d'heure, au minimum un quart d'heure.
        rec.write({'heure_depart': maintenant, 'nb_heures': max(round(duree * 4) / 4, 0.25)})
        # Ouvre la ligne pour ajouter une description, corriger (pause) puis soumettre.
        return {
            'type': 'ir.actions.act_window',
            'res_model': self._name,
            'res_id': rec.id,
            'view_mode': 'form',
            'target': 'current',
        }

    def action_copier_derniere_journee(self):
        aujourdhui = fields.Date.context_today(self)
        domaine = [('ouvrier_id', '=', self.env.uid)]
        if self.search_count(domaine + [('date', '=', aujourdhui)]):
            raise UserError(_("Vous avez déjà des heures pour aujourd'hui."))
        derniere = self.search(domaine + [('date', '<', aujourdhui)], order='date desc', limit=1)
        lignes = self.search(domaine + [('date', '=', derniere.date), ('pointage_en_cours', '=', False),
                                        ('chantier_id.state', '=', 'en_cours')]) if derniere else self
        if not lignes:
            raise UserError(_("Aucune journée précédente à copier sur un chantier en cours."))
        self.create([{
            'chantier_id': ligne.chantier_id.id,
            'nb_heures': ligne.nb_heures,
            'description': ligne.description,
        } for ligne in lignes])
        return self._notifier(_("%(nb)s ligne(s) du %(date)s copiée(s) pour aujourd'hui, à vérifier puis soumettre.",
                                nb=len(lignes), date=derniere.date.strftime('%d/%m/%Y')))

    def action_valider(self):
        self.write({'state': 'valide', 'validateur_id': self.env.user.id})

    def action_refuser(self):
        return {
            'type': 'ir.actions.act_window',
            'res_model': 'chantier.wizard.refus',
            'view_mode': 'form',
            'target': 'new',
            'context': {'active_model': self._name, 'active_ids': self.ids},
        }

    def action_reset(self):
        self.write({'state': 'brouillon', 'validateur_id': False, 'note_refus': False})
