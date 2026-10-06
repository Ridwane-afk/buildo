from datetime import datetime, timedelta

from odoo.tests import HttpCase, tagged

from .common import ChantierTestCommon


@tagged('post_install', '-at_install')
class TestTacheApi(HttpCase, ChantierTestCommon):

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        g = 'buildo_gestion_chantier.group_%s'
        cls.chef = cls._create_buildo_user('tache_api_chef', g % 'chef_chantier')
        cls.ouvrier = cls._create_buildo_user('tache_api_ouvrier', g % 'ouvrier')
        cls.own_chantier = cls.env['chantier.chantier'].create({
            'name': 'Chantier API tâches', 'client_id': cls.client.id, 'chef_chantier_id': cls.chef.id,
        })
        cls.tache_assignee = cls.env['chantier.tache'].create({
            'name': 'Tâche assignée', 'chantier_id': cls.own_chantier.id, 'ouvrier_ids': [(6, 0, cls.ouvrier.ids)],
        })
        # cls.chantier (ChantierTestCommon) n'a pas de chef : hors du périmètre du chef
        cls.tache_autre = cls.env['chantier.tache'].create({'name': 'Tâche ailleurs', 'chantier_id': cls.chantier.id})
        expiration = datetime.now() + timedelta(hours=1)
        Keys = cls.env['res.users.apikeys']
        cls.chef_key = Keys.with_user(cls.chef)._generate(scope='buildo_rest', name='chef', expiration_date=expiration)
        cls.ouvrier_key = Keys.with_user(cls.ouvrier)._generate(scope='buildo_rest', name='ouvrier',
                                                               expiration_date=expiration)

    def _headers(self, key):
        return {'Authorization': 'Bearer %s' % key}

    def test_full_crud_cycle(self):
        headers = self._headers(self.chef_key)
        create = self.url_open('/api/v1/taches', headers=headers, json={
            'name': 'Coulage dalle', 'chantier_id': self.own_chantier.id, 'ouvrier_ids': [self.ouvrier.id],
        })
        self.assertEqual(create.status_code, 201)
        tache_id = create.json()['id']
        self.assertEqual(create.json()['state'], 'a_faire')
        self.assertEqual([o['id'] for o in create.json()['ouvriers']], [self.ouvrier.id])

        listing = self.url_open('/api/v1/taches?chantier_id=%d' % self.own_chantier.id, headers=headers)
        self.assertEqual(listing.status_code, 200)
        self.assertIn(tache_id, [t['id'] for t in listing.json()['results']])

        update = self.url_open('/api/v1/taches/%d' % tache_id, headers=headers, method='PUT',
                               json={'avancement': 50, 'description': 'Moitié coulée'})
        self.assertEqual(update.status_code, 200)
        self.assertEqual(update.json()['avancement'], 50)

        delete = self.url_open('/api/v1/taches/%d' % tache_id, headers=headers, method='DELETE')
        self.assertEqual(delete.status_code, 200)
        self.assertTrue(delete.json()['deleted'])
        self.assertEqual(self.url_open('/api/v1/taches/%d' % tache_id, headers=headers).status_code, 404)

    def test_chef_scoped_to_own_chantiers(self):
        headers = self._headers(self.chef_key)
        ids = [t['id'] for t in self.url_open('/api/v1/taches', headers=headers).json()['results']]
        self.assertIn(self.tache_assignee.id, ids)
        self.assertNotIn(self.tache_autre.id, ids)
        self.assertEqual(self.url_open('/api/v1/taches/%d' % self.tache_autre.id, headers=headers).status_code, 403)

    def test_ouvrier_reads_assigned_only(self):
        headers = self._headers(self.ouvrier_key)
        ids = [t['id'] for t in self.url_open('/api/v1/taches', headers=headers).json()['results']]
        self.assertEqual(ids, [self.tache_assignee.id])
        # Lecture seule pour l'ouvrier
        res = self.url_open('/api/v1/taches/%d' % self.tache_assignee.id, headers=headers, method='PUT',
                            json={'avancement': 80})
        self.assertEqual(res.status_code, 403)
        res = self.url_open('/api/v1/taches', headers=headers, json={'name': 'X', 'chantier_id': self.own_chantier.id})
        self.assertEqual(res.status_code, 403)

    def test_validation_errors(self):
        headers = self._headers(self.chef_key)
        self.assertEqual(self.url_open('/api/v1/taches', headers=headers, json={'name': 'Sans chantier'}).status_code, 400)
        res = self.url_open('/api/v1/taches/%d' % self.tache_assignee.id, headers=headers, method='PUT',
                            json={'avancement': 150})
        self.assertEqual(res.status_code, 400)
        self.assertEqual(self.url_open('/api/v1/taches/999999', headers=headers).status_code, 404)
        self.assertEqual(self.url_open('/api/v1/taches').status_code, 401)

    def test_ouvrier_chantiers_api(self):
        """Un ouvrier lit ses chantiers via l'API, sans les champs financiers."""
        headers = self._headers(self.ouvrier_key)
        res = self.url_open('/api/v1/chantiers', headers=headers)
        self.assertEqual(res.status_code, 200)
        results = res.json()['results']
        self.assertEqual([c['id'] for c in results], [self.own_chantier.id])
        self.assertNotIn('marge', results[0])
        self.assertNotIn('budget_initial', results[0])
        detail = self.url_open('/api/v1/chantiers/%d' % self.own_chantier.id, headers=headers)
        self.assertEqual(detail.status_code, 200)
        create = self.url_open('/api/v1/chantiers', headers=headers,
                               json={'name': 'Interdit', 'client_id': self.client.id})
        self.assertEqual(create.status_code, 403)
        # Le chef, lui, reçoit les champs financiers
        chef = self.url_open('/api/v1/chantiers/%d' % self.own_chantier.id, headers=self._headers(self.chef_key))
        self.assertIn('marge', chef.json())
