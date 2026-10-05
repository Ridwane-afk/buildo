from datetime import datetime, timedelta

from psycopg2 import IntegrityError

from odoo.exceptions import AccessError, UserError
from odoo.tests import HttpCase, tagged
from odoo.tools import mute_logger

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestSuppressionChantier(ChantierTestCommon):
    """Suppression physique (hard delete) refusée dès qu'un chantier porte des
    transactions à conserver ; archivage (soft delete) à la place."""

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        g = 'buildo_gestion_chantier.group_%s'
        cls.admin_buildo = cls._create_buildo_user('suppr_admin_buildo', g % 'admin_buildo')
        cls.chef = cls._create_buildo_user('suppr_chef', g % 'chef_chantier')
        cls.ouvrier = cls._create_buildo_user('suppr_ouvrier', g % 'ouvrier')
        cls.chantier.chef_chantier_id = cls.chef
        cls.heure = cls.env['chantier.heure.prestee'].create({
            'chantier_id': cls.chantier.id, 'ouvrier_id': cls.ouvrier.id,
            'nb_heures': 8, 'taux_horaire': 20, 'state': 'valide',
        })

    def _chantier_vide(self):
        return self.env['chantier.chantier'].create({'name': 'Chantier vide', 'client_id': self.client.id})

    def test_fk_ondelete_restrict(self):
        for model in ('chantier.heure.prestee', 'chantier.paiement.fss'):
            with self.subTest(model=model):
                self.assertEqual(self.env[model]._fields['chantier_id'].ondelete, 'restrict')

    def test_transactions_bloquantes(self):
        self.env['chantier.paiement.fss'].create({
            'chantier_id': self.chantier.id, 'ouvrier_id': self.ouvrier.id, 'periode': 'Q1 2026', 'montant': 120,
        })
        self.assertEqual(self.chantier._get_transactions_bloquantes(),
                         ['1 heure(s) prestée(s)', '1 paiement(s) FSS'])
        self.assertEqual(self._chantier_vide()._get_transactions_bloquantes(), [])

    def test_suppression_refusee_avec_heures(self):
        with self.assertRaises(UserError) as ctx:
            self.chantier.with_user(self.admin_buildo).unlink()
        self.assertIn('1 heure(s) prestée(s)', str(ctx.exception))
        self.assertIn('Archivez', str(ctx.exception))
        self.assertTrue(self.chantier.exists())
        self.assertTrue(self.heure.exists())

    def test_sans_droit_access_error_avant_message_metier(self):
        # Le chef n'a pas perm_unlink : il doit recevoir une AccessError même
        # si le chantier a des transactions.
        with self.assertRaises(AccessError):
            self.chantier.with_user(self.chef).unlink()

    def test_restrict_en_base(self):
        # Même en contournant le contrôle Python, la base refuse la suppression.
        with mute_logger('odoo.sql_db'), self.assertRaises(IntegrityError), self.env.cr.savepoint():
            self.env.cr.execute("DELETE FROM chantier_chantier WHERE id = %s", (self.chantier.id,))

    def test_archivage_conserve_heures(self):
        self.chantier.with_user(self.admin_buildo).write({'active': False})
        Chantier = self.env['chantier.chantier']
        self.assertNotIn(self.chantier, Chantier.search([]))
        self.assertIn(self.chantier, Chantier.search([('active', '=', False)]))
        self.assertTrue(self.heure.exists())
        self.assertEqual(self.heure.chantier_id, self.chantier)
        self.assertEqual(self.chantier.nb_heures, 8)
        self.chantier.write({'active': True})
        self.assertIn(self.chantier, Chantier.search([]))

    def test_suppression_chantier_vide_autorisee(self):
        chantier = self._chantier_vide()
        chantier.with_user(self.admin_buildo).unlink()
        self.assertFalse(chantier.exists())


@tagged('post_install', '-at_install')
class TestSuppressionChantierApi(HttpCase, ChantierTestCommon):

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.admin_buildo = cls._create_buildo_user(
            'suppr_api_admin', 'buildo_gestion_chantier.group_admin_buildo',
        )
        # Odoo 19 : la clé API d'un utilisateur non administrateur doit expirer
        cls.key = cls.env['res.users.apikeys'].with_user(cls.admin_buildo)._generate(
            scope='buildo_rest', name='clé de test suppression',
            expiration_date=datetime.now() + timedelta(hours=1),
        )
        ouvrier = cls._create_buildo_user('suppr_api_ouvrier', 'buildo_gestion_chantier.group_ouvrier')
        cls.heure = cls.env['chantier.heure.prestee'].create({
            'chantier_id': cls.chantier.id, 'ouvrier_id': ouvrier.id, 'nb_heures': 6, 'taux_horaire': 20,
        })

    def _headers(self):
        return {'Authorization': 'Bearer %s' % self.key}

    def test_delete_avec_transactions_409(self):
        res = self.url_open('/api/v1/chantiers/%d' % self.chantier.id, headers=self._headers(), method='DELETE')
        self.assertEqual(res.status_code, 409)
        body = res.json()
        self.assertIn('1 heure(s) prestée(s)', body['error'])
        self.assertEqual(body['solution'],
                         'PUT /api/v1/chantiers/%d avec {"active": false} pour archiver.' % self.chantier.id)
        self.assertTrue(self.chantier.exists())

    def test_put_active_false_archive(self):
        res = self.url_open('/api/v1/chantiers/%d' % self.chantier.id, headers=self._headers(),
                            method='PUT', json={'active': False})
        self.assertEqual(res.status_code, 200)
        self.assertIs(res.json()['active'], False)
        self.assertFalse(self.chantier.active)
        self.assertTrue(self.heure.exists())
        listing = self.url_open('/api/v1/chantiers', headers=self._headers()).json()
        self.assertNotIn(self.chantier.id, [c['id'] for c in listing['results']])
