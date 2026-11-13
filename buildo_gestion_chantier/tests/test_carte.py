from unittest.mock import patch

from odoo.exceptions import UserError
from odoo.tests import tagged

from .common import ChantierTestCommon

GEO_FIND = 'odoo.addons.base_geolocalize.models.base_geocoder.BaseGeocoder.geo_find'


@tagged('post_install', '-at_install')
class TestCarteChantiers(ChantierTestCommon):
    """Position des chantiers sur la carte, calculée à partir de l'adresse."""

    def test_adresse_localisee_a_la_creation(self):
        # Adresse complète puis commune de contrôle (à 1 km : la rue est gardée).
        with patch(GEO_FIND, side_effect=[(50.8466, 4.3528), (50.8503, 4.3517)]) as geo_find:
            chantier = self.env['chantier.chantier'].create({
                'name': 'Rénovation Grand-Place', 'client_id': self.client.id,
                'adresse': 'Grand-Place 1, 1000 Bruxelles',
            })
        self.assertEqual([c.args[0] for c in geo_find.call_args_list],
                         ['Grand-Place 1, 1000 Bruxelles, Belgique', '1000 Bruxelles, Belgique'])
        self.assertAlmostEqual(chantier.latitude, 50.8466)
        self.assertAlmostEqual(chantier.longitude, 4.3528)

    def test_rue_homonyme_dans_une_autre_commune(self):
        # « Avenue des Arts, 3000 Louvain » trouvée à Louvain-la-Neuve (25 km) : on garde Leuven.
        with patch(GEO_FIND, side_effect=[(50.6644, 4.6123), (50.8798, 4.7005)]):
            self.chantier.adresse = 'Avenue des Arts 84, 3000 Louvain'
        self.assertAlmostEqual(self.chantier.latitude, 50.8798)
        self.assertAlmostEqual(self.chantier.longitude, 4.7005)

    def test_repli_sur_code_postal_et_commune(self):
        # Rue inconnue : la position de la commune suffit pour la carte.
        with patch(GEO_FIND, side_effect=[None, (50.4542, 3.9567)]) as geo_find:
            self.chantier.adresse = 'Rue Imaginaire 999, 7000 Mons'
        self.assertEqual(geo_find.call_args.args[0], '7000 Mons, Belgique')
        self.assertAlmostEqual(self.chantier.latitude, 50.4542)

    def test_nouvelle_adresse_efface_l_ancienne_position(self):
        self.chantier.write({'latitude': 50.0, 'longitude': 4.0})
        with patch(GEO_FIND, return_value=None):
            self.chantier.adresse = 'Adresse introuvable'
        self.assertFalse(self.chantier.latitude)
        self.assertFalse(self.chantier.longitude)

    def test_service_indisponible_ne_bloque_pas_l_enregistrement(self):
        with patch(GEO_FIND, side_effect=UserError("Service indisponible")):
            self.chantier.adresse = 'Rue de la Loi 16, 1000 Bruxelles'
        self.assertEqual(self.chantier.adresse, 'Rue de la Loi 16, 1000 Bruxelles')
        self.assertFalse(self.chantier.latitude)

    def test_bouton_localiser(self):
        self.chantier.write({'adresse': 'Nulle part'})  # service bloqué en test : pas de position
        with patch(GEO_FIND, return_value=None), self.assertRaises(UserError):
            self.chantier.action_localiser()
        with patch(GEO_FIND, return_value=(50.6326, 5.5797)):
            self.chantier.action_localiser()
        self.assertAlmostEqual(self.chantier.latitude, 50.6326)
