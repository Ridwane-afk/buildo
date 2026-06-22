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

## Structure du module

Le module est organisé en quatre dossiers principaux. Le dossier `models` contient tous les modèles de données (chantier, tâches, heures prestées, matériaux, outils, rapports, etc.). Le dossier `views` regroupe les vues XML (formulaires, listes, kanban et dashboard). Le dossier `security` définit les groupes d'utilisateurs, les droits par modèle et les règles d'enregistrement. Le dossier `data` contient les séquences automatiques pour les références chantier et avenant.

## Auteur

Ridwane Afkir — Travail de fin d'études, 2026
