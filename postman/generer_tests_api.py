"""
Génère la suite Postman « BUILDO — Tests API complets » (collection v2.1).

Chaque scénario est exécuté avec les 5 rôles BUILDO (administrateur, direction,
service administratif, chef de chantier, ouvrier) et vérifie le code HTTP ainsi
que le contenu attendu pour ce rôle. S'y ajoutent les cas d'erreur (400, 401,
404, 409) et un nettoyage qui supprime tout ce qui a été créé.

    python3 generer_tests_api.py
    npx newman run BUILDO_tests_API_complets.postman_collection.json -e env_tests_api.local.json
"""
import json
import uuid

ROLES = ['admin', 'direction', 'service', 'chef', 'ouvrier']
NOMS = {'admin': 'Administrateur BUILDO', 'direction': 'Direction', 'service': 'Service administratif',
        'chef': 'Chef de chantier', 'ouvrier': 'Ouvrier'}
VOIT_TOUT = {'admin', 'direction', 'service'}


def url(path):
    raw = '{{base_url}}' + path
    chemin, _, query = path.partition('?')
    u = {'raw': raw, 'host': ['{{base_url}}'], 'path': [p for p in chemin.split('/') if p]}
    if query:
        u['query'] = [dict(zip(('key', 'value'), kv.split('=', 1))) for kv in query.split('&')]
    return u


def requete(nom, methode, path, tests, role='admin', corps=None, brut=None, auth=None):
    req = {'method': methode, 'header': [], 'url': url(path)}
    req['auth'] = auth or {'type': 'bearer', 'bearer': [{'key': 'token', 'value': '{{key_%s}}' % role, 'type': 'string'}]}
    if corps is not None or brut is not None:
        req['header'] = [{'key': 'Content-Type', 'value': 'application/json'}]
        texte = brut if brut is not None else json.dumps(corps, ensure_ascii=False, indent=2)
        for var in ('chef_id', 'ouvrier_id', 'client_id', 'fixture_chantier'):  # variables numériques
            texte = texte.replace('"{{%s}}"' % var, '{{%s}}' % var)
        req['body'] = {'mode': 'raw', 'raw': texte, 'options': {'raw': {'language': 'json'}}}
    return {'id': str(uuid.uuid4()), 'name': nom, 'request': req, 'response': [],
            'event': [{'listen': 'test', 'script': {'id': str(uuid.uuid4()), 'type': 'text/javascript',
                                                    'exec': tests}}]}


def statut(code):
    return "pm.test('Code HTTP %d', () => pm.response.to.have.status(%d));" % (code, code)


def dossier(nom, items):
    return {'id': str(uuid.uuid4()), 'name': nom, 'item': items}


J = "const b = pm.response.json();"
V = "const v = (k) => Number(pm.collectionVariables.get(k) || pm.environment.get(k));"

# ─── Préparation : un chantier et une tâche de test, avec le chef et l'ouvrier de test ───
preparation = dossier('0. Préparation (admin)', [
    requete('Créer le chantier de test', 'POST', '/api/v1/chantiers', [
        statut(201), J,
        "pm.test('Référence générée', () => pm.expect(b.ref).to.match(/^CHT\\//));",
        "pm.collectionVariables.set('fixture_chantier', b.id);",
    ], corps={'name': 'Chantier tests API automatiques', 'client_id': '{{client_id}}',
              'chef_chantier_id': '{{chef_id}}', 'budget_initial': 50000}),
    requete('Créer la tâche de test (ouvrier assigné)', 'POST', '/api/v1/taches', [
        statut(201), J,
        "pm.test('Ouvrier assigné', () => pm.expect(b.ouvriers.map(o => o.id)).to.include(Number(pm.environment.get('ouvrier_id'))));",
        "pm.collectionVariables.set('fixture_tache', b.id);",
    ], corps={'name': 'Tâche tests API', 'chantier_id': '{{fixture_chantier}}', 'ouvrier_ids': ['{{ouvrier_id}}']}),
    requete("Repérer une tâche d'un autre chantier", 'GET', '/api/v1/taches?chantier_id={{autre_chantier_id}}&limit=1', [
        statut(200), J,
        "pm.test('Au moins une tâche', () => pm.expect(b.results.length).to.equal(1));",
        "pm.collectionVariables.set('autre_tache', b.results[0].id);",
    ]),
])
# Les variables numériques du corps de la tâche
preparation['item'][1]['request']['body']['raw'] = preparation['item'][1]['request']['body']['raw'] \
    .replace('"{{ouvrier_id}}"', '{{ouvrier_id}}')


def scenarios(role):
    voit_tout = role in VOIT_TOUT
    ecrit = role != 'ouvrier'
    items = []

    tests = [statut(200), J, V,
             "const ids = b.results.map(c => c.id);",
             "pm.test('Le chantier de test est listé', () => pm.expect(ids).to.include(v('fixture_chantier')));"]
    if voit_tout:
        tests.append("pm.test('Voit les chantiers des autres', () => pm.expect(ids).to.include(v('autre_chantier_id')));")
    else:
        tests.append("pm.test('Ne voit pas les chantiers des autres', () => pm.expect(ids).to.not.include(v('autre_chantier_id')));")
    if role == 'ouvrier':
        tests.append("pm.test('Aucun champ financier', () => b.results.forEach(c => pm.expect(c).to.not.have.any.keys('marge', 'budget_initial', 'cout_reel')));")
    else:
        tests.append("pm.test('Champs financiers présents', () => pm.expect(b.results[0]).to.have.property('marge'));")
    items.append(requete('GET liste des chantiers', 'GET', '/api/v1/chantiers?limit=200', tests, role))

    tests = [statut(200), J, V, "pm.test('Bon chantier', () => pm.expect(b.id).to.equal(v('fixture_chantier')));"]
    tests.append("pm.test('Budget %s', () => pm.expect(b).%s.have.property('budget_initial'));"
                 % (('masqué', 'to.not') if role == 'ouvrier' else ('visible', 'to')))
    items.append(requete('GET détail du chantier de test', 'GET', '/api/v1/chantiers/{{fixture_chantier}}', tests, role))

    items.append(requete("GET détail d'un chantier d'un autre chef", 'GET', '/api/v1/chantiers/{{autre_chantier_id}}',
                         [statut(200 if voit_tout else 403)], role))

    if ecrit:
        tests = [statut(201), J,
                 "pm.test('Actif par défaut', () => pm.expect(b.active).to.be.true);",
                 "pm.collectionVariables.set('cree_chantier_%s', b.id);" % role]
    else:
        tests = [statut(403), "pm.test('Message d\\'erreur', () => pm.expect(pm.response.json().error).to.be.a('string'));"]
    items.append(requete('POST créer un chantier', 'POST', '/api/v1/chantiers', tests, role,
                         corps={'name': 'Chantier API (%s)' % NOMS[role], 'client_id': '{{client_id}}',
                                'chef_chantier_id': '{{chef_id}}'}))

    tests = [statut(200 if ecrit else 403)]
    if ecrit:
        tests += [J, "pm.test('Description mise à jour', () => pm.expect(b.description).to.equal('Modifié par %s'));" % NOMS[role]]
    items.append(requete('PUT modifier le chantier de test', 'PUT', '/api/v1/chantiers/{{fixture_chantier}}', tests, role,
                         corps={'description': 'Modifié par %s' % NOMS[role]}))

    cible = 'cree_chantier_%s' % (role if ecrit else 'chef')
    if role == 'admin':
        tests = [statut(200), "pm.test('deleted = true', () => pm.expect(pm.response.json().deleted).to.be.true);"]
    else:
        tests = [statut(403)]
    items.append(requete('DELETE supprimer un chantier vide', 'DELETE', '/api/v1/chantiers/{{%s}}' % cible, tests, role))

    if role == 'admin':
        tests = [statut(409), J,
                 "pm.test('Explique les heures prestées', () => pm.expect(b.error).to.include('heure(s) prestée(s)'));",
                 "pm.test('Propose l\\'archivage', () => pm.expect(b.solution).to.include('\"active\": false'));"]
    else:
        tests = [statut(403)]
    items.append(requete('DELETE chantier avec heures prestées', 'DELETE', '/api/v1/chantiers/{{autre_chantier_id}}', tests, role))

    tests = [statut(200), J, V, "const ids = b.results.map(t => t.id);",
             "pm.test('La tâche de test est listée', () => pm.expect(ids).to.include(v('fixture_tache')));"]
    if role == 'ouvrier':
        tests.append("pm.test('Uniquement ses tâches', () => b.results.forEach(t => pm.expect(t.ouvriers.map(o => o.id)).to.include(v('ouvrier_id'))));")
    items.append(requete('GET tâches du chantier de test', 'GET', '/api/v1/taches?chantier_id={{fixture_chantier}}', tests, role))

    items.append(requete('GET détail de la tâche de test', 'GET', '/api/v1/taches/{{fixture_tache}}',
                         [statut(200), J, V, "pm.test('Bonne tâche', () => pm.expect(b.id).to.equal(v('fixture_tache')));"], role))

    items.append(requete("GET tâche d'un autre chantier", 'GET', '/api/v1/taches/{{autre_tache}}',
                         [statut(200 if voit_tout else 403)], role))

    if ecrit:
        tests = [statut(201), J, "pm.collectionVariables.set('cree_tache_%s', b.id);" % role,
                 "pm.test('État initial à faire', () => pm.expect(b.state).to.equal('a_faire'));"]
    else:
        tests = [statut(403)]
    items.append(requete('POST créer une tâche', 'POST', '/api/v1/taches', tests, role,
                         brut=json.dumps({'name': 'Tâche API (%s)' % NOMS[role], 'chantier_id': 'FIXTURE'},
                                         ensure_ascii=False, indent=2).replace('"FIXTURE"', '{{fixture_chantier}}')))

    avancement = {'admin': 10, 'direction': 20, 'service': 30, 'chef': 40, 'ouvrier': 90}[role]
    tests = [statut(200 if ecrit else 403)]
    if ecrit:
        tests += [J, "pm.test('Avancement %d %%', () => pm.expect(b.avancement).to.equal(%d));" % (avancement, avancement)]
    items.append(requete('PUT avancement de la tâche de test', 'PUT', '/api/v1/taches/{{fixture_tache}}', tests, role,
                         corps={'avancement': avancement}))

    cible = 'cree_tache_%s' % role if ecrit else 'fixture_tache'
    tests = [statut(200 if ecrit else 403)]
    if ecrit:
        tests.append("pm.test('deleted = true', () => pm.expect(pm.response.json().deleted).to.be.true);")
    items.append(requete('DELETE supprimer une tâche', 'DELETE', '/api/v1/taches/{{%s}}' % cible, tests, role))

    return dossier('Rôle : %s' % NOMS[role], items)


SANS_AUTH = {'type': 'noauth'}
MAUVAISE = {'type': 'bearer', 'bearer': [{'key': 'token', 'value': 'cle-invalide', 'type': 'string'}]}
erreurs = dossier('6. Cas d\'erreur et paramètres', [
    requete('Sans clé API → 401', 'GET', '/api/v1/chantiers', [statut(401)], auth=SANS_AUTH),
    requete('Clé invalide → 401', 'GET', '/api/v1/chantiers', [statut(401)], auth=MAUVAISE),
    requete('Tâches sans clé → 401', 'GET', '/api/v1/taches', [statut(401)], auth=SANS_AUTH),
    requete('En-tête X-API-Key accepté', 'GET', '/api/v1/chantiers?limit=1', [statut(200)],
            auth={'type': 'apikey', 'apikey': [{'key': 'key', 'value': 'X-API-Key', 'type': 'string'},
                                               {'key': 'value', 'value': '{{key_admin}}', 'type': 'string'},
                                               {'key': 'in', 'value': 'header', 'type': 'string'}]}),
    requete('Chantier inexistant → 404', 'GET', '/api/v1/chantiers/999999', [statut(404)]),
    requete('Tâche inexistante → 404', 'GET', '/api/v1/taches/999999', [statut(404)]),
    requete('PUT chantier inexistant → 404', 'PUT', '/api/v1/chantiers/999999', [statut(404)], corps={'name': 'x'}),
    requete('DELETE tâche inexistante → 404', 'DELETE', '/api/v1/taches/999999', [statut(404)]),
    requete('POST chantier sans nom ni client → 400', 'POST', '/api/v1/chantiers', [
        statut(400), "pm.test('Champs obligatoires cités', () => pm.expect(pm.response.json().error).to.include('obligatoires'));"],
        corps={'adresse': 'Rue sans chantier'}),
    requete('POST JSON invalide → 400', 'POST', '/api/v1/chantiers', [statut(400)], brut='{"name": "incomplet"'),
    requete('POST tâche sans chantier → 400', 'POST', '/api/v1/taches', [statut(400)], corps={'name': 'Orpheline'}),
    requete('PUT avancement 150 % → 400', 'PUT', '/api/v1/taches/{{fixture_tache}}', [statut(400)], corps={'avancement': 150}),
    requete('PUT état non modifiable → 400', 'PUT', '/api/v1/chantiers/{{fixture_chantier}}', [
        statut(400), "pm.test('Liste des champs autorisés', () => pm.expect(pm.response.json().error).to.include('Champs autorisés'));"],
        corps={'state': 'termine'}),
    requete('Paramètre limit non numérique → 400', 'GET', '/api/v1/chantiers?limit=abc', [statut(400)]),
    requete('Paramètre chantier_id non numérique → 400', 'GET', '/api/v1/taches?chantier_id=abc', [statut(400)]),
    requete('Pagination limit=5', 'GET', '/api/v1/chantiers?limit=5&offset=0', [
        statut(200), J, "pm.test('Au plus 5 résultats', () => pm.expect(b.results.length).to.be.at.most(5));",
        "pm.test('limit renvoyé', () => pm.expect(b.limit).to.equal(5));",
        "pm.test('total cohérent', () => pm.expect(b.total).to.be.at.least(b.results.length));"]),
    requete('Pagination limit plafonné à 200', 'GET', '/api/v1/chantiers?limit=5000', [
        statut(200), "pm.test('limit = 200', () => pm.expect(pm.response.json().limit).to.equal(200));"]),
    requete('Filtre state=en_cours', 'GET', '/api/v1/chantiers?state=en_cours&limit=200', [
        statut(200), J, "pm.test('Tous en cours', () => b.results.forEach(c => pm.expect(c.state).to.equal('en_cours')));"]),
    requete('Archiver le chantier de test (soft delete)', 'PUT', '/api/v1/chantiers/{{fixture_chantier}}', [
        statut(200), "pm.test('active = false', () => pm.expect(pm.response.json().active).to.be.false);"],
        corps={'active': False}),
    requete('Le chantier archivé n\'est plus listé', 'GET', '/api/v1/chantiers?limit=200', [
        statut(200), V, "pm.test('Absent de la liste', () => pm.expect(pm.response.json().results.map(c => c.id)).to.not.include(v('fixture_chantier')));"]),
    requete('Désarchiver le chantier de test', 'PUT', '/api/v1/chantiers/{{fixture_chantier}}', [
        statut(200), "pm.test('active = true', () => pm.expect(pm.response.json().active).to.be.true);"],
        corps={'active': True}),
])

nettoyage = dossier('7. Nettoyage (admin)', [
    requete('Supprimer le chantier créé par %s' % NOMS[r], 'DELETE', '/api/v1/chantiers/{{cree_chantier_%s}}' % r, [statut(200)])
    for r in ('direction', 'service', 'chef')
] + [
    requete('Supprimer la tâche de test', 'DELETE', '/api/v1/taches/{{fixture_tache}}', [statut(200)]),
    requete('Supprimer le chantier de test', 'DELETE', '/api/v1/chantiers/{{fixture_chantier}}', [statut(200)]),
    requete('Le chantier de test n\'existe plus → 404', 'GET', '/api/v1/chantiers/{{fixture_chantier}}', [statut(404)]),
])

collection = {
    'info': {'_postman_id': str(uuid.uuid4()), 'name': 'BUILDO — Tests API complets',
             'description': "Suite de tests de l'API REST BUILDO : chaque scénario est joué avec les 5 rôles, "
                            "plus les cas d'erreur. Lancer avec l'environnement env_tests_api.local.json.",
             'schema': 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json'},
    'item': [preparation] + [scenarios(r) for r in ROLES] + [erreurs, nettoyage],
}
json.dump(collection, open('BUILDO_tests_API_complets.postman_collection.json', 'w'), ensure_ascii=False, indent=2)
nb_req = sum(len(d['item']) for d in collection['item'])
nb_tests = sum(l.count('pm.test(') for d in collection['item'] for i in d['item'] for e in i['event'] for l in e['script']['exec'])
print('%d requêtes, %d tests' % (nb_req, nb_tests))
