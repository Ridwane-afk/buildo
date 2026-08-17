from datetime import datetime, timedelta

from odoo.tests import HttpCase, tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestChantierApi(HttpCase, ChantierTestCommon):

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.chef = cls._create_buildo_user('api_chef_test', 'buildo_gestion_chantier.group_chef_chantier')
        cls.admin_buildo = cls.env.ref('base.user_admin')

        cls.own_chantier = cls.env['chantier.chantier'].create({
            'name': 'Chantier API chef', 'client_id': cls.client.id, 'chef_chantier_id': cls.chef.id,
        })
        # cls.chantier (créé par ChantierTestCommon) n'a pas de chef -> hors du
        # périmètre de cls.chef, utile pour vérifier le cloisonnement.
        cls.other_chantier = cls.chantier

        cls.chef_key = cls.env['res.users.apikeys'].with_user(cls.chef)._generate(
            scope='buildo_rest', name='clé de test chef', expiration_date=datetime.now() + timedelta(hours=1),
        )
        cls.admin_key = cls.env['res.users.apikeys'].with_user(cls.admin_buildo)._generate(
            scope='buildo_rest', name='clé de test admin', expiration_date=None,
        )

    def _headers(self, key):
        return {'Authorization': 'Bearer %s' % key}

    def test_missing_key_returns_401(self):
        res = self.url_open('/api/v1/chantiers')
        self.assertEqual(res.status_code, 401)

    def test_invalid_key_returns_401(self):
        res = self.url_open('/api/v1/chantiers', headers=self._headers('cle-invalide'))
        self.assertEqual(res.status_code, 401)

    def test_list_scoped_to_chef_chantiers(self):
        res = self.url_open('/api/v1/chantiers', headers=self._headers(self.chef_key))
        self.assertEqual(res.status_code, 200)
        ids = [c['id'] for c in res.json()['results']]
        self.assertIn(self.own_chantier.id, ids)
        self.assertNotIn(self.other_chantier.id, ids)

    def test_get_other_chantier_returns_403(self):
        res = self.url_open(
            '/api/v1/chantiers/%d' % self.other_chantier.id, headers=self._headers(self.chef_key),
        )
        self.assertEqual(res.status_code, 403)

    def test_get_unknown_chantier_returns_404(self):
        res = self.url_open('/api/v1/chantiers/999999', headers=self._headers(self.chef_key))
        self.assertEqual(res.status_code, 404)

    def test_create_requires_name_and_client(self):
        res = self.url_open(
            '/api/v1/chantiers', headers=self._headers(self.chef_key), json={'name': 'Sans client'},
        )
        self.assertEqual(res.status_code, 400)

    def test_state_not_directly_writable(self):
        # 'state' est volontairement absent de WRITABLE_FIELDS : un PUT qui ne
        # contient que ce champ ne doit rien modifier.
        res = self.url_open(
            '/api/v1/chantiers/%d' % self.own_chantier.id, headers=self._headers(self.chef_key),
            method='PUT', json={'state': 'en_cours'},
        )
        self.assertEqual(res.status_code, 400)
        self.assertEqual(self.own_chantier.state, 'brouillon')

    def test_full_crud_cycle(self):
        headers = self._headers(self.chef_key)

        create_res = self.url_open('/api/v1/chantiers', headers=headers, json={
            'name': 'Chantier créé via API',
            'client_id': self.client.id,
            'chef_chantier_id': self.chef.id,
            'budget_initial': 5000,
        })
        self.assertEqual(create_res.status_code, 201)
        chantier_id = create_res.json()['id']

        get_res = self.url_open('/api/v1/chantiers/%d' % chantier_id, headers=headers)
        self.assertEqual(get_res.status_code, 200)
        self.assertEqual(get_res.json()['budget_initial'], 5000)

        update_res = self.url_open(
            '/api/v1/chantiers/%d' % chantier_id, headers=headers, method='PUT',
            json={'budget_initial': 7000},
        )
        self.assertEqual(update_res.status_code, 200)
        self.assertEqual(update_res.json()['budget_initial'], 7000)

        # La suppression exige le groupe Administrateur BUILDO (le chef n'a
        # pas perm_unlink sur chantier.chantier, cf. ir.model.access.csv).
        delete_denied_res = self.url_open(
            '/api/v1/chantiers/%d' % chantier_id, headers=headers, method='DELETE',
        )
        self.assertEqual(delete_denied_res.status_code, 403)

        delete_res = self.url_open(
            '/api/v1/chantiers/%d' % chantier_id, headers=self._headers(self.admin_key), method='DELETE',
        )
        self.assertEqual(delete_res.status_code, 200)

        get_after_delete = self.url_open(
            '/api/v1/chantiers/%d' % chantier_id, headers=self._headers(self.admin_key),
        )
        self.assertEqual(get_after_delete.status_code, 404)
