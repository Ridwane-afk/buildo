from odoo.exceptions import ValidationError
from odoo.tests import tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestHeurePrestee(ChantierTestCommon):

    def setUp(self):
        super().setUp()
        self.ouvrier = self.env.ref('base.user_admin')

    def test_constraints(self):
        with self.assertRaises(ValidationError):
            self.env['chantier.heure.prestee'].create({
                'chantier_id': self.chantier.id,
                'ouvrier_id': self.ouvrier.id,
                'nb_heures': 0,
                'taux_horaire': 20.0,
            })
        with self.assertRaises(ValidationError):
            self.env['chantier.heure.prestee'].create({
                'chantier_id': self.chantier.id,
                'ouvrier_id': self.ouvrier.id,
                'nb_heures': 5,
                'taux_horaire': 0,
            })

    def test_compute_montant(self):
        heure = self.env['chantier.heure.prestee'].create({
            'chantier_id': self.chantier.id,
            'ouvrier_id': self.ouvrier.id,
            'nb_heures': 7.5,
            'taux_horaire': 18.0,
        })
        self.assertEqual(heure.montant, 135.0)

    def test_workflow_soumettre_valider(self):
        heure = self.env['chantier.heure.prestee'].create({
            'chantier_id': self.chantier.id,
            'ouvrier_id': self.ouvrier.id,
            'nb_heures': 8,
            'taux_horaire': 20.0,
        })
        heure.action_soumettre()
        self.assertEqual(heure.state, 'soumis')
        heure.action_valider()
        self.assertEqual(heure.state, 'valide')
        self.assertEqual(heure.validateur_id, self.env.user)

    def test_workflow_refus_via_wizard(self):
        heure = self.env['chantier.heure.prestee'].create({
            'chantier_id': self.chantier.id,
            'ouvrier_id': self.ouvrier.id,
            'nb_heures': 8,
            'taux_horaire': 20.0,
        })
        wizard = self.env['chantier.wizard.refus'].with_context(
            active_model='chantier.heure.prestee', active_ids=heure.ids,
        ).create({'motif': 'Heures non justifiées par un rapport'})
        wizard.action_confirmer()
        self.assertEqual(heure.state, 'refuse')
        self.assertEqual(heure.note_refus, 'Heures non justifiées par un rapport')

    def test_wizard_refus_motif_too_short(self):
        with self.assertRaises(ValidationError):
            self.env['chantier.wizard.refus'].create({'motif': 'trop bref'})


@tagged('post_install', '-at_install')
class TestDemandeMateriel(ChantierTestCommon):

    def test_check_quantite(self):
        with self.assertRaises(ValidationError):
            self.env['chantier.demande.materiel'].create({
                'chantier_id': self.chantier.id,
                'ouvrier_id': self.env.ref('base.user_admin').id,
                'description': 'Sable',
                'quantite': 0,
            })

    def test_workflow_refus_via_wizard(self):
        demande = self.env['chantier.demande.materiel'].create({
            'chantier_id': self.chantier.id,
            'ouvrier_id': self.env.ref('base.user_admin').id,
            'description': 'Sable',
            'quantite': 5,
        })
        wizard = self.env['chantier.wizard.refus'].with_context(
            active_model='chantier.demande.materiel', active_ids=demande.ids,
        ).create({'motif': 'Stock suffisant sur place actuellement'})
        wizard.action_confirmer()
        self.assertEqual(demande.state, 'refuse')
        self.assertEqual(demande.note, 'Stock suffisant sur place actuellement')


@tagged('post_install', '-at_install')
class TestEstimationChantierDerivedFromTache(ChantierTestCommon):
    """La création d'une estimation depuis une tâche doit dériver chantier_id
    automatiquement (bug corrigé : le contexte de vue seul n'est pas fiable)."""

    def setUp(self):
        super().setUp()
        self.tache = self.env['chantier.tache'].create({
            'name': 'Tâche test', 'chantier_id': self.chantier.id,
        })
        self.materiau = self.env['chantier.materiau'].create({'name': 'Ciment'})
        self.outil = self.env['chantier.outil'].create({'name': 'Bétonnière'})

    def test_estimation_materiau_chantier_derived(self):
        estimation = self.env['chantier.estimation.materiau'].create({
            'tache_id': self.tache.id,
            'materiau_id': self.materiau.id,
            'quantite_estimee': 10,
        })
        self.assertEqual(estimation.chantier_id, self.chantier)

    def test_estimation_outil_chantier_derived(self):
        estimation = self.env['chantier.estimation.outil'].create({
            'tache_id': self.tache.id,
            'outil_id': self.outil.id,
        })
        self.assertEqual(estimation.chantier_id, self.chantier)
