from odoo import models, fields, api, Command, _
from odoo.exceptions import UserError, ValidationError


class ChantierDemandeMateriel(models.Model):
    _name = 'chantier.demande.materiel'
    _description = 'Demande de matériel par un ouvrier'
    _rec_name = 'description'
    _inherit = ['mail.thread', 'mail.activity.mixin', 'chantier.validation.mixin']
    _order = 'date desc, id desc'

    chantier_id = fields.Many2one('chantier.chantier', 'Chantier', required=True, ondelete='cascade',
                                  default=lambda self: self._chantier_par_defaut())
    ouvrier_id = fields.Many2one('res.users', 'Ouvrier', required=True, default=lambda self: self.env.user)
    date = fields.Date('Date de demande', required=True, default=fields.Date.today)
    type_demande = fields.Selection([
        ('materiau', 'Matériau'),
        ('outil', 'Outil'),
    ], string='Je demande', required=True, default='materiau')
    materiau_id = fields.Many2one('chantier.materiau', 'Matériau (optionnel)')
    outil_id = fields.Many2one('chantier.outil', 'Outil', domain=[('actif', '=', True)])
    outil_etat = fields.Selection(related='outil_id.etat', string="Disponibilité de l'outil")
    picking_id = fields.Many2one('stock.picking', 'Sortie de stock', readonly=True, copy=False)
    attribution_id = fields.Many2one('chantier.attribution.outil', 'Sortie de l\'outil', readonly=True, copy=False)
    description = fields.Char('Description du besoin')
    quantite = fields.Float('Quantité demandée', default=1.0)
    urgence = fields.Selection([
        ('normale', 'Normale'),
        ('urgente', 'Urgente'),
    ], default='normale', string='Urgence')
    state = fields.Selection([
        ('brouillon', 'Brouillon'),
        ('soumis', 'Soumis'),
        ('valide', 'Validé'),
        ('refuse', 'Refusé'),
    ], default='brouillon', string='État', tracking=True)
    validateur_id = fields.Many2one('res.users', 'Validé par', readonly=True)
    note = fields.Text('Note')

    @api.model
    def _chantier_par_defaut(self):
        """Chantier où l'ouvrier est pointé, sinon son seul chantier en cours."""
        Heure = self.env['chantier.heure.prestee']
        chantier = Heure._pointage_ouvert().chantier_id or Heure._chantiers_du_jour()
        return chantier.id if len(chantier) == 1 else False

    @api.onchange('type_demande')
    def _onchange_type_demande(self):
        if self.type_demande == 'outil':
            self.materiau_id = False
            self.quantite = 1.0
        else:
            self.outil_id = False

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            # Pas besoin de retaper le nom de l'article choisi.
            if not vals.get('description'):
                article = (self.env['chantier.outil'].browse(vals['outil_id']) if vals.get('outil_id')
                           else self.env['chantier.materiau'].browse(vals.get('materiau_id')))
                vals['description'] = article.name
        demandes = super().create(vals_list)
        self.env['chantier.journal']._enregistrer('demande_creee', demandes, description=lambda d: d._resume_journal())
        return demandes

    def _resume_journal(self):
        if self.type_demande == 'outil':
            return _("Outil : %s", self.description)
        return _("%(quantite)s × %(article)s", quantite='%g' % self.quantite, article=self.description)

    @api.constrains('description', 'type_demande', 'outil_id')
    def _check_besoin(self):
        for rec in self:
            if rec.type_demande == 'outil' and not rec.outil_id:
                raise ValidationError(_("Choisissez l'outil demandé."))
            if not rec.description:
                raise ValidationError(_("Choisissez un matériau ou décrivez votre besoin."))

    @api.constrains('quantite')
    def _check_quantite(self):
        for rec in self:
            if rec.quantite <= 0:
                raise ValidationError(_("La quantité demandée doit être supérieure à 0."))

    def action_soumettre(self):
        self.write({'state': 'soumis'})

    def action_valider(self):
        demandes_outil = self.filtered(lambda d: d.type_demande == 'outil' and not d.attribution_id)
        for demande in demandes_outil:
            outil = demande.outil_id
            if outil.etat != 'disponible':
                raise UserError(_(
                    "%(outil)s n'est pas disponible : %(qui)s. Refusez la demande ou attendez son retour.",
                    outil=outil.name,
                    qui=_("chez %s", outil.attribue_a_id.name) if outil.attribue_a_id
                    else dict(outil._fields['etat']._description_selection(self.env))[outil.etat]))
        self.write({'state': 'valide', 'validateur_id': self.env.user.id})
        self.filtered(lambda d: d.type_demande == 'materiau' and not d.picking_id)._sortir_du_stock()
        # Valider une demande d'outil, c'est le confier à l'ouvrier.
        for demande in demandes_outil:
            demande.attribution_id = self.env['chantier.attribution.outil'].create({
                'chantier_id': demande.chantier_id.id,
                'outil_id': demande.outil_id.id,
                'ouvrier_id': demande.ouvrier_id.id,
            })

    def _sortir_du_stock(self):
        """Matériau accepté : il quitte l'entrepôt pour le chantier (bon de livraison validé).

        Seulement pour un matériau lié à un produit stockable. Le chef n'a pas forcément
        les droits Inventaire : l'opération passe en sudo, la demande gardant la trace du bon.
        """
        for demande in self.filtered(lambda d: d.materiau_id.product_id.is_storable):
            produit = demande.materiau_id.product_id
            entrepot = self.env['stock.warehouse'].sudo().search(
                [('company_id', '=', self.env.company.id)], limit=1)
            if not entrepot:
                continue
            type_sortie = entrepot.out_type_id
            depart = type_sortie.default_location_src_id or entrepot.lot_stock_id
            arrivee = self.env.ref('stock.stock_location_customers')
            picking = self.env['stock.picking'].sudo().create({
                'picking_type_id': type_sortie.id,
                'partner_id': demande.chantier_id.client_id.id,
                'origin': '%s - %s' % (demande.chantier_id.ref or demande.chantier_id.name, demande.description),
                'location_id': depart.id,
                'location_dest_id': arrivee.id,
                'move_ids': [Command.create({
                    'product_id': produit.id,
                    'product_uom_qty': demande.quantite,
                    'product_uom': produit.uom_id.id,
                    'location_id': depart.id,
                    'location_dest_id': arrivee.id,
                })],
            })
            picking.action_confirm()
            for move in picking.move_ids:
                move.quantity = move.product_uom_qty
                move.picked = True
            picking.with_context(skip_backorder=True, skip_sms=True).button_validate()
            demande.picking_id = picking

    def write(self, vals):
        res = super().write(vals)
        if vals.get('state') in ('valide', 'refuse'):
            self._prevenir_ouvrier()
        if vals.get('state') == 'soumis':
            self.env['chantier.journal']._enregistrer(
                'demande_envoyee', self, description=lambda d: d._resume_journal())
        return res

    def _prevenir_ouvrier(self):
        """Message dans la boîte de réception de l'ouvrier quand le chef a tranché."""
        for demande in self:
            if demande.ouvrier_id == self.env.user:
                continue
            if demande.state == 'valide':
                corps = _("Votre demande « %(objet)s » a été acceptée par %(chef)s.",
                          objet=demande.description, chef=self.env.user.name)
                if demande.attribution_id.date_retour_prevue:
                    corps = _("%(corps)s L'outil est à vous, à rendre pour le %(date)s.", corps=corps,
                              date=demande.attribution_id.date_retour_prevue.strftime('%d/%m/%Y'))
            else:
                corps = _("Votre demande « %(objet)s » a été refusée par %(chef)s : %(motif)s",
                          objet=demande.description, chef=self.env.user.name, motif=demande.note or '-')
            demande.message_post(body=corps, partner_ids=demande.ouvrier_id.partner_id.ids,
                                 subtype_xmlid='mail.mt_comment')

    def action_refuser(self):
        return {
            'type': 'ir.actions.act_window',
            'res_model': 'chantier.wizard.refus',
            'view_mode': 'form',
            'target': 'new',
            'context': {'active_model': self._name, 'active_ids': self.ids},
        }

    def action_reset(self):
        self.write({'state': 'brouillon', 'validateur_id': False})
