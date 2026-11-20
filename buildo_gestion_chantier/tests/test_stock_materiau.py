from odoo.tests import tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestStockMateriau(ChantierTestCommon):
    """Le stock d'un matériau lié à un produit suit l'Inventaire en direct."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.produit = cls.env['product.product'].create({'name': 'Ciment 25 kg', 'is_storable': True})
        cls.materiau = cls.env['chantier.materiau'].create({
            'name': 'Ciment', 'product_id': cls.produit.id, 'seuil_alerte': 5, 'unite': 'sac',
        })
        cls.estimation = cls.env['chantier.estimation.materiau'].create({
            'chantier_id': cls.chantier.id, 'materiau_id': cls.materiau.id, 'quantite_estimee': 30,
        })
        cls.entrepot = cls.env['stock.warehouse'].search([('company_id', '=', cls.env.company.id)], limit=1)

    def _inventaire(self, quantite):
        self.env['stock.quant'].with_context(inventory_mode=True).create({
            'product_id': self.produit.id,
            'location_id': self.entrepot.lot_stock_id.id,
            'inventory_quantity': quantite,
        }).action_apply_inventory()
        self.env.invalidate_all()

    def test_stock_suit_l_inventaire(self):
        self.assertEqual(self.materiau.stock_disponible, 0)
        self.assertTrue(self.materiau.en_alerte)
        self.assertEqual(self.estimation.quantite_manquante, 30)
        self._inventaire(20)
        self.assertEqual(self.materiau.stock_disponible, 20)
        self.assertFalse(self.materiau.en_alerte)
        self.assertEqual(self.estimation.quantite_manquante, 10, "30 prévus - 20 en stock")

    def test_filtres_sur_le_stock_reel(self):
        Materiau = self.env['chantier.materiau']
        Estimation = self.env['chantier.estimation.materiau']
        self.assertIn(self.materiau, Materiau.search([('stock_disponible', '<=', 0)]))
        self.assertIn(self.materiau, Materiau.search([('en_alerte', '=', True)]))
        self.assertIn(self.estimation, Estimation.search([('quantite_manquante', '>', 0)]))
        self._inventaire(40)
        self.assertNotIn(self.materiau, Materiau.search([('stock_disponible', '<=', 0)]))
        self.assertNotIn(self.materiau, Materiau.search([('en_alerte', '=', True)]))
        self.assertIn(self.estimation, Estimation.search([('quantite_manquante', '=', 0)]))

    def test_stock_saisi_a_la_main_sans_produit(self):
        materiau = self.env['chantier.materiau'].create({'name': 'Sable local', 'stock_disponible': 12})
        self.assertEqual(materiau.stock_manuel, 12)
        materiau.stock_disponible = 3
        self.assertEqual(materiau.stock_disponible, 3)
        # Un produit lié prend le dessus sur la saisie manuelle.
        materiau.product_id = self.produit
        self.assertEqual(materiau.stock_disponible, 0)
