from datetime import timedelta

from odoo import models, fields, _

TYPE_OUTIL = 'buildo_gestion_chantier.activite_outil_a_rendre'
TYPE_HEURES = 'buildo_gestion_chantier.activite_heures_a_encoder'
TYPE_BUDGET = 'buildo_gestion_chantier.activite_budget_depasse'


def _jour_ouvrable_precedent(jour):
    jour -= timedelta(days=1)
    while jour.weekday() >= 5:
        jour -= timedelta(days=1)
    return jour


class ChantierChantier(models.Model):
    _inherit = 'chantier.chantier'

    def _cron_alertes_quotidiennes(self):
        """Chaque matin : rappels aux ouvriers (outil à rendre, heures oubliées) et au chef (budget dépassé).

        Une seule activité ouverte par sujet : relancer le cron ne crée pas de doublon,
        et l'activité se ferme d'elle-même quand le problème est réglé.
        """
        self = self.sudo()
        return {
            'outils': self._alerter_outils_en_retard(),
            'heures': self._alerter_heures_manquantes(),
            'budget': self._alerter_budgets_depasses(),
        }

    def _activite_ouverte(self, record, type_xmlid, user):
        type_activite = self.env.ref(type_xmlid)
        return record.activity_ids.filtered(lambda a: a.activity_type_id == type_activite and a.user_id == user)

    def _alerter_outils_en_retard(self):
        attributions = self.env['chantier.attribution.outil'].search([('en_retard', '=', True)])
        nouvelles = self.env['chantier.attribution.outil']
        for attribution in attributions:
            if self._activite_ouverte(attribution, TYPE_OUTIL, attribution.ouvrier_id):
                continue
            attribution.activity_schedule(
                TYPE_OUTIL, user_id=attribution.ouvrier_id.id,
                summary=_("Rendre %(outil)s", outil=attribution.outil_id.name),
                note=_("Retour prévu le %(date)s sur le chantier %(chantier)s.",
                       date=attribution.date_retour_prevue.strftime('%d/%m/%Y'),
                       chantier=attribution.chantier_id.name),
            )
            nouvelles |= attribution
        return nouvelles

    def _alerter_heures_manquantes(self):
        """Rappel aux ouvriers qui avaient une tâche en cours la veille (jour ouvrable) sans rien encoder."""
        jour = _jour_ouvrable_precedent(fields.Date.context_today(self))
        taches = self.env['chantier.tache'].search([
            ('state', '!=', 'fait'),
            ('chantier_id.state', '=', 'en_cours'),
            '|', ('date_debut', '=', False), ('date_debut', '<=', jour),
            '|', ('date_fin', '=', False), ('date_fin', '>=', jour),
        ])
        encodes = self.env['chantier.heure.prestee'].search([('date', '=', jour)]).ouvrier_id
        rappeles = self.env['res.users']
        for ouvrier in (taches.ouvrier_ids - encodes).filtered('active'):
            if self._activites_heures(ouvrier):
                continue
            chantier = taches.filtered(lambda t: ouvrier in t.ouvrier_ids)[:1].chantier_id
            chantier.activity_schedule(
                TYPE_HEURES, user_id=ouvrier.id, date_deadline=fields.Date.context_today(self),
                summary=_("Encoder vos heures du %(date)s", date=jour.strftime('%d/%m/%Y')),
                note=_("Aucune heure encodée ce jour-là. Pensez à Mes heures, ou au bouton « Copier ma dernière journée »."),
            )
            rappeles |= ouvrier
        return rappeles

    def _activites_heures(self, ouvrier):
        return self.env['mail.activity'].sudo().search([
            ('activity_type_id', '=', self.env.ref(TYPE_HEURES).id), ('user_id', '=', ouvrier.id)])

    def _alerter_budgets_depasses(self):
        chantiers = self._chantiers_hors_budget()
        # Budget revenu dans les clous (avenant accepté, facture fournisseur annulée...) : alerte close.
        self._cloturer_alertes(self.search([('activity_type_id', '=', self.env.ref(TYPE_BUDGET).id)]) - chantiers,
                               TYPE_BUDGET, feedback=_("Budget de nouveau respecté"))
        alertes = self.browse()
        for chantier in chantiers.filtered('chef_chantier_id'):
            if self._activite_ouverte(chantier, TYPE_BUDGET, chantier.chef_chantier_id):
                continue
            chantier.activity_schedule(
                TYPE_BUDGET, user_id=chantier.chef_chantier_id.id,
                summary=_("Budget dépassé de %(pct)s %%", pct=round(chantier._depassement_budget_pct())),
                note=_("Coût réel %(cout)s pour un budget révisé de %(budget)s.",
                       cout=chantier._format_montant(chantier.cout_reel),
                       budget=chantier._format_montant(chantier.budget_revise)),
            )
            alertes |= chantier
        return alertes

    def _chantiers_hors_budget(self):
        return self.search([('state', '=', 'en_cours'), ('budget_revise', '>', 0)]).filtered(
            lambda c: c.cout_reel > c.budget_revise)

    def _depassement_budget_pct(self):
        self.ensure_one()
        return (self.cout_reel - self.budget_revise) / self.budget_revise * 100 if self.budget_revise else 0.0

    def _format_montant(self, montant):
        return '%s %s' % (f'{montant:,.2f}'.replace(',', ' ').replace('.', ','), self.currency_id.symbol or '')

    def _cloturer_alertes(self, records, type_xmlid, user=None, feedback=None):
        type_activite = self.env.ref(type_xmlid)
        activites = records.sudo().activity_ids.filtered(
            lambda a: a.activity_type_id == type_activite and (user is None or a.user_id == user))
        if activites:
            activites.action_feedback(feedback=feedback)
