import logging
import math

from odoo import models, fields, api, _
from odoo.exceptions import UserError, ValidationError

_logger = logging.getLogger(__name__)


def _distance_km(a, b):
    """Distance approximative entre deux positions (latitude, longitude), suffisante à l'échelle de la Belgique."""
    lat = math.radians((a[0] + b[0]) / 2)
    return 111.2 * math.hypot(a[0] - b[0], (a[1] - b[1]) * math.cos(lat))


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
    # Position sur la carte, calculée à partir de l'adresse (OpenStreetMap Nominatim).
    latitude = fields.Float('Latitude', digits=(10, 7), copy=False)
    longitude = fields.Float('Longitude', digits=(10, 7), copy=False)
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
    avoir_ids = fields.One2many('account.move', 'chantier_id', 'Avoirs',
                                domain=[('move_type', '=', 'out_refund')],
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
    detail_couts_visible = fields.Boolean(compute='_compute_detail_couts_visible')

    @api.depends('chef_chantier_id')
    @api.depends_context('uid')
    def _compute_detail_couts_visible(self):
        # Un chef ne lit que les heures des chantiers qu'il dirige (plus les siennes) : sur le
        # chantier d'un collègue, la liste ne correspondrait pas au montant de la carte.
        tout_voir = self.env.user.has_group('buildo_gestion_chantier.group_service_administratif')
        for rec in self:
            rec.detail_couts_visible = tout_voir or rec.chef_chantier_id == self.env.user

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
        chantiers = super().create(vals_list)
        chantiers.filtered('adresse')._localiser()
        return chantiers

    def write(self, vals):
        if 'adresse' in vals and not {'latitude', 'longitude'} & vals.keys():
            # Nouvelle adresse : l'ancienne position n'est plus valable.
            vals = dict(vals, latitude=0.0, longitude=0.0)
        res = super().write(vals)
        if vals.get('adresse'):
            self._localiser()
        return res

    def _localiser(self):
        """Calcule la position de chaque chantier à partir de son adresse.

        L'adresse complète est contrôlée par la position de la commune (partie
        après la dernière virgule, ex. « 3000 Louvain ») : si la rue est trouvée
        à plus de 10 km de sa commune, c'est une rue homonyme ailleurs et la
        position de la commune est gardée. Une erreur réseau ne bloque jamais
        l'enregistrement : le chantier reste simplement absent de la carte.
        Renvoie les chantiers qui n'ont pas pu être localisés.
        """
        echecs = self.browse()
        for rec in self:
            adresse = (rec.adresse or '').strip()
            position = rec._geocoder(adresse)
            if ',' in adresse:
                commune = rec._geocoder(adresse.rsplit(',', 1)[-1])
                if commune and (not position or _distance_km(position, commune) > 10):
                    position = commune
            if position:
                rec.sudo().write({'latitude': position[0], 'longitude': position[1]})
            else:
                echecs |= rec
        return echecs

    def _geocoder(self, adresse):
        if not adresse.strip():
            return None
        try:
            return self.env['base.geocoder'].geo_find('%s, Belgique' % adresse.strip())
        except Exception:  # noqa: BLE001 - service externe indisponible
            _logger.info("Géolocalisation impossible pour « %s »", adresse, exc_info=True)
            return None

    def action_localiser(self):
        echecs = self._localiser()
        if echecs:
            raise UserError(_("Adresse introuvable sur la carte : %(chantiers)s. Vérifiez l'adresse (rue, numéro, code postal, commune).",
                              chantiers=', '.join(echecs.mapped('name'))))
        return {
            'type': 'ir.actions.client',
            'tag': 'display_notification',
            'params': {'message': _("Chantier localisé sur la carte."), 'type': 'success'},
        }

    @api.depends('heure_prestee_ids.montant', 'heure_prestee_ids.state',
                 'commande_fournisseur_ids.amount_total', 'commande_fournisseur_ids.state',
                 'facture_ids.state', 'facture_ids.amount_total_signed', 'facture_ids.amount_residual_signed',
                 'avoir_ids.state', 'avoir_ids.amount_total_signed', 'avoir_ids.amount_residual_signed',
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
            # Montant encaissé : part déjà réglée des factures clients validées, moins
            # la part réglée des avoirs. Les montants « signed » sont positifs pour une
            # facture et négatifs pour un avoir ; total - reste à payer = part réglée.
            # Une facture partiellement payée ne compte donc que pour ce qui a été payé.
            pieces = (rec.facture_ids | rec.avoir_ids).filtered(lambda m: m.state == 'posted')
            rec.montant_facture = sum(
                m.amount_total_signed - m.amount_residual_signed for m in pieces
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

    # Cartes « Indicateurs financiers » : chaque montant ouvre les pièces qui le composent.

    def action_voir_taches(self):
        self.ensure_one()
        return {
            'type': 'ir.actions.act_window',
            'name': _("Tâches · %s", self.name),
            'res_model': 'chantier.tache',
            'view_mode': 'list,kanban,form',
            'mobile_view_mode': 'kanban',
            'domain': [('chantier_id', '=', self.id)],
            'context': {'default_chantier_id': self.id},
        }

    def action_voir_main_oeuvre(self):
        self.ensure_one()
        return {
            'type': 'ir.actions.act_window',
            'name': _("Main d'œuvre · %s", self.name),
            'res_model': 'chantier.heure.prestee',
            'view_mode': 'list,kanban,form',
            'mobile_view_mode': 'kanban',
            'domain': [('chantier_id', '=', self.id), ('state', '=', 'valide')],
            'context': {'search_default_group_ouvrier': 1, 'create': False, 'masquer_pointage': True},
        }

    def action_voir_achats(self):
        self.ensure_one()
        return {
            'type': 'ir.actions.act_window',
            'name': _("Achats matériaux · %s", self.name),
            'res_model': 'purchase.order',
            'view_mode': 'list,form',
            'domain': [('chantier_id', '=', self.id), ('state', 'in', ('purchase', 'done'))],
            'context': {'create': False},
        }

    def action_voir_encaissements(self):
        self.ensure_one()
        return {
            'type': 'ir.actions.act_window',
            'name': _("Factures et avoirs · %s", self.name),
            'res_model': 'account.move',
            'view_mode': 'list,form',
            'domain': [('chantier_id', '=', self.id), ('state', '=', 'posted'),
                       ('move_type', 'in', ('out_invoice', 'out_refund'))],
            'context': {'create': False},
        }

    def action_voir_analyse_marge(self):
        self.ensure_one()
        return {
            'type': 'ir.actions.act_window',
            'name': _("Budget et marge · %s", self.name),
            'res_model': 'chantier.chantier',
            'view_mode': 'pivot',
            'views': [(self.env.ref('buildo_gestion_chantier.view_chantier_pivot').id, 'pivot')],
            'domain': [('id', '=', self.id)],
            'context': {'pivot_row_groupby': ['name'], 'pivot_column_groupby': []},
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
