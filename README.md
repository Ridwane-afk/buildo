# BUILDO — Gestion intégrée des chantiers

Module Odoo 19 développé dans le cadre d'un travail de fin d'études en informatique de gestion. Il centralise la gestion opérationnelle et financière des chantiers du bâtiment pour une entreprise de construction belge.

## Ce que fait le module

BUILDO couvre l'ensemble du cycle de vie d'un chantier, depuis la création jusqu'à la clôture financière.

Les chefs de chantier encodent les heures prestées par leurs ouvriers, gèrent les demandes de matériel, rédigent des rapports journaliers et suivent l'avancement des tâches. Chaque validation ou refus est tracé dans un fil de discussion interne avec motif obligatoire.

Le service administratif pilote les devis, factures et commandes fournisseur directement depuis les modules natifs Odoo (Ventes, Comptabilité, Achats), liés au chantier par une simple relation. Les stocks de matériaux sont synchronisés avec le module Stock d'Odoo pour éviter toute double saisie.

La direction dispose d'un tableau de bord avec vue graphique et pivot pour analyser la rentabilité par chantier, surveiller les marges et suivre les paiements au Fonds de Sécurité d'Existence.

Un assistant IA intégré (GPT-4o d'OpenAI) permet d'analyser les problèmes de chantier en langage naturel, avec la possibilité de joindre une photo. Il adapte automatiquement sa réponse au contexte réel du chantier et propose des solutions concrètes selon les normes belges du bâtiment.

## Prérequis

Odoo 19 avec les modules suivants activés : Ventes, Comptabilité, Achats, Stock, Employés, Messagerie.

## Installation

Copier le dossier `buildo_gestion_chantier` dans le répertoire `custom-addons` d'Odoo, ajouter son chemin dans `odoo.conf` si nécessaire, puis installer le module depuis le menu Applications.

## Configuration post-installation

Pour activer l'assistant IA, aller dans Paramètres > Paramètres techniques > Paramètres système et créer une entrée avec la clé `buildo.openai.api_key` contenant la clé API OpenAI.

## API REST

Le module expose une API REST pour les chantiers, utilisable par un script externe, une application mobile ou un système tiers.

### Authentification

L'API utilise le système de clés API natif d'Odoo — aucune configuration supplémentaire n'est nécessaire côté module. Chaque utilisateur génère sa propre clé depuis **Paramètres > Mon profil > Sécurité du compte > Nouvelle clé API**, puis l'envoie dans l'en-tête `Authorization` de chaque requête :

```
Authorization: Bearer <clé_api>
```

(l'en-tête `X-API-Key: <clé_api>` fonctionne aussi, en alternative).

Les appels s'exécutent avec les droits réels du propriétaire de la clé : un chef de chantier n'accède via l'API qu'à ses propres chantiers, exactement comme dans l'interface web (mêmes groupes et mêmes règles de sécurité que le reste du module).

### Ressource `chantiers`

| Méthode | URL | Description |
|---|---|---|
| `GET` | `/api/v1/chantiers` | Liste des chantiers. Paramètres optionnels : `state` (filtre), `limit` (défaut 80, max 200), `offset`. |
| `GET` | `/api/v1/chantiers/<id>` | Détail d'un chantier. |
| `POST` | `/api/v1/chantiers` | Création. Corps JSON avec au minimum `name` et `client_id`. |
| `PUT` | `/api/v1/chantiers/<id>` | Modification partielle. |
| `DELETE` | `/api/v1/chantiers/<id>` | Suppression. |

Champs acceptés en écriture (`POST`/`PUT`) : `name`, `client_id`, `chef_chantier_id`, `adresse`, `date_debut`, `date_fin_prevue`, `budget_initial`, `description`. L'état du chantier (`state`) n'est volontairement pas modifiable par l'API : il passe uniquement par les actions métier de l'interface (Démarrer / Terminer / Annuler), pour ne pas contourner le suivi associé à ces transitions.

### Exemple

```bash
# Lister les chantiers en cours
curl -H "Authorization: Bearer <clé_api>" \
     "https://votre-instance.odoo.com/api/v1/chantiers?state=en_cours"

# Créer un chantier
curl -X POST -H "Authorization: Bearer <clé_api>" -H "Content-Type: application/json" \
     -d '{"name": "Rénovation toiture", "client_id": 42, "budget_initial": 15000}' \
     "https://votre-instance.odoo.com/api/v1/chantiers"
```

### Codes de réponse

`200` / `201` succès · `400` requête invalide (champ obligatoire manquant, valeur incorrecte) · `401` clé API absente ou invalide · `403` droits insuffisants sur ce chantier · `404` chantier introuvable.

## Structure du module

Le module est organisé en plusieurs dossiers. Le dossier `models` contient tous les modèles de données (chantier, tâches, heures prestées, matériaux, outils, rapports, etc.). Le dossier `views` regroupe les vues XML (formulaires, listes, kanban et dashboard). Le dossier `security` définit les groupes d'utilisateurs, les droits par modèle et les règles d'enregistrement. Le dossier `data` contient les séquences automatiques pour les références chantier et avenant. Le dossier `report` contient le rapport PDF de suivi de chantier. Le dossier `controllers` contient l'API REST décrite ci-dessus.

## Auteur

Ridwane Afkir — Travail de fin d'études, 2026
