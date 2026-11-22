from datetime import datetime

from freezegun import freeze_time

from odoo.exceptions import AccessError, UserError
from odoo.tests import HttpCase, tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestJournalAudit(HttpCase, ChantierTestCommon):
    """Chaque action importante d'un ouvrier laisse une trace dans le journal d'audit."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.ouvrier = cls._create_buildo_user('journal_ouvrier', 'buildo_gestion_chantier.group_ouvrier')
        cls.chef = cls._create_buildo_user('journal_chef', 'buildo_gestion_chantier.group_chef_chantier')
        cls.admin = cls._create_buildo_user('journal_admin', 'buildo_gestion_chantier.group_admin_buildo')
        cls.chantier.write({'state': 'en_cours', 'chef_chantier_id': cls.chef.id})
        cls.tache = cls.env['chantier.tache'].create({
            'name': 'Coffrage', 'chantier_id': cls.chantier.id, 'ouvrier_ids': [(6, 0, cls.ouvrier.ids)]})
        cls.outil = cls.env['chantier.outil'].create({'name': 'Disqueuse'})
        cls.Heure = cls.env['chantier.heure.prestee'].with_user(cls.ouvrier)

    def _journal(self, action):
        return self.env['chantier.journal'].search([('action', '=', action), ('user_id', 'in', self.ouvrier.ids)])

    def test_pointage_et_heures(self):
        with freeze_time(datetime(2026, 11, 12, 7, 0)):
            self.Heure.action_pointer_arrivee()
        with freeze_time(datetime(2026, 11, 12, 15, 30)):
            self.Heure.action_pointer_depart()
        ligne = self.Heure.search([('ouvrier_id', '=', self.ouvrier.id)])
        arrivee, depart = self._journal('pointage_arrivee'), self._journal('pointage_depart')
        self.assertEqual(len(arrivee), 1)
        self.assertEqual(arrivee.chantier_id, self.chantier)
        self.assertEqual((arrivee.res_model, arrivee.res_id), ('chantier.heure.prestee', ligne.id))
        self.assertIn('8:30', depart.description)
        self.assertFalse(self._journal('heures_modifiees'), "Pointer son départ n'est pas une correction")

        ligne.write({'nb_heures': 8.0, 'description': 'Pause de midi'})
        modif = self._journal('heures_modifiees')
        self.assertEqual(len(modif), 1)
        self.assertIn('8:30', modif.description)
        self.assertIn('8:00', modif.description)
        ligne.write({'nb_heures': 8.0})
        self.assertEqual(len(self._journal('heures_modifiees')), 1, "Rien n'a changé : pas de ligne")

        ligne.action_soumettre()
        self.assertEqual(len(self._journal('heures_soumises')), 1)

    def test_heures_encodees_puis_supprimees(self):
        ligne = self.Heure.create({'chantier_id': self.chantier.id, 'nb_heures': 7.5, 'description': 'Coffrage'})
        encodees = self._journal('heures_encodees')
        self.assertEqual(encodees.ouvrier_id, self.ouvrier)
        self.assertIn('7:30', encodees.description)
        ligne.with_user(self.chef).unlink()
        supprimee = self.env['chantier.journal'].search([('action', '=', 'heures_supprimees')])
        self.assertEqual(supprimee.user_id, self.chef)
        self.assertEqual(supprimee.ouvrier_id, self.ouvrier)
        self.assertIn('7:30', supprimee.description, "La trace survit à la ligne supprimée")

    def test_demande_outil_et_retour(self):
        demande = self.env['chantier.demande.materiel'].with_user(self.ouvrier).create({
            'chantier_id': self.chantier.id, 'type_demande': 'outil', 'outil_id': self.outil.id})
        demande.action_soumettre()
        self.assertIn('Disqueuse', self._journal('demande_creee').description)
        self.assertEqual(len(self._journal('demande_envoyee')), 1)

        demande.with_user(self.chef).action_valider()
        sortie = self.env['chantier.journal'].search([('action', '=', 'outil_pris')])
        self.assertEqual(sortie.user_id, self.chef, "C'est le chef qui a confié l'outil")
        self.assertEqual(sortie.ouvrier_id, self.ouvrier)
        self.outil.with_user(self.ouvrier).action_scan_rendre()
        self.assertIn('à temps', self._journal('outil_rendu').description)

    def test_photo_tache_et_point_de_controle(self):
        self.env['chantier.photo'].with_user(self.ouvrier).create({'name': 'Coffrage fini', 'tache_id': self.tache.id})
        photo = self._journal('photo_ajoutee')
        self.assertEqual(photo.chantier_id, self.chantier)
        self.assertIn('Coffrage', photo.description)

        point = self.env['chantier.tache.checklist'].create({'tache_id': self.tache.id, 'name': 'Étais posés'})
        point.with_user(self.chef).fait = True
        self.tache.with_user(self.chef).action_demarrer()
        Journal = self.env['chantier.journal']
        self.assertIn('Coché : Étais posés', Journal.search([('action', '=', 'point_controle')]).description)
        self.assertEqual(Journal.search([('action', '=', 'tache_etat')]).description, 'À faire → En cours')

    def test_connexion(self):
        self.ouvrier.password = 'journal_ouvrier'
        # Vraie connexion par le formulaire, pas le raccourci authenticate() des tests.
        self.make_jsonrpc_request('/web/session/authenticate', {
            'db': self.env.cr.dbname, 'login': 'journal_ouvrier', 'password': 'journal_ouvrier'})
        connexion = self._journal('connexion')
        self.assertEqual(len(connexion), 1)
        self.assertTrue(connexion.adresse_ip)

    def test_journal_inalterable_et_reserve_a_l_admin(self):
        ligne = self.Heure.create({'chantier_id': self.chantier.id, 'nb_heures': 4})
        trace = self._journal('heures_encodees')
        self.assertEqual(trace.with_user(self.admin).read(['description'])[0]['description'], trace.description)
        with self.assertRaises(UserError):
            trace.with_user(self.admin).write({'description': 'Effacé'})
        with self.assertRaises(UserError):
            trace.with_user(self.admin).unlink()
        with self.assertRaises(AccessError):
            self.env['chantier.journal'].with_user(self.ouvrier).search([]).read(['description'])
        self.assertEqual(trace.with_user(self.admin).action_ouvrir()['res_id'], ligne.id)
