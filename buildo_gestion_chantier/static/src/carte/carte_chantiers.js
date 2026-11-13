/** @odoo-module **/

import { Component, onMounted, onWillStart, onWillUnmount, useRef } from "@odoo/owl";
import { loadCSS, loadJS } from "@web/core/assets";
import { _t } from "@web/core/l10n/translation";
import { registry } from "@web/core/registry";
import { useService } from "@web/core/utils/hooks";

const LIB = "/buildo_gestion_chantier/static/lib/leaflet/";

// Couleur du repère selon l'état du chantier (orange = couleur BUILDO).
export const COULEURS = {
    brouillon: "#6b7280",
    en_cours: "#C2410C",
    termine: "#15803d",
};

/** Carte Leaflet / OpenStreetMap des chantiers localisés (menu Chantiers / Carte). */
export class CarteChantiers extends Component {
    static template = "buildo_gestion_chantier.CarteChantiers";
    static props = ["*"];

    setup() {
        this.orm = useService("orm");
        this.action = useService("action");
        this.carteRef = useRef("carte");
        this.legende = [
            { etat: "brouillon", libelle: _t("Brouillon"), couleur: COULEURS.brouillon },
            { etat: "en_cours", libelle: _t("En cours"), couleur: COULEURS.en_cours },
            { etat: "termine", libelle: _t("Terminé"), couleur: COULEURS.termine },
        ];
        onWillStart(async () => {
            await Promise.all([loadJS(LIB + "leaflet.js"), loadCSS(LIB + "leaflet.css")]);
            // Les règles d'accès s'appliquent : un ouvrier ne voit que ses chantiers.
            const domaine = [["state", "!=", "annule"]];
            this.chantiers = await this.orm.searchRead(
                "chantier.chantier",
                [...domaine, ["latitude", "!=", 0]],
                ["name", "ref", "client_id", "adresse", "state", "avancement", "latitude", "longitude"]
            );
            this.nbSansPosition = await this.orm.searchCount("chantier.chantier", [
                ...domaine,
                ["latitude", "=", 0],
            ]);
        });
        onMounted(() => this.afficherCarte());
        onWillUnmount(() => this.carte?.remove());
    }

    afficherCarte() {
        const L = window.L;
        this.carte = L.map(this.carteRef.el).setView([50.6, 4.5], 8); // Belgique
        L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
            maxZoom: 19,
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        }).addTo(this.carte);
        const reperes = this.chantiers.map((chantier) =>
            L.circleMarker([chantier.latitude, chantier.longitude], {
                radius: 9,
                weight: 2,
                color: "#ffffff",
                fillColor: COULEURS[chantier.state] || COULEURS.brouillon,
                fillOpacity: 0.9,
            })
                .bindTooltip(chantier.name)
                .bindPopup(() => this.contenuPopup(chantier))
                .addTo(this.carte)
        );
        if (reperes.length) {
            this.carte.fitBounds(L.featureGroup(reperes).getBounds(), { padding: [30, 30], maxZoom: 14 });
        }
    }

    /** Construit la bulle en DOM (textContent) : aucun HTML venant des données n'est interprété. */
    contenuPopup(chantier) {
        const bloc = document.createElement("div");
        bloc.className = "o_buildo_carte_popup";
        const ligne = (texte, classe) => {
            const el = document.createElement("div");
            el.className = classe;
            el.textContent = texte;
            bloc.appendChild(el);
        };
        ligne(`${chantier.ref || ""} ${chantier.name}`.trim(), "fw-bold");
        if (chantier.client_id) {
            ligne(chantier.client_id[1], "text-muted");
        }
        if (chantier.adresse) {
            ligne(chantier.adresse, "small");
        }
        ligne(_t("Avancement : %s %", Math.round(chantier.avancement || 0)), "small mt-1");
        const bouton = document.createElement("button");
        bouton.className = "btn btn-primary btn-sm mt-2";
        bouton.textContent = _t("Ouvrir le chantier");
        bouton.addEventListener("click", () =>
            this.action.doAction({
                type: "ir.actions.act_window",
                res_model: "chantier.chantier",
                res_id: chantier.id,
                views: [[false, "form"]],
            })
        );
        bloc.appendChild(bouton);
        return bloc;
    }
}

registry.category("actions").add("buildo_carte_chantiers", CarteChantiers);
