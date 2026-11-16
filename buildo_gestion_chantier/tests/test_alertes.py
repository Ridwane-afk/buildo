from odoo.tests import tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestAlertes(ChantierTestCommon):
    """Alertes : activité « à valider » pour le chef, résumé quotidien pour la direction."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        g = 'buildo_gestion_chantier.group_%s'
        cls.ouvrier = cls._create_buildo_user('alerte_ouvrier', g % 'ouvrier')
        cls.chef = cls._create_buildo_user('alerte_chef', g % 'chef_chantier')
        cls.direction = cls._create_buildo_user('alerte_direction', g % 'direction')
        cls.chantier.write({'chef_chantier_id': cls.chef.id, 'state': 'en_cours'})
        cls.canal = cls.env.ref('buildo_gestion_chantier.canal_resume_buildo')
        # Le résumé couvre ce qui a été encodé depuis le précédent : on part d'une page blanche.
        cls.env['chantier.chantier']._cron_resume_quotidien()

    def _heure(self, user, nb=7.5):
        return self.env['chantier.heure.prestee'].with_user(user).create(
            {'chantier_id': self.chantier.id, 'nb_heures': nb, 'description': 'Coffrage'})

    def _activites_chef(self, rec):
        return rec.activity_ids.filtered(lambda a: a.user_id == self.chef)

    def test_heures_soumises_alertent_le_chef(self):
        heure = self._heure(self.ouvrier)
        self.assertFalse(heure.activity_ids, "Pas d'alerte tant que l'ouvrier n'a pas soumis")
        heure.with_user(self.ouvrier).action_soumettre()
        activite = self._activites_chef(heure)
        self.assertEqual(len(activite), 1)
        self.assertIn('À valider', activite.summary)
        heure.with_user(self.chef).action_valider()
        self.assertFalse(heure.activity_ids, "Activité clôturée à la validation")

    def test_pas_de_doublon_et_cloture_au_refus(self):
        demande = self.env['chantier.demande.materiel'].with_user(self.ouvrier).create(
            {'chantier_id': self.chantier.id, 'description': 'Gants', 'quantite': 2})
        demande.with_user(self.ouvrier).action_soumettre()
        demande.with_user(self.ouvrier).write({'state': 'soumis'})
        self.assertEqual(len(self._activites_chef(demande)), 1)
        demande.with_user(self.chef).write({'state': 'refuse'})
        self.assertFalse(demande.activity_ids)

    def test_chef_qui_encode_lui_meme_n_est_pas_alerte(self):
        heure = self.env['chantier.heure.prestee'].with_user(self.chef).create(
            {'chantier_id': self.chantier.id, 'ouvrier_id': self.ouvrier.id, 'nb_heures': 4})
        heure.with_user(self.chef).action_soumettre()
        self.assertFalse(heure.activity_ids)

    def test_resume_quotidien_dans_le_canal_direction(self):
        self.assertIn(self.direction.partner_id, self.canal.channel_member_ids.partner_id,
                      "La direction est abonnée automatiquement au canal")
        self.assertNotIn(self.ouvrier.partner_id, self.canal.channel_member_ids.partner_id)
        self._heure(self.ouvrier, 7.5)
        self._heure(self.ouvrier, 1)
        tache = self.env['chantier.tache'].create({'name': 'Dalle', 'chantier_id': self.chantier.id,
                                                   'ouvrier_ids': [(6, 0, self.ouvrier.ids)]})
        self.env['chantier.photo'].with_user(self.ouvrier).create(
            {'chantier_id': self.chantier.id, 'tache_id': tache.id, 'name': 'Dalle coulée'})
        message = self.env['chantier.chantier']._cron_resume_quotidien()
        self.assertEqual(message.model, 'discuss.channel')
        self.assertEqual(message.res_id, self.canal.id)
        self.assertIn('8:30 encodées, 1 photo(s), 0 demande(s)', message.body)
        self.assertIn(self.chantier.name, message.body)
        # Rien de neuf depuis : aucun message.
        self.assertFalse(self.env['chantier.chantier']._cron_resume_quotidien())

    def test_pointage_ouvert_compte_au_resume_suivant(self):
        self.env['chantier.tache'].create({'name': 'Gros oeuvre', 'chantier_id': self.chantier.id,
                                           'ouvrier_ids': [(6, 0, self.ouvrier.ids)]})
        Heure = self.env['chantier.heure.prestee'].with_user(self.ouvrier)
        Heure.action_pointer_arrivee()
        self.assertFalse(self.env['chantier.chantier']._cron_resume_quotidien(), "Pointage ouvert : rien à résumer")
        Heure.action_pointer_depart()
        message = self.env['chantier.chantier']._cron_resume_quotidien()
        self.assertIn('0:15 encodées', message.body)
