from odoo import models, fields, api, _
from odoo.exceptions import UserError, ValidationError


class ChantierChantier(models.Model):
    _name = 'chantier.chantier'
    _description = 'Chantier de construction'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _rec_name = 'name'
    _order = 'date_debut desc, id desc'

    name = fields.Char('Nom du chantier', required=True, tracking=True)
    # Archivage (soft delete) : un chantier qui porte des transactions n'est jamais supprimé
    active = fields.Boolean('Actif', default=True, tracking=True)
    ref = fields.Char('Référence', readonly=True, copy=False, default='Nouveau')
    client_id = fields.Many2one('res.partner', 'Client', required=True, tracking=True,
                                domain=[('customer_rank', '>', 0)])
    chef_chantier_id = fields.Many2one('res.users', 'Chef de chantier', tracking=True)
    date_debut = fields.Date('Date de début', tracking=True)
    date_fin_prevue = fields.Date('Date de fin prévue', tracking=True)
    date_fin_reelle = fields.Date('Date de fin réelle')
    adresse = fields.Char('Adresse du chantier')
    budget_initial = fields.Monetary('Budget initial', currency_field='currency_id', tracking=True,
                                     groups='buildo_gestion_chantier.group_chef_chantier')
    currency_id = fields.Many2one('res.currency', default=lambda self: self.env.company.currency_id)
    description = fields.Text('Description')
    state = fields.Selection([
        ('brouillon', 'Brouillon'),
        ('en_cours', 'En cours'),
        ('termine', 'Terminé'),
        ('annule', 'Annulé'),
    ], default='brouillon', string='État', tracking=True)

    tache_ids = fields.One2many('chantier.tache', 'chantier_id', 'Tâches')
    heure_prestee_ids = fields.One2many('chantier.heure.prestee', 'chantier_id', 'Heures prestées')
    demande_materiel_ids = fields.One2many('chantier.demande.materiel', 'chantier_id', 'Demandes matériel')
    rapport_journalier_ids = fields.One2many('chantier.rapport.journalier', 'chantier_id', 'Rapports journaliers',
                                             groups='buildo_gestion_chantier.group_chef_chantier')
    photo_ids = fields.One2many('chantier.photo', 'chantier_id', 'Photos')
    plan_ids = fields.One2many('chantier.plan', 'chantier_id', 'Plans',
                               groups='buildo_gestion_chantier.group_chef_chantier')
    estimation_materiau_ids = fields.One2many('chantier.estimation.materiau', 'chantier_id', 'Estimations matériaux',
                                              groups='buildo_gestion_chantier.group_chef_chantier')
    estimation_outil_ids = fields.One2many('chantier.estimation.outil', 'chantier_id', 'Estimations outils',
                                           groups='buildo_gestion_chantier.group_chef_chantier')
    attribution_outil_ids = fields.One2many('chantier.attribution.outil', 'chantier_id', 'Attributions outils')
    devis_ids = fields.One2many('sale.order', 'chantier_id', 'Devis / Bons de commande',
                                groups='buildo_gestion_chantier.group_service_administratif')
    facture_ids = fields.One2many('account.move', 'chantier_id', 'Factures',
                                  domain=[('move_type', '=', 'out_invoice')],
                                  groups='buildo_gestion_chantier.group_service_administratif')
    commande_fournisseur_ids = fields.One2many('purchase.order', 'chantier_id', 'Commandes fournisseur',
                                               groups='buildo_gestion_chantier.group_service_administratif')
    paiement_fss_ids = fields.One2many('chantier.paiement.fss', 'chantier_id', 'Paiements FSS',
                                       groups='buildo_gestion_chantier.group_service_administratif')
    avenant_ids = fields.One2many('chantier.avenant', 'chantier_id', 'Avenants',
                                  groups='buildo_gestion_chantier.group_service_administratif')

    cout_reel = fields.Monetary('Coût réel', compute='_compute_financier', currency_field='currency_id', store=True,
                                groups='buildo_gestion_chantier.group_chef_chantier')
    cout_main_oeuvre = fields.Monetary('Main d\'œuvre', compute='_compute_financier', currency_field='currency_id', store=True,
                                       groups='buildo_gestion_chantier.group_chef_chantier')
    cout_materiaux = fields.Monetary('Achats matériaux', compute='_compute_financier', currency_field='currency_id', store=True,
                                     groups='buildo_gestion_chantier.group_chef_chantier')
    montant_facture = fields.Monetary('Montant facturé', compute='_compute_financier', currency_field='currency_id', store=True,
                                      groups='buildo_gestion_chantier.group_chef_chantier')
    marge = fields.Monetary('Marge', compute='_compute_financier', currency_field='currency_id', store=True,
                            groups='buildo_gestion_chantier.group_chef_chantier')
    montant_avenants_acceptes = fields.Monetary('Avenants acceptés', compute='_compute_financier', currency_field='currency_id', store=True,
                                                groups='buildo_gestion_chantier.group_chef_chantier')
    budget_revise = fields.Monetary('Budget révisé', compute='_compute_financier', currency_field='currency_id', store=True,
                                     help="Budget initial augmenté du montant des avenants acceptés.",
                                    groups='buildo_gestion_chantier.group_chef_chantier')
    nb_heures = fields.Float('Heures validées', compute='_compute_heures', store=True)
    avancement = fields.Float('Avancement (%)', compute='_compute_avancement', store=True)

    @api.constrains('date_debut', 'date_fin_prevue')
    def _check_dates(self):
        for rec in self:
            if rec.date_debut and rec.date_fin_prevue and rec.date_fin_prevue < rec.date_debut:
                raise ValidationError(_("La date de fin prévue ne peut pas être antérieure à la date de début."))

    @api.constrains('budget_initial')
    def _check_budget(self):
        for rec in self:
            if rec.budget_initial is not False and rec.budget_initial < 0:
                raise ValidationError(_("Le budget initial ne peut pas être négatif."))

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('ref', 'Nouveau') == 'Nouveau':
                vals['ref'] = self.env['ir.sequence'].next_by_code('chantier.chantier') or 'Nouveau'
        return super().create(vals_list)

    @api.depends('heure_prestee_ids.montant', 'heure_prestee_ids.state',
                 'commande_fournisseur_ids.amount_total', 'commande_fournisseur_ids.state',
                 'facture_ids.amount_total', 'facture_ids.payment_state', 'facture_ids.move_type',
                 'avenant_ids.montant_ht', 'avenant_ids.state', 'budget_initial')
    def _compute_financier(self):
        for rec in self:
            rec.cout_main_oeuvre = sum(
                rec.heure_prestee_ids.filtered(lambda h: h.state == 'valide').mapped('montant')
            )
            # Commandes fournisseur confirmées ou reçues (purchase.order)
            rec.cout_materiaux = sum(
                rec.commande_fournisseur_ids.filtered(
                    lambda c: c.state in ('purchase', 'done')
                ).mapped('amount_total')
            )
            rec.cout_reel = rec.cout_main_oeuvre + rec.cout_materiaux
            # Factures clients encaissées ou partiellement encaissées (account.move)
            # Inclut 'paid', 'in_payment' et déduit les avoirs (out_refund via amount_residual)
            rec.montant_facture = sum(
                rec.facture_ids.filtered(
                    lambda f: f.move_type == 'out_invoice'
                    and f.payment_state in ('paid', 'in_payment', 'partial')
                ).mapped('amount_total')
            )
            rec.marge = rec.montant_facture - rec.cout_reel
            rec.montant_avenants_acceptes = sum(
                rec.avenant_ids.filtered(lambda a: a.state == 'accepte').mapped('montant_ht')
            )
            rec.budget_revise = (rec.budget_initial or 0.0) + rec.montant_avenants_acceptes

    @api.depends('heure_prestee_ids.nb_heures', 'heure_prestee_ids.state')
    def _compute_heures(self):
        for rec in self:
            rec.nb_heures = sum(
                rec.heure_prestee_ids.filtered(lambda h: h.state == 'valide').mapped('nb_heures')
            )

    @api.depends('tache_ids.state')
    def _compute_avancement(self):
        for rec in self:
            taches = rec.tache_ids
            if not taches:
                rec.avancement = 0.0
            else:
                nb_fait = len(taches.filtered(lambda t: t.state == 'fait'))
                rec.avancement = (nb_fait / len(taches)) * 100

    def _get_transactions_bloquantes(self):
        """Liste lisible des transactions qui interdisent la suppression physique du chantier.

        Les comptages sont faits en sudo : le blocage doit dépendre des données
        existantes, pas de ce que l'utilisateur courant a le droit de voir.
        """
        self.ensure_one()
        env = self.sudo().env
        domain = [('chantier_id', '=', self.id)]
        comptages = [
            (env['chantier.heure.prestee'].search_count(domain), _("heure(s) prestée(s)")),
            (env['chantier.paiement.fss'].search_count(domain), _("paiement(s) FSS")),
            (env['account.move'].search_count(domain + [('state', '!=', 'draft')]),
             _("pièce(s) comptable(s) validée(s)")),
            (env['purchase.order'].search_count(domain + [('state', 'in', ('purchase', 'done'))]),
             _("commande(s) fournisseur confirmée(s)")),
            (env['sale.order'].search_count(domain + [('state', '=', 'sale')]),
             _("bon(s) de commande client confirmé(s)")),
        ]
        return ["%d %s" % (nombre, libelle) for nombre, libelle in comptages if nombre]

    def unlink(self):
        # Contrôle des droits d'abord : un rôle sans droit de suppression doit
        # recevoir une AccessError, pas le message métier ci-dessous.
        self.check_access('unlink')
        for chantier in self:
            transactions = chantier._get_transactions_bloquantes()
            if transactions:
                raise UserError(_(
                    "Le chantier « %(chantier)s » ne peut pas être supprimé : il contient %(transactions)s.\n"
                    "Ces données doivent être conservées (obligation légale). "
                    "Archivez le chantier à la place.",
                    chantier=chantier.display_name, transactions=", ".join(transactions),
                ))
        return super().unlink()

    def action_view_devis(self):
        return {
            'type': 'ir.actions.act_window',
            'name': 'Devis / Bons de commande',
            'res_model': 'sale.order',
            'view_mode': 'list,form',
            'domain': [('chantier_id', '=', self.id)],
            'context': {'default_chantier_id': self.id, 'default_partner_id': self.client_id.id},
        }

    def action_view_factures(self):
        return {
            'type': 'ir.actions.act_window',
            'name': 'Factures',
            'res_model': 'account.move',
            'view_mode': 'list,form',
            'domain': [('chantier_id', '=', self.id), ('move_type', '=', 'out_invoice')],
            'context': {'default_chantier_id': self.id, 'default_move_type': 'out_invoice',
                        'default_partner_id': self.client_id.id},
        }

    def action_view_commandes(self):
        return {
            'type': 'ir.actions.act_window',
            'name': 'Commandes fournisseur',
            'res_model': 'purchase.order',
            'view_mode': 'list,form',
            'domain': [('chantier_id', '=', self.id)],
            'context': {'default_chantier_id': self.id},
        }

    def action_start(self):
        self.write({'state': 'en_cours'})

    def action_terminate(self):
        self.write({'state': 'termine'})

    def action_cancel(self):
        self.write({'state': 'annule'})

    def action_reset_draft(self):
        self.write({'state': 'brouillon'})

    def action_ouvrir_assistant(self):
        return self.env['chantier.assistant.ia']._action_fenetre(context={'default_chantier_id': self.id})

    def action_ouvrir_rapport_avancement(self):
        return {
            'type': 'ir.actions.act_window',
            'name': "Rapport d'avancement à envoyer au client",
            'res_model': 'chantier.wizard.rapport.avancement',
            'view_mode': 'form',
            'target': 'new',
            'context': {'active_id': self.id},
        }
