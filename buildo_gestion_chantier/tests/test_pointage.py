from datetime import datetime

from freezegun import freeze_time

from odoo.exceptions import UserError
from odoo.service.model import call_kw
from odoo.tests import tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestPointage(ChantierTestCommon):
    """Saisie des heures en un geste : pointage arrivée / départ et copie de la dernière journée."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.ouvrier = cls._create_buildo_user('pointage_ouvrier', 'buildo_gestion_chantier.group_ouvrier')
        cls.chantier.state = 'en_cours'
        cls.env['chantier.tache'].create({'name': 'Maçonnerie', 'chantier_id': cls.chantier.id,
                                          'ouvrier_ids': [(6, 0, cls.ouvrier.ids)]})
        cls.Heure = cls.env['chantier.heure.prestee'].with_user(cls.ouvrier)

    def _mes_heures(self):
        return self.Heure.search([('ouvrier_id', '=', self.ouvrier.id)])

    def test_arrivee_puis_depart_calcule_les_heures(self):
        with freeze_time(datetime(2026, 11, 12, 7, 2)):
            self.Heure.action_pointer_arrivee()
        ligne = self._mes_heures()
        self.assertEqual(ligne.chantier_id, self.chantier, "Chantier unique choisi automatiquement")
        self.assertTrue(ligne.pointage_en_cours)
        with self.assertRaises(UserError):
            ligne.action_soumettre()
        with freeze_time(datetime(2026, 11, 12, 15, 35)):
            self.Heure.action_pointer_depart()
        self.assertFalse(ligne.pointage_en_cours)
        self.assertEqual(ligne.nb_heures, 8.5, "8 h 33 arrondi au quart d'heure")
        ligne.action_soumettre()
        self.assertEqual(ligne.state, 'soumis')

    def test_double_arrivee_et_depart_sans_arrivee_refuses(self):
        with self.assertRaises(UserError):
            self.Heure.action_pointer_depart()
        self.Heure.action_pointer_arrivee()
        with self.assertRaises(UserError):
            self.Heure.action_pointer_arrivee()

    def test_plusieurs_chantiers_ouvre_le_choix(self):
        autre = self.env['chantier.chantier'].create({'name': 'Autre', 'client_id': self.client.id, 'state': 'en_cours'})
        self.env['chantier.tache'].create({'name': 'Toiture', 'chantier_id': autre.id,
                                           'ouvrier_ids': [(6, 0, self.ouvrier.ids)]})
        action = self.Heure.action_pointer_arrivee()
        self.assertEqual(action['res_model'], 'chantier.wizard.pointage')
        assistant = self.env['chantier.wizard.pointage'].with_user(self.ouvrier).create({'chantier_id': autre.id})
        assistant.action_confirmer()
        self.assertEqual(self._mes_heures().chantier_id, autre)

    def test_copier_derniere_journee(self):
        with freeze_time('2026-11-06'):  # vendredi
            self.Heure.create([{'chantier_id': self.chantier.id, 'nb_heures': 6, 'description': 'Coffrage'},
                               {'chantier_id': self.chantier.id, 'nb_heures': 2, 'description': 'Rangement'}])
        with freeze_time('2026-11-09'):  # lundi : copie la journée de vendredi
            self.Heure.action_copier_derniere_journee()
            du_jour = self._mes_heures().filtered(lambda h: str(h.date) == '2026-11-09')
            self.assertEqual(sorted(du_jour.mapped('nb_heures')), [2, 6])
            self.assertEqual(set(du_jour.mapped('state')), {'brouillon'})
            with self.assertRaises(UserError):
                self.Heure.action_copier_derniere_journee()

    def test_boutons_appeles_comme_depuis_la_liste(self):
        """Le client web appelle les boutons d'en-tête avec la liste des lignes cochées (vide)."""
        Heure = self.Heure.with_context()
        call_kw(Heure, 'action_pointer_arrivee', [[]], {})
        call_kw(Heure, 'action_pointer_depart', [[]], {})
        self.assertFalse(self._mes_heures().pointage_en_cours)
