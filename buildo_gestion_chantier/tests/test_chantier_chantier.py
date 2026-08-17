from odoo.exceptions import ValidationError
from odoo.tests import tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestChantierChantier(ChantierTestCommon):

    def test_ref_sequence_generated(self):
        self.assertTrue(self.chantier.ref)
        self.assertNotEqual(self.chantier.ref, 'Nouveau')
        self.assertIn('CHT/', self.chantier.ref)

    def test_ref_not_overridden_if_provided(self):
        chantier = self.env['chantier.chantier'].create({
            'name': 'Chantier avec ref manuelle',
            'client_id': self.client.id,
            'ref': 'REF-MANUELLE',
        })
        self.assertEqual(chantier.ref, 'REF-MANUELLE')

    def test_check_dates_constraint(self):
        with self.assertRaises(ValidationError):
            self.chantier.write({
                'date_debut': '2026-06-01',
                'date_fin_prevue': '2026-05-01',
            })

    def test_check_budget_constraint(self):
        with self.assertRaises(ValidationError):
            self.chantier.write({'budget_initial': -100.0})

    def test_compute_financier_main_oeuvre(self):
        ouvrier = self.env.ref('base.user_admin')
        heure = self.env['chantier.heure.prestee'].create({
            'chantier_id': self.chantier.id,
            'ouvrier_id': ouvrier.id,
            'nb_heures': 8.0,
            'taux_horaire': 20.0,
        })
        # Une heure non validée n'entre pas encore dans le coût réel.
        self.assertEqual(self.chantier.cout_main_oeuvre, 0.0)

        heure.action_valider()
        self.assertEqual(self.chantier.cout_main_oeuvre, 160.0)
        self.assertEqual(self.chantier.cout_reel, 160.0)
        self.assertEqual(self.chantier.marge, -160.0)
        self.assertEqual(self.chantier.nb_heures, 8.0)

    def test_avenant_integration_budget_revise(self):
        sale_order = self.env['sale.order'].create({
            'partner_id': self.client.id,
            'chantier_id': self.chantier.id,
        })
        avenant = self.env['chantier.avenant'].create({
            'sale_order_id': sale_order.id,
            'motif': 'Travaux supplémentaires demandés par le client',
            'montant_ht': 2000.0,
        })
        # Un avenant en brouillon n'impacte pas encore le budget révisé.
        self.assertEqual(self.chantier.budget_revise, self.chantier.budget_initial)

        avenant.action_accepter()
        self.assertEqual(self.chantier.montant_avenants_acceptes, 2000.0)
        self.assertEqual(self.chantier.budget_revise, self.chantier.budget_initial + 2000.0)

        avenant.action_refuser()
        self.assertEqual(self.chantier.montant_avenants_acceptes, 0.0)
        self.assertEqual(self.chantier.budget_revise, self.chantier.budget_initial)

    def test_avancement_compute(self):
        self.assertEqual(self.chantier.avancement, 0.0)
        tache1 = self.env['chantier.tache'].create({
            'name': 'Tâche 1', 'chantier_id': self.chantier.id,
        })
        tache2 = self.env['chantier.tache'].create({
            'name': 'Tâche 2', 'chantier_id': self.chantier.id,
        })
        self.assertEqual(self.chantier.avancement, 0.0)
        tache1.action_valider()
        self.assertEqual(self.chantier.avancement, 50.0)
        tache2.action_valider()
        self.assertEqual(self.chantier.avancement, 100.0)
