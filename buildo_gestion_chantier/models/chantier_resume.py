import json

from markupsafe import Markup

from odoo import models, fields, _

PARAM_DERNIER_RESUME = 'buildo_gestion_chantier.dernier_resume'


class ChantierChantier(models.Model):
    _inherit = 'chantier.chantier'

    def _cron_resume_quotidien(self):
        """Résumé de l'activité terrain posté chaque soir dans le canal « Résumé BUILDO » de la direction.

        Couvre tout ce qui a été encodé depuis le résumé précédent (heures, photos,
        demandes de matériel), pour ne rien oublier ni compter deux fois si une
        exécution est manquée. Le repère est le dernier identifiant traité par
        modèle, plus fiable qu'une date (create_date est l'heure de début de la
        transaction). Un pointage encore ouvert sera compté au résumé suivant.
        Rien n'est posté s'il n'y a eu aucune activité.
        """
        params = self.env['ir.config_parameter'].sudo()
        reperes = json.loads(params.get_param(PARAM_DERNIER_RESUME) or '{}')
        hier = fields.Datetime.subtract(fields.Datetime.now(), days=1)

        def nouveaux(modele, domaine=()):
            # Premier résumé : les dernières 24 heures.
            depart = [('id', '>', reperes[modele])] if modele in reperes else [('create_date', '>=', hier)]
            records = self.env[modele].sudo().search(depart + list(domaine), order='id')
            if records:
                reperes[modele] = records[-1].id
            else:
                reperes.setdefault(modele, self.env[modele].sudo().search([], order='id desc', limit=1).id or 0)
            return records

        # Un pointage encore ouvert est mis en attente et compté au résumé suivant.
        heures = nouveaux('chantier.heure.prestee') | self.env['chantier.heure.prestee'].sudo().browse(
            reperes.get('pointages_en_attente', [])).exists()
        reperes['pointages_en_attente'] = heures.filtered('pointage_en_cours').ids
        heures -= heures.filtered('pointage_en_cours')
        photos = nouveaux('chantier.photo')
        demandes = nouveaux('chantier.demande.materiel')
        params.set_param(PARAM_DERNIER_RESUME, json.dumps(reperes))

        chantiers = (heures.chantier_id | photos.chantier_id | demandes.chantier_id).sorted('name')
        if not chantiers:
            return False
        lignes = Markup().join(
            Markup('<tr><td><a href="#" data-oe-model="chantier.chantier" data-oe-id="%s">%s</a></td>'
                   '<td>%s</td><td>%s</td><td>%s</td></tr>') % (
                chantier.id, chantier.display_name,
                _format_heures(sum(heures.filtered(lambda h: h.chantier_id == chantier).mapped('nb_heures'))),
                len(photos.filtered(lambda p: p.chantier_id == chantier)),
                len(demandes.filtered(lambda d: d.chantier_id == chantier)),
            ) for chantier in chantiers
        )
        corps = Markup(
            '<p><b>%s</b></p><p>%s</p>'
            '<table class="table table-sm"><thead><tr><th>%s</th><th>%s</th><th>%s</th><th>%s</th></tr></thead>'
            '<tbody>%s</tbody></table>'
        ) % (
            _("Résumé de l'activité terrain"),
            _("%(heures)s encodées, %(photos)s photo(s), %(demandes)s demande(s) de matériel sur %(chantiers)s chantier(s).",
              heures=_format_heures(sum(heures.mapped('nb_heures'))), photos=len(photos),
              demandes=len(demandes), chantiers=len(chantiers)),
            _("Chantier"), _("Heures"), _("Photos"), _("Demandes"), lignes,
        ) + self.sudo()._points_d_attention()
        canal = self.env.ref('buildo_gestion_chantier.canal_resume_buildo').sudo()
        return canal.message_post(
            body=corps, message_type='comment', subtype_xmlid='mail.mt_comment',
            author_id=self.env.ref('base.partner_root').id,
        )

    def _points_d_attention(self):
        """Outils en retard et chantiers hors budget, ajoutés en fin de résumé."""
        retards = self.env['chantier.attribution.outil'].search([('en_retard', '=', True)], order='date_retour_prevue')
        hors_budget = self._chantiers_hors_budget()
        if not retards and not hors_budget:
            return Markup()
        items = []
        if hors_budget:
            items.append(Markup('<li>%s %s</li>') % (
                _("Budget dépassé :"),
                Markup(', ').join(
                    Markup('<a href="#" data-oe-model="chantier.chantier" data-oe-id="%s">%s</a> (+%s %%)') % (
                        c.id, c.display_name, round(c._depassement_budget_pct()))
                    for c in hors_budget),
            ))
        if retards:
            visibles = retards[:10]
            detail = Markup(', ').join(
                Markup('%s (%s)') % (a.outil_id.name, a.ouvrier_id.name) for a in visibles)
            if len(retards) > len(visibles):
                detail += Markup(' ') + _("et %s autre(s)", len(retards) - len(visibles))
            items.append(Markup('<li>%s %s</li>') % (
                _("%s outil(s) pas rendu(s) à temps :", len(retards)), detail))
        return Markup('<p><b>%s</b></p><ul>%s</ul>') % (_("Points d'attention"), Markup().join(items))

    def action_envoyer_resume(self):
        """Envoie le résumé tout de suite (démonstration), sans attendre l'exécution du soir."""
        message = self._cron_resume_quotidien()
        return {
            'type': 'ir.actions.client',
            'tag': 'display_notification',
            'params': {
                'message': _("Résumé posté dans le canal « Résumé BUILDO ».") if message
                else _("Aucune activité terrain depuis le dernier résumé."),
                'type': 'success' if message else 'info',
            },
        }


def _format_heures(heures):
    return '%d:%02d' % divmod(round(heures * 60), 60)
