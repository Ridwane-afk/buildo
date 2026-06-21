{
    'name': 'BUILDO — Gestion intégrée des chantiers',
    'version': '19.0.1.0.0',
    'category': 'Construction',
    'summary': 'Module de gestion intégrée des chantiers du bâtiment',
    'description': """
BUILDO — Gestion intégrée des chantiers du bâtiment
=====================================================
Centralise la gestion des chantiers, des coûts, des heures prestées,
des matériaux, de la facturation et de la rentabilité.
    """,
    'author': 'Ridwane Afkir — ICC Bruxelles 2025-2026',
    'license': 'LGPL-3',
    'depends': ['base', 'mail', 'hr', 'stock', 'sale', 'account', 'purchase'],
    'data': [
        'security/res_groups.xml',
        'security/ir.model.access.csv',
        'data/sequences.xml',
        'views/chantier_chantier_views.xml',
        'views/chantier_tache_views.xml',
        'views/chantier_heure_prestee_views.xml',
        'views/chantier_demande_materiel_views.xml',
        'views/chantier_rapport_journalier_views.xml',
        'views/chantier_materiau_views.xml',
        'views/chantier_outil_views.xml',
        'views/chantier_estimation_views.xml',
        'views/chantier_devis_views.xml',
        'views/chantier_facture_views.xml',
        'views/chantier_commande_fournisseur_views.xml',
        'views/chantier_paiement_fss_views.xml',
        'views/chantier_avenant_views.xml',
        'views/chantier_photo_plan_views.xml',
        'views/chantier_dashboard_views.xml',
        'views/menu_views.xml',
    ],
    'installable': True,
    'application': True,
    'images': ['static/description/icon.png'],
}
