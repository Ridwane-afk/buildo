from odoo.tests.common import TransactionCase


class ChantierTestCommon(TransactionCase):
    """Base commune : un client et un chantier prêts à l'emploi."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.client = cls.env['res.partner'].create({
            'name': 'Client Test BUILDO',
            'customer_rank': 1,
        })
        cls.chantier = cls.env['chantier.chantier'].create({
            'name': 'Chantier Test',
            'client_id': cls.client.id,
            'budget_initial': 10000.0,
        })

    @classmethod
    def _create_buildo_user(cls, login, group_xmlid):
        """Crée un utilisateur de test membre d'un seul groupe BUILDO."""
        group = cls.env.ref(group_xmlid)
        return cls.env['res.users'].with_context(no_reset_password=True, mail_create_nosubscribe=True).create({
            'name': login,
            'login': login,
            'email': '%s@example.com' % login,
            'group_ids': [(6, 0, [group.id])],
        })
