from odoo.exceptions import UserError, ValidationError
from odoo.tests import tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestChantierTache(ChantierTestCommon):

    def setUp(self):
        super().setUp()
        self.tache = self.env['chantier.tache'].create({
            'name': 'Tâche test',
            'chantier_id': self.chantier.id,
        })

    def test_avancement_constraint(self):
        with self.assertRaises(ValidationError):
            self.tache.write({'avancement': 150})
        with self.assertRaises(ValidationError):
            self.tache.write({'avancement': -10})

    def test_action_valider_sets_state_and_avancement(self):
        self.tache.action_valider()
        self.assertEqual(self.tache.state, 'fait')
        self.assertEqual(self.tache.avancement, 100)
        self.assertTrue(self.tache.date_fin_reelle)

    def test_action_remettre_a_faire_resets(self):
        self.tache.action_valider()
        self.tache.action_remettre_a_faire()
        self.assertEqual(self.tache.state, 'a_faire')
        self.assertEqual(self.tache.avancement, 0)
        self.assertFalse(self.tache.date_fin_reelle)

    def test_checklist_sync_avancement(self):
        item1 = self.env['chantier.tache.checklist'].create({
            'tache_id': self.tache.id, 'name': 'Étape 1',
        })
        item2 = self.env['chantier.tache.checklist'].create({
            'tache_id': self.tache.id, 'name': 'Étape 2',
        })
        self.assertEqual(self.tache.avancement, 0)

        item1.write({'fait': True})
        self.assertEqual(self.tache.avancement, 50)
        self.assertEqual(item1.fait_par_id, self.env.user)
        self.assertTrue(item1.fait_le)

        item2.write({'fait': True})
        self.assertEqual(self.tache.avancement, 100)

        item1.write({'fait': False})
        self.assertEqual(self.tache.avancement, 50)
        self.assertFalse(item1.fait_par_id)
        self.assertFalse(item1.fait_le)

    def test_checklist_created_already_checked(self):
        # La création directe avec fait=True doit aussi déclencher le suivi
        # (create() ne peut pas simplement déléguer à write()).
        item = self.env['chantier.tache.checklist'].create({
            'tache_id': self.tache.id, 'name': 'Déjà fait', 'fait': True,
        })
        self.assertEqual(item.fait_par_id, self.env.user)
        self.assertTrue(item.fait_le)
        self.assertEqual(self.tache.avancement, 100)

    def test_action_facturer_requires_done_state(self):
        self.tache.montant_facturable = 500.0
        with self.assertRaises(UserError):
            self.tache.action_facturer()

    def test_action_facturer_requires_montant(self):
        self.tache.action_valider()
        with self.assertRaises(UserError):
            self.tache.action_facturer()

    def test_action_facturer_creates_invoice(self):
        self.tache.montant_facturable = 500.0
        self.tache.action_valider()
        self.tache.action_facturer()
        self.assertTrue(self.tache.facture_id)
        self.assertEqual(self.tache.facture_id.move_type, 'out_invoice')
        self.assertEqual(self.tache.facture_id.partner_id, self.client)
        self.assertEqual(self.tache.facture_id.invoice_line_ids.price_unit, 500.0)

    def test_action_facturer_blocks_double_invoicing(self):
        self.tache.montant_facturable = 500.0
        self.tache.action_valider()
        self.tache.action_facturer()
        with self.assertRaises(UserError):
            self.tache.action_facturer()
