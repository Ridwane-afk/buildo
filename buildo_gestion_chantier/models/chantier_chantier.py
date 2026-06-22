from odoo import models, fields, api
from odoo.exceptions import ValidationError


class ChantierChantier(models.Model):
    _name = 'chantier.chantier'
    _description = 'Chantier de construction'
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _rec_name = 'name'
    _order = 'date_debut desc, id desc'

    name = fields.Char('Nom du chantier', required=True, tracking=True)
    ref = fields.Char('Référence', readonly=True, copy=False, default='Nouveau')
    client_id = fields.Many2one('res.partner', 'Client', required=True, tracking=True,
                                domain=[('customer_rank', '>', 0)])
    chef_chantier_id = fields.Many2one('res.users', 'Chef de chantier', tracking=True)
    date_debut = fields.Date('Date de début', tracking=True)
    date_fin_prevue = fields.Date('Date de fin prévue', tracking=True)
    date_fin_reelle = fields.Date('Date de fin réelle')
    adresse = fields.Char('Adresse du chantier')
    budget_initial = fields.Monetary('Budget initial', currency_field='currency_id', tracking=True)
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
    rapport_journalier_ids = fields.One2many('chantier.rapport.journalier', 'chantier_id', 'Rapports journaliers')
    photo_ids = fields.One2many('chantier.photo', 'chantier_id', 'Photos')
    plan_ids = fields.One2many('chantier.plan', 'chantier_id', 'Plans')
    estimation_materiau_ids = fields.One2many('chantier.estimation.materiau', 'chantier_id', 'Estimations matériaux')
    estimation_outil_ids = fields.One2many('chantier.estimation.outil', 'chantier_id', 'Estimations outils')
    attribution_outil_ids = fields.One2many('chantier.attribution.outil', 'chantier_id', 'Attributions outils')
    devis_ids = fields.One2many('sale.order', 'chantier_id', 'Devis / Bons de commande')
    facture_ids = fields.One2many('account.move', 'chantier_id', 'Factures',
                                  domain=[('move_type', '=', 'out_invoice')])
    commande_fournisseur_ids = fields.One2many('purchase.order', 'chantier_id', 'Commandes fournisseur')
    paiement_fss_ids = fields.One2many('chantier.paiement.fss', 'chantier_id', 'Paiements FSS')

    cout_reel = fields.Monetary('Coût réel', compute='_compute_financier', currency_field='currency_id', store=True)
    cout_main_oeuvre = fields.Monetary('Main d\'œuvre', compute='_compute_financier', currency_field='currency_id', store=True)
    cout_materiaux = fields.Monetary('Achats matériaux', compute='_compute_financier', currency_field='currency_id', store=True)
    montant_facture = fields.Monetary('Montant facturé', compute='_compute_financier', currency_field='currency_id', store=True)
    marge = fields.Monetary('Marge', compute='_compute_financier', currency_field='currency_id', store=True)
    nb_heures = fields.Float('Heures validées', compute='_compute_heures', store=True)
    avancement = fields.Float('Avancement (%)', compute='_compute_avancement', store=True)

    @api.constrains('date_debut', 'date_fin_prevue')
    def _check_dates(self):
        for rec in self:
            if rec.date_debut and rec.date_fin_prevue and rec.date_fin_prevue < rec.date_debut:
                raise ValidationError("La date de fin prévue ne peut pas être antérieure à la date de début.")

    @api.constrains('budget_initial')
    def _check_budget(self):
        for rec in self:
            if rec.budget_initial is not False and rec.budget_initial < 0:
                raise ValidationError("Le budget initial ne peut pas être négatif.")

    @api.model_create_multi
    def create(self, vals_list):
        for vals in vals_list:
            if vals.get('ref', 'Nouveau') == 'Nouveau':
                vals['ref'] = self.env['ir.sequence'].next_by_code('chantier.chantier') or 'Nouveau'
        return super().create(vals_list)

    @api.depends('heure_prestee_ids.montant', 'heure_prestee_ids.state',
                 'commande_fournisseur_ids.amount_total', 'commande_fournisseur_ids.state',
                 'facture_ids.amount_total', 'facture_ids.payment_state', 'facture_ids.move_type')
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
        wizard = self.env['chantier.assistant.ia'].create({'chantier_id': self.id})
        return {
            'type': 'ir.actions.act_window',
            'res_model': 'chantier.assistant.ia',
            'res_id': wizard.id,
            'view_mode': 'form',
            'target': 'new',
        }
