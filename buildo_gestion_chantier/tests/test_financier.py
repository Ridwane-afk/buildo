from odoo import fields
from odoo.tests import tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestMontantFacture(ChantierTestCommon):
    """Montant encaissé du chantier : part réglée des factures, avoirs déduits."""

    def _piece(self, move_type, montant, valider=True):
        move = self.env['account.move'].create({
            'move_type': move_type,
            'partner_id': self.client.id,
            'chantier_id': self.chantier.id,
            'invoice_date': fields.Date.today(),
            'invoice_line_ids': [(0, 0, {'name': 'Travaux', 'quantity': 1, 'price_unit': montant,
                                         'tax_ids': [(6, 0, [])]})],
        })
        if valider:
            move.action_post()
        return move

    def _payer(self, move, montant):
        self.env['account.payment.register'].with_context(
            active_model='account.move', active_ids=move.ids,
        ).create({'amount': montant})._create_payments()

    def test_facture_partiellement_payee(self):
        facture = self._piece('out_invoice', 1000)
        self.assertEqual(self.chantier.montant_facture, 0)
        self._payer(facture, 400)
        self.assertEqual(facture.payment_state, 'partial')
        self.assertEqual(self.chantier.montant_facture, 400)
        self._payer(facture, 600)
        self.assertEqual(self.chantier.montant_facture, 1000)

    def test_avoir_deduit(self):
        self._payer(self._piece('out_invoice', 1500), 1500)
        avoir = self._piece('out_refund', 200)
        # Avoir validé mais pas encore remboursé : rien n'a été rendu au client
        self.assertEqual(self.chantier.montant_facture, 1500)
        self._payer(avoir, 200)
        self.assertEqual(self.chantier.montant_facture, 1300)
        self.assertEqual(self.chantier.marge, 1300 - self.chantier.cout_reel)

    def test_brouillon_et_annule_ignores(self):
        self._piece('out_invoice', 300, valider=False)
        annulee = self._piece('out_invoice', 700)
        annulee.button_draft()
        annulee.button_cancel()
        self.assertEqual(self.chantier.montant_facture, 0)

    def test_avoir_cree_depuis_facture_garde_le_chantier(self):
        facture = self._piece('out_invoice', 800)
        avoir = facture._reverse_moves()
        self.assertEqual(avoir.chantier_id, self.chantier)
        self.assertIn(avoir, self.chantier.avoir_ids)
