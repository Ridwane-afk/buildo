--
-- PostgreSQL database dump
--

\restrict 7vrRrdqyJEO4JTe0ZKzE2jIRgOJFYKx47Mz3f37WyemFfC1bchE4kenbncBS8ap

-- Dumped from database version 15.18 (Homebrew)
-- Dumped by pg_dump version 15.18 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: chantier_attribution_outil; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_attribution_outil (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    outil_id integer NOT NULL,
    ouvrier_id integer NOT NULL,
    create_uid integer,
    write_uid integer,
    state character varying,
    date_sortie date NOT NULL,
    date_retour_prevue date,
    date_retour_reelle date,
    note text,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_attribution_outil; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_attribution_outil IS 'Attribution d''un outil à un ouvrier';


--
-- Name: COLUMN chantier_attribution_outil.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_attribution_outil.outil_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.outil_id IS 'Outil';


--
-- Name: COLUMN chantier_attribution_outil.ouvrier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.ouvrier_id IS 'Ouvrier';


--
-- Name: COLUMN chantier_attribution_outil.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_attribution_outil.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_attribution_outil.state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.state IS 'État';


--
-- Name: COLUMN chantier_attribution_outil.date_sortie; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.date_sortie IS 'Date de sortie';


--
-- Name: COLUMN chantier_attribution_outil.date_retour_prevue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.date_retour_prevue IS 'Date de retour prévue';


--
-- Name: COLUMN chantier_attribution_outil.date_retour_reelle; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.date_retour_reelle IS 'Date de retour réelle';


--
-- Name: COLUMN chantier_attribution_outil.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.note IS 'Note';


--
-- Name: COLUMN chantier_attribution_outil.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.create_date IS 'Created on';


--
-- Name: COLUMN chantier_attribution_outil.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_attribution_outil.write_date IS 'Last Updated on';


--
-- Name: chantier_attribution_outil_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_attribution_outil_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_attribution_outil_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_attribution_outil_id_seq OWNED BY public.chantier_attribution_outil.id;


--
-- Name: chantier_avenant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_avenant (
    id integer NOT NULL,
    devis_id integer NOT NULL,
    currency_id integer,
    create_uid integer,
    write_uid integer,
    name character varying NOT NULL,
    state character varying,
    date date NOT NULL,
    motif text NOT NULL,
    note text,
    montant_ht numeric,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_avenant; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_avenant IS 'Avenant à un devis';


--
-- Name: COLUMN chantier_avenant.devis_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.devis_id IS 'Devis initial';


--
-- Name: COLUMN chantier_avenant.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.currency_id IS 'Currency';


--
-- Name: COLUMN chantier_avenant.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_avenant.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_avenant.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.name IS 'Référence avenant';


--
-- Name: COLUMN chantier_avenant.state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.state IS 'État';


--
-- Name: COLUMN chantier_avenant.date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.date IS 'Date';


--
-- Name: COLUMN chantier_avenant.motif; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.motif IS 'Motif de la modification';


--
-- Name: COLUMN chantier_avenant.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.note IS 'Note';


--
-- Name: COLUMN chantier_avenant.montant_ht; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.montant_ht IS 'Montant HT de l''avenant';


--
-- Name: COLUMN chantier_avenant.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.create_date IS 'Created on';


--
-- Name: COLUMN chantier_avenant.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_avenant.write_date IS 'Last Updated on';


--
-- Name: chantier_avenant_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_avenant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_avenant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_avenant_id_seq OWNED BY public.chantier_avenant.id;


--
-- Name: chantier_chantier; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_chantier (
    id integer NOT NULL,
    client_id integer NOT NULL,
    chef_chantier_id integer,
    currency_id integer,
    create_uid integer,
    write_uid integer,
    name character varying NOT NULL,
    ref character varying,
    adresse character varying,
    state character varying,
    date_debut date,
    date_fin_prevue date,
    date_fin_reelle date,
    description text,
    budget_initial numeric,
    cout_reel numeric,
    montant_facture numeric,
    marge numeric,
    create_date timestamp without time zone,
    write_date timestamp without time zone,
    nb_heures double precision,
    avancement double precision
);


--
-- Name: TABLE chantier_chantier; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_chantier IS 'Chantier de construction';


--
-- Name: COLUMN chantier_chantier.client_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.client_id IS 'Client';


--
-- Name: COLUMN chantier_chantier.chef_chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.chef_chantier_id IS 'Chef de chantier';


--
-- Name: COLUMN chantier_chantier.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.currency_id IS 'Currency';


--
-- Name: COLUMN chantier_chantier.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_chantier.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_chantier.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.name IS 'Nom du chantier';


--
-- Name: COLUMN chantier_chantier.ref; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.ref IS 'Référence';


--
-- Name: COLUMN chantier_chantier.adresse; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.adresse IS 'Adresse du chantier';


--
-- Name: COLUMN chantier_chantier.state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.state IS 'État';


--
-- Name: COLUMN chantier_chantier.date_debut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.date_debut IS 'Date de début';


--
-- Name: COLUMN chantier_chantier.date_fin_prevue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.date_fin_prevue IS 'Date de fin prévue';


--
-- Name: COLUMN chantier_chantier.date_fin_reelle; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.date_fin_reelle IS 'Date de fin réelle';


--
-- Name: COLUMN chantier_chantier.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.description IS 'Description';


--
-- Name: COLUMN chantier_chantier.budget_initial; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.budget_initial IS 'Budget initial';


--
-- Name: COLUMN chantier_chantier.cout_reel; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.cout_reel IS 'Coût réel';


--
-- Name: COLUMN chantier_chantier.montant_facture; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.montant_facture IS 'Montant facturé';


--
-- Name: COLUMN chantier_chantier.marge; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.marge IS 'Marge';


--
-- Name: COLUMN chantier_chantier.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.create_date IS 'Created on';


--
-- Name: COLUMN chantier_chantier.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.write_date IS 'Last Updated on';


--
-- Name: COLUMN chantier_chantier.nb_heures; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.nb_heures IS 'Heures validées';


--
-- Name: COLUMN chantier_chantier.avancement; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_chantier.avancement IS 'Avancement (%)';


--
-- Name: chantier_chantier_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_chantier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_chantier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_chantier_id_seq OWNED BY public.chantier_chantier.id;


--
-- Name: chantier_commande_fournisseur; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_commande_fournisseur (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    fournisseur_id integer,
    currency_id integer,
    create_uid integer,
    write_uid integer,
    name character varying,
    state character varying,
    date date NOT NULL,
    date_livraison_prevue date,
    note text,
    montant_total numeric,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_commande_fournisseur; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_commande_fournisseur IS 'Commande d''achat fournisseur';


--
-- Name: COLUMN chantier_commande_fournisseur.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_commande_fournisseur.fournisseur_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.fournisseur_id IS 'Fournisseur';


--
-- Name: COLUMN chantier_commande_fournisseur.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.currency_id IS 'Currency';


--
-- Name: COLUMN chantier_commande_fournisseur.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_commande_fournisseur.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_commande_fournisseur.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.name IS 'Référence';


--
-- Name: COLUMN chantier_commande_fournisseur.state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.state IS 'État';


--
-- Name: COLUMN chantier_commande_fournisseur.date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.date IS 'Date';


--
-- Name: COLUMN chantier_commande_fournisseur.date_livraison_prevue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.date_livraison_prevue IS 'Date de livraison prévue';


--
-- Name: COLUMN chantier_commande_fournisseur.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.note IS 'Note';


--
-- Name: COLUMN chantier_commande_fournisseur.montant_total; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.montant_total IS 'Montant total';


--
-- Name: COLUMN chantier_commande_fournisseur.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.create_date IS 'Created on';


--
-- Name: COLUMN chantier_commande_fournisseur.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur.write_date IS 'Last Updated on';


--
-- Name: chantier_commande_fournisseur_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_commande_fournisseur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_commande_fournisseur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_commande_fournisseur_id_seq OWNED BY public.chantier_commande_fournisseur.id;


--
-- Name: chantier_commande_fournisseur_ligne; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_commande_fournisseur_ligne (
    id integer NOT NULL,
    commande_id integer NOT NULL,
    sequence integer,
    materiau_id integer,
    create_uid integer,
    write_uid integer,
    description character varying NOT NULL,
    unite character varying,
    prix_unitaire numeric,
    sous_total numeric,
    create_date timestamp without time zone,
    write_date timestamp without time zone,
    quantite double precision
);


--
-- Name: TABLE chantier_commande_fournisseur_ligne; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_commande_fournisseur_ligne IS 'Ligne de commande fournisseur';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.commande_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.commande_id IS 'Commande';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.sequence; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.sequence IS 'Séquence';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.materiau_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.materiau_id IS 'Matériau';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.description IS 'Description';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.unite; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.unite IS 'Unité';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.prix_unitaire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.prix_unitaire IS 'Prix unitaire (€)';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.sous_total; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.sous_total IS 'Sous-total';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.create_date IS 'Created on';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.write_date IS 'Last Updated on';


--
-- Name: COLUMN chantier_commande_fournisseur_ligne.quantite; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_commande_fournisseur_ligne.quantite IS 'Quantité';


--
-- Name: chantier_commande_fournisseur_ligne_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_commande_fournisseur_ligne_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_commande_fournisseur_ligne_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_commande_fournisseur_ligne_id_seq OWNED BY public.chantier_commande_fournisseur_ligne.id;


--
-- Name: chantier_demande_materiel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_demande_materiel (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    ouvrier_id integer NOT NULL,
    materiau_id integer,
    validateur_id integer,
    create_uid integer,
    write_uid integer,
    description character varying NOT NULL,
    urgence character varying,
    state character varying,
    date date NOT NULL,
    note text,
    create_date timestamp without time zone,
    write_date timestamp without time zone,
    quantite double precision
);


--
-- Name: TABLE chantier_demande_materiel; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_demande_materiel IS 'Demande de matériel par un ouvrier';


--
-- Name: COLUMN chantier_demande_materiel.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_demande_materiel.ouvrier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.ouvrier_id IS 'Ouvrier';


--
-- Name: COLUMN chantier_demande_materiel.materiau_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.materiau_id IS 'Matériau (optionnel)';


--
-- Name: COLUMN chantier_demande_materiel.validateur_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.validateur_id IS 'Validé par';


--
-- Name: COLUMN chantier_demande_materiel.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_demande_materiel.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_demande_materiel.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.description IS 'Description du besoin';


--
-- Name: COLUMN chantier_demande_materiel.urgence; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.urgence IS 'Urgence';


--
-- Name: COLUMN chantier_demande_materiel.state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.state IS 'État';


--
-- Name: COLUMN chantier_demande_materiel.date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.date IS 'Date de demande';


--
-- Name: COLUMN chantier_demande_materiel.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.note IS 'Note';


--
-- Name: COLUMN chantier_demande_materiel.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.create_date IS 'Created on';


--
-- Name: COLUMN chantier_demande_materiel.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.write_date IS 'Last Updated on';


--
-- Name: COLUMN chantier_demande_materiel.quantite; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_demande_materiel.quantite IS 'Quantité demandée';


--
-- Name: chantier_demande_materiel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_demande_materiel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_demande_materiel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_demande_materiel_id_seq OWNED BY public.chantier_demande_materiel.id;


--
-- Name: chantier_devis; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_devis (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    currency_id integer,
    create_uid integer,
    write_uid integer,
    name character varying,
    state character varying,
    date date NOT NULL,
    date_validite date,
    note text,
    montant_ht numeric,
    tva numeric,
    montant_ttc numeric,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_devis; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_devis IS 'Devis pour un chantier';


--
-- Name: COLUMN chantier_devis.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_devis.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.currency_id IS 'Currency';


--
-- Name: COLUMN chantier_devis.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_devis.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_devis.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.name IS 'Référence';


--
-- Name: COLUMN chantier_devis.state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.state IS 'État';


--
-- Name: COLUMN chantier_devis.date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.date IS 'Date du devis';


--
-- Name: COLUMN chantier_devis.date_validite; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.date_validite IS 'Valide jusqu''au';


--
-- Name: COLUMN chantier_devis.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.note IS 'Conditions et remarques';


--
-- Name: COLUMN chantier_devis.montant_ht; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.montant_ht IS 'Montant HT';


--
-- Name: COLUMN chantier_devis.tva; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.tva IS 'TVA (21%)';


--
-- Name: COLUMN chantier_devis.montant_ttc; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.montant_ttc IS 'Montant TTC';


--
-- Name: COLUMN chantier_devis.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.create_date IS 'Created on';


--
-- Name: COLUMN chantier_devis.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis.write_date IS 'Last Updated on';


--
-- Name: chantier_devis_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_devis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_devis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_devis_id_seq OWNED BY public.chantier_devis.id;


--
-- Name: chantier_devis_ligne; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_devis_ligne (
    id integer NOT NULL,
    devis_id integer NOT NULL,
    sequence integer,
    create_uid integer,
    write_uid integer,
    type_ligne character varying NOT NULL,
    name character varying NOT NULL,
    unite character varying,
    prix_unitaire numeric,
    sous_total numeric,
    create_date timestamp without time zone,
    write_date timestamp without time zone,
    quantite double precision
);


--
-- Name: TABLE chantier_devis_ligne; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_devis_ligne IS 'Ligne de devis';


--
-- Name: COLUMN chantier_devis_ligne.devis_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.devis_id IS 'Devis';


--
-- Name: COLUMN chantier_devis_ligne.sequence; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.sequence IS 'Séquence';


--
-- Name: COLUMN chantier_devis_ligne.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_devis_ligne.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_devis_ligne.type_ligne; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.type_ligne IS 'Type';


--
-- Name: COLUMN chantier_devis_ligne.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.name IS 'Description';


--
-- Name: COLUMN chantier_devis_ligne.unite; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.unite IS 'Unité';


--
-- Name: COLUMN chantier_devis_ligne.prix_unitaire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.prix_unitaire IS 'Prix unitaire (€)';


--
-- Name: COLUMN chantier_devis_ligne.sous_total; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.sous_total IS 'Sous-total';


--
-- Name: COLUMN chantier_devis_ligne.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.create_date IS 'Created on';


--
-- Name: COLUMN chantier_devis_ligne.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.write_date IS 'Last Updated on';


--
-- Name: COLUMN chantier_devis_ligne.quantite; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_devis_ligne.quantite IS 'Quantité';


--
-- Name: chantier_devis_ligne_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_devis_ligne_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_devis_ligne_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_devis_ligne_id_seq OWNED BY public.chantier_devis_ligne.id;


--
-- Name: chantier_estimation_materiau; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_estimation_materiau (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    materiau_id integer NOT NULL,
    currency_id integer,
    create_uid integer,
    write_uid integer,
    note text,
    montant_estime numeric,
    create_date timestamp without time zone,
    write_date timestamp without time zone,
    quantite_estimee double precision NOT NULL,
    quantite_manquante double precision
);


--
-- Name: TABLE chantier_estimation_materiau; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_estimation_materiau IS 'Estimation de matériaux pour un chantier';


--
-- Name: COLUMN chantier_estimation_materiau.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_estimation_materiau.materiau_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.materiau_id IS 'Matériau';


--
-- Name: COLUMN chantier_estimation_materiau.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.currency_id IS 'Currency';


--
-- Name: COLUMN chantier_estimation_materiau.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_estimation_materiau.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_estimation_materiau.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.note IS 'Note';


--
-- Name: COLUMN chantier_estimation_materiau.montant_estime; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.montant_estime IS 'Montant estimé';


--
-- Name: COLUMN chantier_estimation_materiau.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.create_date IS 'Created on';


--
-- Name: COLUMN chantier_estimation_materiau.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.write_date IS 'Last Updated on';


--
-- Name: COLUMN chantier_estimation_materiau.quantite_estimee; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.quantite_estimee IS 'Quantité estimée';


--
-- Name: COLUMN chantier_estimation_materiau.quantite_manquante; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_materiau.quantite_manquante IS 'Quantité manquante';


--
-- Name: chantier_estimation_materiau_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_estimation_materiau_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_estimation_materiau_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_estimation_materiau_id_seq OWNED BY public.chantier_estimation_materiau.id;


--
-- Name: chantier_estimation_outil; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_estimation_outil (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    outil_id integer NOT NULL,
    create_uid integer,
    write_uid integer,
    date_debut_prevue date,
    date_fin_prevue date,
    note text,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_estimation_outil; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_estimation_outil IS 'Estimation d''outils pour un chantier';


--
-- Name: COLUMN chantier_estimation_outil.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_outil.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_estimation_outil.outil_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_outil.outil_id IS 'Outil';


--
-- Name: COLUMN chantier_estimation_outil.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_outil.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_estimation_outil.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_outil.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_estimation_outil.date_debut_prevue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_outil.date_debut_prevue IS 'Début d''utilisation prévue';


--
-- Name: COLUMN chantier_estimation_outil.date_fin_prevue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_outil.date_fin_prevue IS 'Fin d''utilisation prévue';


--
-- Name: COLUMN chantier_estimation_outil.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_outil.note IS 'Note';


--
-- Name: COLUMN chantier_estimation_outil.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_outil.create_date IS 'Created on';


--
-- Name: COLUMN chantier_estimation_outil.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_estimation_outil.write_date IS 'Last Updated on';


--
-- Name: chantier_estimation_outil_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_estimation_outil_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_estimation_outil_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_estimation_outil_id_seq OWNED BY public.chantier_estimation_outil.id;


--
-- Name: chantier_facture; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_facture (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    devis_id integer,
    currency_id integer,
    create_uid integer,
    write_uid integer,
    name character varying,
    type_facture character varying NOT NULL,
    state character varying,
    date date NOT NULL,
    date_echeance date,
    note text,
    montant_ht numeric,
    tva numeric,
    montant_total numeric,
    create_date timestamp without time zone,
    write_date timestamp without time zone,
    pourcentage_avancement double precision
);


--
-- Name: TABLE chantier_facture; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_facture IS 'Facture de chantier (proforma + finale)';


--
-- Name: COLUMN chantier_facture.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_facture.devis_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.devis_id IS 'Devis lié';


--
-- Name: COLUMN chantier_facture.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.currency_id IS 'Currency';


--
-- Name: COLUMN chantier_facture.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_facture.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_facture.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.name IS 'Numéro de facture';


--
-- Name: COLUMN chantier_facture.type_facture; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.type_facture IS 'Type';


--
-- Name: COLUMN chantier_facture.state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.state IS 'État';


--
-- Name: COLUMN chantier_facture.date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.date IS 'Date de facturation';


--
-- Name: COLUMN chantier_facture.date_echeance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.date_echeance IS 'Date d''échéance';


--
-- Name: COLUMN chantier_facture.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.note IS 'Note';


--
-- Name: COLUMN chantier_facture.montant_ht; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.montant_ht IS 'Montant HT';


--
-- Name: COLUMN chantier_facture.tva; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.tva IS 'TVA (21%)';


--
-- Name: COLUMN chantier_facture.montant_total; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.montant_total IS 'Montant TTC';


--
-- Name: COLUMN chantier_facture.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.create_date IS 'Created on';


--
-- Name: COLUMN chantier_facture.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.write_date IS 'Last Updated on';


--
-- Name: COLUMN chantier_facture.pourcentage_avancement; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_facture.pourcentage_avancement IS 'Avancement facturé (%)';


--
-- Name: chantier_facture_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_facture_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_facture_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_facture_id_seq OWNED BY public.chantier_facture.id;


--
-- Name: chantier_heure_prestee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_heure_prestee (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    ouvrier_id integer NOT NULL,
    currency_id integer,
    validateur_id integer,
    create_uid integer,
    write_uid integer,
    description character varying,
    state character varying,
    date date NOT NULL,
    note_refus text,
    taux_horaire numeric,
    montant numeric,
    create_date timestamp without time zone,
    write_date timestamp without time zone,
    nb_heures double precision NOT NULL
);


--
-- Name: TABLE chantier_heure_prestee; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_heure_prestee IS 'Heures prestées par un ouvrier sur un chantier';


--
-- Name: COLUMN chantier_heure_prestee.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_heure_prestee.ouvrier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.ouvrier_id IS 'Ouvrier';


--
-- Name: COLUMN chantier_heure_prestee.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.currency_id IS 'Currency';


--
-- Name: COLUMN chantier_heure_prestee.validateur_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.validateur_id IS 'Validé par';


--
-- Name: COLUMN chantier_heure_prestee.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_heure_prestee.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_heure_prestee.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.description IS 'Description du travail';


--
-- Name: COLUMN chantier_heure_prestee.state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.state IS 'État';


--
-- Name: COLUMN chantier_heure_prestee.date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.date IS 'Date';


--
-- Name: COLUMN chantier_heure_prestee.note_refus; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.note_refus IS 'Motif du refus';


--
-- Name: COLUMN chantier_heure_prestee.taux_horaire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.taux_horaire IS 'Taux horaire (€/h)';


--
-- Name: COLUMN chantier_heure_prestee.montant; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.montant IS 'Montant';


--
-- Name: COLUMN chantier_heure_prestee.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.create_date IS 'Created on';


--
-- Name: COLUMN chantier_heure_prestee.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.write_date IS 'Last Updated on';


--
-- Name: COLUMN chantier_heure_prestee.nb_heures; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_heure_prestee.nb_heures IS 'Nombre d''heures';


--
-- Name: chantier_heure_prestee_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_heure_prestee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_heure_prestee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_heure_prestee_id_seq OWNED BY public.chantier_heure_prestee.id;


--
-- Name: chantier_materiau; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_materiau (
    id integer NOT NULL,
    currency_id integer,
    create_uid integer,
    write_uid integer,
    name character varying NOT NULL,
    ref_interne character varying,
    categorie character varying,
    unite character varying,
    description text,
    prix_unitaire numeric,
    actif boolean,
    create_date timestamp without time zone,
    write_date timestamp without time zone,
    stock_disponible double precision,
    seuil_alerte double precision
);


--
-- Name: TABLE chantier_materiau; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_materiau IS 'Catalogue des matériaux';


--
-- Name: COLUMN chantier_materiau.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.currency_id IS 'Currency';


--
-- Name: COLUMN chantier_materiau.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_materiau.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_materiau.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.name IS 'Nom du matériau';


--
-- Name: COLUMN chantier_materiau.ref_interne; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.ref_interne IS 'Référence interne';


--
-- Name: COLUMN chantier_materiau.categorie; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.categorie IS 'Catégorie';


--
-- Name: COLUMN chantier_materiau.unite; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.unite IS 'Unité';


--
-- Name: COLUMN chantier_materiau.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.description IS 'Description';


--
-- Name: COLUMN chantier_materiau.prix_unitaire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.prix_unitaire IS 'Prix unitaire (€)';


--
-- Name: COLUMN chantier_materiau.actif; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.actif IS 'Actif';


--
-- Name: COLUMN chantier_materiau.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.create_date IS 'Created on';


--
-- Name: COLUMN chantier_materiau.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.write_date IS 'Last Updated on';


--
-- Name: COLUMN chantier_materiau.stock_disponible; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.stock_disponible IS 'Stock disponible';


--
-- Name: COLUMN chantier_materiau.seuil_alerte; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_materiau.seuil_alerte IS 'Seuil d''alerte stock';


--
-- Name: chantier_materiau_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_materiau_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_materiau_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_materiau_id_seq OWNED BY public.chantier_materiau.id;


--
-- Name: chantier_outil; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_outil (
    id integer NOT NULL,
    currency_id integer,
    create_uid integer,
    write_uid integer,
    name character varying NOT NULL,
    ref_interne character varying,
    categorie character varying,
    etat character varying,
    date_achat date,
    description text,
    valeur_achat numeric,
    actif boolean,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_outil; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_outil IS 'Catalogue des outils';


--
-- Name: COLUMN chantier_outil.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.currency_id IS 'Currency';


--
-- Name: COLUMN chantier_outil.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_outil.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_outil.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.name IS 'Nom de l''outil';


--
-- Name: COLUMN chantier_outil.ref_interne; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.ref_interne IS 'Référence interne';


--
-- Name: COLUMN chantier_outil.categorie; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.categorie IS 'Catégorie';


--
-- Name: COLUMN chantier_outil.etat; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.etat IS 'État';


--
-- Name: COLUMN chantier_outil.date_achat; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.date_achat IS 'Date d''achat';


--
-- Name: COLUMN chantier_outil.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.description IS 'Description';


--
-- Name: COLUMN chantier_outil.valeur_achat; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.valeur_achat IS 'Valeur d''achat (€)';


--
-- Name: COLUMN chantier_outil.actif; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.actif IS 'Actif';


--
-- Name: COLUMN chantier_outil.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.create_date IS 'Created on';


--
-- Name: COLUMN chantier_outil.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_outil.write_date IS 'Last Updated on';


--
-- Name: chantier_outil_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_outil_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_outil_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_outil_id_seq OWNED BY public.chantier_outil.id;


--
-- Name: chantier_paiement_fss; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_paiement_fss (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    ouvrier_id integer NOT NULL,
    currency_id integer,
    create_uid integer,
    write_uid integer,
    periode character varying NOT NULL,
    state character varying,
    reference_paiement character varying,
    date date NOT NULL,
    note text,
    montant numeric NOT NULL,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_paiement_fss; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_paiement_fss IS 'Paiement Fonds de Sécurité d''Existence (FSS)';


--
-- Name: COLUMN chantier_paiement_fss.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_paiement_fss.ouvrier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.ouvrier_id IS 'Ouvrier concerné';


--
-- Name: COLUMN chantier_paiement_fss.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.currency_id IS 'Currency';


--
-- Name: COLUMN chantier_paiement_fss.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_paiement_fss.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_paiement_fss.periode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.periode IS 'Période (ex: Q1 2026)';


--
-- Name: COLUMN chantier_paiement_fss.state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.state IS 'État';


--
-- Name: COLUMN chantier_paiement_fss.reference_paiement; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.reference_paiement IS 'Référence de paiement';


--
-- Name: COLUMN chantier_paiement_fss.date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.date IS 'Date du paiement';


--
-- Name: COLUMN chantier_paiement_fss.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.note IS 'Note';


--
-- Name: COLUMN chantier_paiement_fss.montant; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.montant IS 'Montant FSS (€)';


--
-- Name: COLUMN chantier_paiement_fss.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.create_date IS 'Created on';


--
-- Name: COLUMN chantier_paiement_fss.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_paiement_fss.write_date IS 'Last Updated on';


--
-- Name: chantier_paiement_fss_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_paiement_fss_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_paiement_fss_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_paiement_fss_id_seq OWNED BY public.chantier_paiement_fss.id;


--
-- Name: chantier_photo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_photo (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    auteur_id integer,
    create_uid integer,
    write_uid integer,
    name character varying NOT NULL,
    date date,
    description text,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_photo; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_photo IS 'Photo de chantier';


--
-- Name: COLUMN chantier_photo.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_photo.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_photo.auteur_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_photo.auteur_id IS 'Pris par';


--
-- Name: COLUMN chantier_photo.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_photo.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_photo.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_photo.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_photo.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_photo.name IS 'Titre';


--
-- Name: COLUMN chantier_photo.date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_photo.date IS 'Date';


--
-- Name: COLUMN chantier_photo.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_photo.description IS 'Description';


--
-- Name: COLUMN chantier_photo.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_photo.create_date IS 'Created on';


--
-- Name: COLUMN chantier_photo.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_photo.write_date IS 'Last Updated on';


--
-- Name: chantier_photo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_photo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_photo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_photo_id_seq OWNED BY public.chantier_photo.id;


--
-- Name: chantier_plan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_plan (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    auteur_id integer,
    create_uid integer,
    write_uid integer,
    name character varying NOT NULL,
    version character varying,
    fichier_name character varying,
    date date,
    annotation text,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_plan; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_plan IS 'Plan de chantier (PDF ou image)';


--
-- Name: COLUMN chantier_plan.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_plan.auteur_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.auteur_id IS 'Ajouté par';


--
-- Name: COLUMN chantier_plan.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_plan.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_plan.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.name IS 'Intitulé du plan';


--
-- Name: COLUMN chantier_plan.version; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.version IS 'Version';


--
-- Name: COLUMN chantier_plan.fichier_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.fichier_name IS 'Nom du fichier';


--
-- Name: COLUMN chantier_plan.date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.date IS 'Date';


--
-- Name: COLUMN chantier_plan.annotation; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.annotation IS 'Annotations';


--
-- Name: COLUMN chantier_plan.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.create_date IS 'Created on';


--
-- Name: COLUMN chantier_plan.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_plan.write_date IS 'Last Updated on';


--
-- Name: chantier_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_plan_id_seq OWNED BY public.chantier_plan.id;


--
-- Name: chantier_rapport_journalier; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_rapport_journalier (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    auteur_id integer NOT NULL,
    nb_ouvriers integer,
    create_uid integer,
    write_uid integer,
    meteo character varying,
    date date NOT NULL,
    travaux_realises text NOT NULL,
    incidents text,
    note text,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_rapport_journalier; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_rapport_journalier IS 'Rapport journalier de chantier';


--
-- Name: COLUMN chantier_rapport_journalier.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_rapport_journalier.auteur_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.auteur_id IS 'Auteur';


--
-- Name: COLUMN chantier_rapport_journalier.nb_ouvriers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.nb_ouvriers IS 'Nombre d''ouvriers présents';


--
-- Name: COLUMN chantier_rapport_journalier.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_rapport_journalier.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_rapport_journalier.meteo; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.meteo IS 'Météo';


--
-- Name: COLUMN chantier_rapport_journalier.date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.date IS 'Date';


--
-- Name: COLUMN chantier_rapport_journalier.travaux_realises; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.travaux_realises IS 'Travaux réalisés';


--
-- Name: COLUMN chantier_rapport_journalier.incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.incidents IS 'Incidents / Remarques';


--
-- Name: COLUMN chantier_rapport_journalier.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.note IS 'Notes complémentaires';


--
-- Name: COLUMN chantier_rapport_journalier.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.create_date IS 'Created on';


--
-- Name: COLUMN chantier_rapport_journalier.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_rapport_journalier.write_date IS 'Last Updated on';


--
-- Name: chantier_rapport_journalier_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_rapport_journalier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_rapport_journalier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_rapport_journalier_id_seq OWNED BY public.chantier_rapport_journalier.id;


--
-- Name: chantier_tache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chantier_tache (
    id integer NOT NULL,
    chantier_id integer NOT NULL,
    sequence integer,
    responsable_id integer,
    create_uid integer,
    write_uid integer,
    name character varying NOT NULL,
    state character varying,
    date_debut date,
    date_fin date,
    description text,
    note text,
    create_date timestamp without time zone,
    write_date timestamp without time zone
);


--
-- Name: TABLE chantier_tache; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chantier_tache IS 'Tâche planifiée du chantier';


--
-- Name: COLUMN chantier_tache.chantier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.chantier_id IS 'Chantier';


--
-- Name: COLUMN chantier_tache.sequence; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.sequence IS 'Séquence';


--
-- Name: COLUMN chantier_tache.responsable_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.responsable_id IS 'Responsable';


--
-- Name: COLUMN chantier_tache.create_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.create_uid IS 'Created by';


--
-- Name: COLUMN chantier_tache.write_uid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.write_uid IS 'Last Updated by';


--
-- Name: COLUMN chantier_tache.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.name IS 'Nom de la tâche';


--
-- Name: COLUMN chantier_tache.state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.state IS 'État';


--
-- Name: COLUMN chantier_tache.date_debut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.date_debut IS 'Date de début';


--
-- Name: COLUMN chantier_tache.date_fin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.date_fin IS 'Date de fin prévue';


--
-- Name: COLUMN chantier_tache.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.description IS 'Description';


--
-- Name: COLUMN chantier_tache.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.note IS 'Notes';


--
-- Name: COLUMN chantier_tache.create_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.create_date IS 'Created on';


--
-- Name: COLUMN chantier_tache.write_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chantier_tache.write_date IS 'Last Updated on';


--
-- Name: chantier_tache_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chantier_tache_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chantier_tache_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chantier_tache_id_seq OWNED BY public.chantier_tache.id;


--
-- Name: chantier_attribution_outil id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_attribution_outil ALTER COLUMN id SET DEFAULT nextval('public.chantier_attribution_outil_id_seq'::regclass);


--
-- Name: chantier_avenant id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_avenant ALTER COLUMN id SET DEFAULT nextval('public.chantier_avenant_id_seq'::regclass);


--
-- Name: chantier_chantier id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_chantier ALTER COLUMN id SET DEFAULT nextval('public.chantier_chantier_id_seq'::regclass);


--
-- Name: chantier_commande_fournisseur id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur ALTER COLUMN id SET DEFAULT nextval('public.chantier_commande_fournisseur_id_seq'::regclass);


--
-- Name: chantier_commande_fournisseur_ligne id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur_ligne ALTER COLUMN id SET DEFAULT nextval('public.chantier_commande_fournisseur_ligne_id_seq'::regclass);


--
-- Name: chantier_demande_materiel id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_demande_materiel ALTER COLUMN id SET DEFAULT nextval('public.chantier_demande_materiel_id_seq'::regclass);


--
-- Name: chantier_devis id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis ALTER COLUMN id SET DEFAULT nextval('public.chantier_devis_id_seq'::regclass);


--
-- Name: chantier_devis_ligne id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis_ligne ALTER COLUMN id SET DEFAULT nextval('public.chantier_devis_ligne_id_seq'::regclass);


--
-- Name: chantier_estimation_materiau id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_materiau ALTER COLUMN id SET DEFAULT nextval('public.chantier_estimation_materiau_id_seq'::regclass);


--
-- Name: chantier_estimation_outil id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_outil ALTER COLUMN id SET DEFAULT nextval('public.chantier_estimation_outil_id_seq'::regclass);


--
-- Name: chantier_facture id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_facture ALTER COLUMN id SET DEFAULT nextval('public.chantier_facture_id_seq'::regclass);


--
-- Name: chantier_heure_prestee id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_heure_prestee ALTER COLUMN id SET DEFAULT nextval('public.chantier_heure_prestee_id_seq'::regclass);


--
-- Name: chantier_materiau id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_materiau ALTER COLUMN id SET DEFAULT nextval('public.chantier_materiau_id_seq'::regclass);


--
-- Name: chantier_outil id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_outil ALTER COLUMN id SET DEFAULT nextval('public.chantier_outil_id_seq'::regclass);


--
-- Name: chantier_paiement_fss id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_paiement_fss ALTER COLUMN id SET DEFAULT nextval('public.chantier_paiement_fss_id_seq'::regclass);


--
-- Name: chantier_photo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_photo ALTER COLUMN id SET DEFAULT nextval('public.chantier_photo_id_seq'::regclass);


--
-- Name: chantier_plan id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_plan ALTER COLUMN id SET DEFAULT nextval('public.chantier_plan_id_seq'::regclass);


--
-- Name: chantier_rapport_journalier id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_rapport_journalier ALTER COLUMN id SET DEFAULT nextval('public.chantier_rapport_journalier_id_seq'::regclass);


--
-- Name: chantier_tache id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_tache ALTER COLUMN id SET DEFAULT nextval('public.chantier_tache_id_seq'::regclass);


--
-- Data for Name: chantier_attribution_outil; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_attribution_outil (id, chantier_id, outil_id, ouvrier_id, create_uid, write_uid, state, date_sortie, date_retour_prevue, date_retour_reelle, note, create_date, write_date) FROM stdin;
224	43	110	48	2	2	retourne	2026-02-20	2026-05-16	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
225	43	152	48	2	2	retourne	2026-01-03	2026-05-15	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
226	43	151	43	2	2	retourne	2026-01-09	2026-05-24	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
227	43	132	49	2	2	retourne	2026-04-04	2026-05-19	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
228	44	124	47	2	2	retourne	2026-03-30	2026-05-24	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
229	44	140	52	2	2	attribue	2026-03-26	2026-05-20	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
230	44	135	42	2	2	retourne	2026-03-01	2026-05-17	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
231	44	135	41	2	2	retourne	2025-12-14	2026-05-19	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
232	45	130	47	2	2	retourne	2026-01-01	2026-05-21	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
233	45	118	43	2	2	attribue	2026-03-18	2026-05-23	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
234	45	131	49	2	2	attribue	2026-05-11	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
235	45	140	43	2	2	retourne	2025-12-07	2026-05-13	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
236	45	108	41	2	2	retourne	2026-05-06	2026-05-18	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
237	46	113	47	2	2	retourne	2026-03-08	2026-05-15	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
238	46	122	41	2	2	retourne	2026-01-01	2026-05-15	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
239	46	113	48	2	2	retourne	2025-12-20	2026-05-13	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
240	46	103	44	2	2	attribue	2026-05-02	2026-05-24	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
241	46	112	52	2	2	retourne	2026-02-01	2026-05-27	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
242	46	143	47	2	2	retourne	2026-03-13	2026-05-20	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
243	46	126	50	2	2	attribue	2026-04-10	2026-05-17	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
244	47	129	48	2	2	retourne	2026-02-18	2026-05-18	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
245	47	127	48	2	2	retourne	2026-01-09	2026-05-26	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
246	47	119	49	2	2	retourne	2025-12-14	2026-05-18	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
247	47	106	47	2	2	attribue	2026-03-04	2026-05-21	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
248	47	152	47	2	2	attribue	2026-02-10	2026-05-13	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
249	47	111	52	2	2	retourne	2026-04-25	2026-05-24	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
250	47	137	41	2	2	attribue	2026-05-07	2026-05-13	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
251	48	108	48	2	2	retourne	2026-04-09	2026-05-17	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
252	48	130	48	2	2	attribue	2026-01-18	2026-05-13	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
253	48	108	48	2	2	attribue	2026-03-20	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
254	48	117	44	2	2	retourne	2026-04-22	2026-05-16	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
255	49	147	43	2	2	attribue	2025-12-11	2026-05-21	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
256	49	137	42	2	2	retourne	2026-02-08	2026-05-23	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
257	49	133	47	2	2	retourne	2025-12-17	2026-05-15	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
258	49	104	43	2	2	attribue	2026-03-30	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
259	49	104	42	2	2	attribue	2026-04-11	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
260	49	132	47	2	2	retourne	2026-04-30	2026-05-15	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
261	50	123	50	2	2	retourne	2026-01-18	2026-05-24	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
262	50	103	44	2	2	retourne	2026-02-14	2026-05-27	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
263	50	104	45	2	2	attribue	2026-05-05	2026-05-22	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
264	50	140	49	2	2	attribue	2026-02-07	2026-05-27	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
265	51	121	45	2	2	attribue	2026-02-11	2026-05-16	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
266	51	119	49	2	2	attribue	2026-02-10	2026-05-15	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
267	51	103	44	2	2	attribue	2025-12-27	2026-05-22	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
268	51	124	49	2	2	retourne	2025-12-28	2026-05-18	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
269	51	103	43	2	2	attribue	2026-04-23	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
270	51	137	49	2	2	retourne	2026-05-12	2026-05-27	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
271	51	110	42	2	2	retourne	2026-01-28	2026-05-26	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
272	52	116	42	2	2	retourne	2026-01-06	2026-05-13	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
273	52	138	43	2	2	retourne	2026-04-22	2026-05-23	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
274	52	146	43	2	2	attribue	2026-05-05	2026-05-18	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
275	52	143	42	2	2	attribue	2026-01-21	2026-05-24	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
276	52	123	52	2	2	attribue	2026-02-18	2026-05-22	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
277	52	132	44	2	2	attribue	2025-12-21	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
278	52	104	51	2	2	retourne	2025-12-04	2026-05-17	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
279	53	138	49	2	2	attribue	2025-12-20	2026-05-15	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
280	53	128	51	2	2	attribue	2025-12-14	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
281	53	109	42	2	2	attribue	2025-12-04	2026-05-18	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
282	53	141	49	2	2	retourne	2026-04-12	2026-05-22	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
283	53	104	49	2	2	retourne	2026-04-11	2026-05-14	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
284	53	116	52	2	2	attribue	2026-05-05	2026-05-27	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
285	54	119	42	2	2	retourne	2026-04-06	2026-05-23	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
286	54	125	43	2	2	attribue	2026-02-28	2026-05-15	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
287	54	111	44	2	2	retourne	2026-01-15	2026-05-15	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
288	54	103	49	2	2	attribue	2026-01-20	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
289	55	134	41	2	2	retourne	2026-05-07	2026-05-19	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
290	55	132	48	2	2	retourne	2026-05-01	2026-05-20	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
291	55	105	51	2	2	retourne	2026-02-17	2026-05-22	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
292	55	147	50	2	2	retourne	2026-03-02	2026-05-16	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
293	55	117	49	2	2	retourne	2026-04-16	2026-05-20	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
294	56	116	50	2	2	attribue	2026-04-12	2026-05-22	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
295	56	130	48	2	2	retourne	2026-04-16	2026-05-22	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
296	56	134	44	2	2	attribue	2026-04-04	2026-05-22	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
297	56	141	44	2	2	retourne	2026-05-06	2026-05-26	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
298	56	120	48	2	2	retourne	2026-02-01	2026-05-14	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
299	56	110	50	2	2	attribue	2026-01-29	2026-05-27	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
300	56	127	46	2	2	attribue	2026-01-02	2026-05-16	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
301	57	143	52	2	2	retourne	2026-03-19	2026-05-21	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
302	57	114	47	2	2	retourne	2026-04-07	2026-05-25	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
303	57	113	49	2	2	retourne	2026-01-06	2026-05-17	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
304	57	137	41	2	2	retourne	2025-12-08	2026-05-25	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
305	58	148	47	2	2	attribue	2025-12-03	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
306	58	124	41	2	2	retourne	2026-02-16	2026-05-17	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
307	58	131	46	2	2	retourne	2026-04-08	2026-05-20	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
308	58	133	49	2	2	attribue	2026-01-13	2026-05-15	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
309	59	107	44	2	2	attribue	2026-02-10	2026-05-24	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
310	59	111	51	2	2	attribue	2026-01-09	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
311	59	135	50	2	2	retourne	2026-02-02	2026-05-24	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
312	59	117	52	2	2	retourne	2026-01-03	2026-05-16	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
313	59	137	42	2	2	retourne	2026-05-12	2026-05-26	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
314	59	130	50	2	2	attribue	2026-03-05	2026-05-24	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
315	60	129	48	2	2	retourne	2026-01-20	2026-05-14	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
316	60	131	45	2	2	retourne	2025-12-10	2026-05-18	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
317	60	105	49	2	2	retourne	2025-12-18	2026-05-27	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
318	60	132	45	2	2	retourne	2026-04-30	2026-05-23	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
319	60	110	42	2	2	retourne	2026-02-21	2026-05-16	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
320	60	112	49	2	2	retourne	2025-12-25	2026-05-25	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
321	61	112	52	2	2	retourne	2026-04-16	2026-05-13	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
322	61	124	47	2	2	attribue	2026-04-13	2026-05-27	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
323	61	115	42	2	2	attribue	2026-01-12	2026-05-27	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
324	61	103	41	2	2	retourne	2026-03-24	2026-05-21	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
325	61	124	50	2	2	attribue	2026-02-11	2026-05-13	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
326	61	136	49	2	2	retourne	2026-04-11	2026-05-17	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
327	61	133	49	2	2	retourne	2026-03-06	2026-05-16	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
328	62	119	44	2	2	retourne	2025-12-10	2026-05-23	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
329	62	113	47	2	2	retourne	2026-01-01	2026-05-24	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
330	62	120	52	2	2	attribue	2026-05-11	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
331	62	119	50	2	2	attribue	2026-02-05	2026-05-23	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
332	62	130	50	2	2	retourne	2026-05-02	2026-05-20	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Data for Name: chantier_avenant; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_avenant (id, devis_id, currency_id, create_uid, write_uid, name, state, date, motif, note, montant_ht, create_date, write_date) FROM stdin;
59	34	126	2	2	AVN-001	accepte	2026-05-26	Supplément isolation demandé	\N	12095.21	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
60	35	126	2	2	AVN-002	brouillon	2026-05-15	Changement carrelage client	\N	3274.74	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
61	35	126	2	2	AVN-003	accepte	2026-05-03	Ajout cloison supplémentaire	\N	9612.99	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
62	35	126	2	2	AVN-004	accepte	2026-05-19	Supplément isolation demandé	\N	8153.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
63	36	126	2	2	AVN-005	brouillon	2026-05-10	Ajout cloison supplémentaire	\N	11803.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
64	36	126	2	2	AVN-006	brouillon	2026-05-26	Ajout cloison supplémentaire	\N	5570.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
65	37	126	2	2	AVN-007	brouillon	2026-05-26	Supplément isolation demandé	\N	11348.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
66	38	126	2	2	AVN-008	accepte	2026-05-25	Ajout cloison supplémentaire	\N	3565.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
67	39	126	2	2	AVN-009	accepte	2026-05-28	Changement carrelage client	\N	7007.21	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
68	39	126	2	2	AVN-010	accepte	2026-05-29	Supplément isolation demandé	\N	8698.81	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
69	40	126	2	2	AVN-011	accepte	2026-05-20	Ajout cloison supplémentaire	\N	7358.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
70	41	126	2	2	AVN-012	accepte	2026-05-03	Modification plan architect	\N	8168.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
71	42	126	2	2	AVN-013	accepte	2026-05-16	Modification plan architect	\N	14786.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
72	42	126	2	2	AVN-014	accepte	2026-05-31	Changement carrelage client	\N	14934.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
73	43	126	2	2	AVN-015	accepte	2026-05-26	Supplément isolation demandé	\N	12241.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
74	43	126	2	2	AVN-016	accepte	2026-05-09	Rallonge délai travaux	\N	8252.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
75	43	126	2	2	AVN-017	brouillon	2026-05-08	Modification plan architect	\N	11756.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
76	44	126	2	2	AVN-018	brouillon	2026-05-16	Rallonge délai travaux	\N	8076.52	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
77	45	126	2	2	AVN-019	brouillon	2026-05-08	Modification plan architect	\N	5462.81	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
78	45	126	2	2	AVN-020	accepte	2026-05-16	Changement carrelage client	\N	11572.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
79	46	126	2	2	AVN-021	accepte	2026-05-02	Modification plan architect	\N	11885.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
80	46	126	2	2	AVN-022	accepte	2026-05-26	Supplément isolation demandé	\N	5542.53	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
81	47	126	2	2	AVN-023	brouillon	2026-05-06	Modification plan architect	\N	13953.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
82	47	126	2	2	AVN-024	brouillon	2026-05-08	Rallonge délai travaux	\N	2614.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
83	48	126	2	2	AVN-025	brouillon	2026-05-18	Supplément isolation demandé	\N	6467.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
84	48	126	2	2	AVN-026	brouillon	2026-05-25	Modification plan architect	\N	12276.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
85	49	126	2	2	AVN-027	accepte	2026-05-21	Ajout cloison supplémentaire	\N	14128.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
86	49	126	2	2	AVN-028	accepte	2026-05-11	Supplément isolation demandé	\N	531.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
87	49	126	2	2	AVN-029	accepte	2026-05-27	Modification plan architect	\N	10619.95	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
88	50	126	2	2	AVN-030	brouillon	2026-05-08	Ajout cloison supplémentaire	\N	13731.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
89	50	126	2	2	AVN-031	brouillon	2026-05-23	Rallonge délai travaux	\N	8221.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
90	50	126	2	2	AVN-032	accepte	2026-05-05	Modification plan architect	\N	3852.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
91	51	126	2	2	AVN-033	accepte	2026-05-15	Ajout cloison supplémentaire	\N	6903.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
92	52	126	2	2	AVN-034	accepte	2026-05-15	Rallonge délai travaux	\N	6464.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
93	52	126	2	2	AVN-035	accepte	2026-05-14	Changement carrelage client	\N	3363.62	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
94	53	126	2	2	AVN-036	accepte	2026-05-14	Modification plan architect	\N	3656.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
95	54	126	2	2	AVN-037	brouillon	2026-05-07	Modification plan architect	\N	898.53	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
96	54	126	2	2	AVN-038	accepte	2026-05-16	Changement carrelage client	\N	11748.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
97	55	126	2	2	AVN-039	accepte	2026-05-25	Changement carrelage client	\N	9916.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
98	56	126	2	2	AVN-040	brouillon	2026-05-02	Supplément isolation demandé	\N	11259.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
99	56	126	2	2	AVN-041	brouillon	2026-05-08	Modification plan architect	\N	3105.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
100	57	126	2	2	AVN-042	accepte	2026-05-12	Rallonge délai travaux	\N	8036.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
101	58	126	2	2	AVN-043	accepte	2026-05-08	Rallonge délai travaux	\N	4507.63	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
102	58	126	2	2	AVN-044	brouillon	2026-05-17	Ajout cloison supplémentaire	\N	8561.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
103	58	126	2	2	AVN-045	accepte	2026-05-03	Ajout cloison supplémentaire	\N	11990.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
104	59	126	2	2	AVN-046	brouillon	2026-05-25	Modification plan architect	\N	7233.14	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
105	59	126	2	2	AVN-047	accepte	2026-05-02	Changement carrelage client	\N	12209.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
106	60	126	2	2	AVN-048	accepte	2026-05-16	Changement carrelage client	\N	6700.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
107	60	126	2	2	AVN-049	accepte	2026-05-16	Modification plan architect	\N	5802.62	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
108	60	126	2	2	AVN-050	accepte	2026-05-21	Rallonge délai travaux	\N	13684.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
109	61	126	2	2	AVN-051	brouillon	2026-05-28	Ajout cloison supplémentaire	\N	4007.33	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
110	62	126	2	2	AVN-052	accepte	2026-05-28	Modification plan architect	\N	7046.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
111	63	126	2	2	AVN-053	brouillon	2026-05-31	Ajout cloison supplémentaire	\N	14560.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
112	63	126	2	2	AVN-054	accepte	2026-05-21	Rallonge délai travaux	\N	5424.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
113	63	126	2	2	AVN-055	accepte	2026-05-15	Rallonge délai travaux	\N	7569.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Data for Name: chantier_chantier; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_chantier (id, client_id, chef_chantier_id, currency_id, create_uid, write_uid, name, ref, adresse, state, date_debut, date_fin_prevue, date_fin_reelle, description, budget_initial, cout_reel, montant_facture, marge, create_date, write_date, nb_heures, avancement) FROM stdin;
2	12	5	126	2	2	chantier Yser	CHT/2026/0002	quai de wilbroek	en_cours	2026-06-03	2026-06-08	\N	\N	10000.00	150.00	12100.00	11950.00	2026-06-01 08:23:47.681378	2026-06-01 08:46:57.707284	10	0
43	141	53	126	2	2	Rénovation Immeuble Rue de la Loi	CHT/2025/0001	Rue de la Loi 42, 1000 Bruxelles	en_cours	2025-12-03	2026-05-22	\N	\N	850000	469625.0	497250.0	27625.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	12277.8	65
44	142	54	126	2	2	Construction Villa Waterloo	CHT/2025/0002	Chemin du Moulin 8, 1410 Waterloo	en_cours	2026-02-01	2026-07-31	\N	\N	450000	172125.0	182250.0	10125.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4500	45
45	143	55	126	2	2	Extension Entrepôt Anderlecht	CHT/2025/0003	Rue Lhote 25, 1070 Anderlecht	termine	2025-08-05	2026-04-02	2026-05-27	\N	320000	217600.0	230400.0	12800.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5688.9	80
46	144	56	126	2	2	Réhabilitation Lofts Liège	CHT/2025/0004	Quai de la Goffe 12, 4000 Liège	en_cours	2026-03-03	2026-08-30	\N	\N	680000	317900.0	336600.0	18700.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8311.1	55
47	145	57	126	2	2	Bureaux Parc Scientifique UCL	CHT/2025/0005	Chemin du Cyclotron 6, 1348 LLN	en_cours	2026-04-02	2026-10-29	\N	\N	1200000	357000.0	378000.0	21000.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9333.3	35
48	146	53	126	2	2	Rénovation École Communale Gand	CHT/2025/0006	Stropstraat 14, 9000 Gent	termine	2025-04-27	2026-05-02	2026-05-30	\N	380000	290700.0	307800.0	17100.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7600	90
49	147	54	126	2	2	Lotissement 12 Maisons Namur	CHT/2025/0007	Rue des Charmes 45, 5100 Namur	en_cours	2026-05-02	2027-05-27	\N	\N	2400000	408000.0	432000.0	24000.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	10666.7	20
50	148	55	126	2	2	Parking Souterrain Charleroi	CHT/2025/0008	Boulevard Tirou 80, 6000 Charleroi	en_cours	2026-01-02	2026-07-01	\N	\N	950000	565250.0	598500.0	33250.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14777.8	70
51	141	56	126	2	2	Toiture Château Mirwart	CHT/2025/0009	Rue du Château 1, 6870 Mirwart	termine	2025-01-17	2026-05-12	2026-05-31	\N	280000	226100.0	239400.0	13300.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5911.1	95
52	142	57	126	2	2	Aménagement Hall Sportif	CHT/2025/0010	Avenue Reine Fabiola 15, 1020 Laeken	en_cours	2026-02-21	2026-07-16	\N	\N	520000	265200.0	280800.0	15600.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6933.3	60
53	143	53	126	2	2	Résidence Seniors Ottignies	CHT/2025/0011	Rue du Bosquet 22, 1340 Ottignies	en_cours	2026-04-17	2027-02-26	\N	\N	1800000	612000.0	648000.0	36000.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	16000	40
54	144	54	126	2	2	Rénovation Façades Bruges	CHT/2025/0012	Vlamingstraat 33, 8000 Brugge	termine	2025-09-24	2026-05-17	2026-05-29	\N	240000	173400.0	183600.0	10200.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4533.3	85
55	145	55	126	2	2	Centre Commercial Tournai	CHT/2025/0013	Rue du Château 45, 7500 Tournai	en_cours	2026-05-17	2027-09-24	\N	\N	3200000	680000.0	720000.0	40000.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17777.8	25
56	146	56	126	2	2	Entrepôt Logistique Gosselies	CHT/2025/0014	Aéropole de Charleroi 8, 6041 Gosselies	en_cours	2025-11-13	2026-06-26	\N	\N	760000	484500.0	513000.0	28500.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	12666.7	75
57	147	57	126	2	2	Rénovation Hôtel de Ville Arlon	CHT/2025/0015	Grand Place 1, 6700 Arlon	en_cours	2026-03-13	2026-09-29	\N	\N	420000	178500.0	189000.0	10500.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4666.7	50
58	148	53	126	2	2	Construction Piscine Couverte	CHT/2025/0016	Rue du Stade 55, 4800 Verviers	en_cours	2026-02-11	2026-08-20	\N	\N	890000	491725.0	520650.0	28925.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	12855.6	65
59	141	54	126	2	2	Maison Passive Rixensart	CHT/2025/0017	Chemin de la Chapelle 14, 1330 Rixensart	en_cours	2026-05-07	2026-11-28	\N	\N	380000	96900.0	102600.0	5700.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	2533.3	30
60	142	55	126	2	2	Réaménagement Gare Mons	CHT/2025/0018	Place Léopold II 1, 7000 Mons	brouillon	2026-06-01	2027-11-23	\N	\N	5600000	476000.0	504000.0	28000.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	12444.4	10
61	143	56	126	2	2	Isolation Résidence Jette	CHT/2025/0019	Rue des Pommiers 88, 1090 Jette	termine	2025-12-03	2026-05-22	2026-05-27	\N	145000	117087.5	123975.0	6887.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	3061.1	95
62	144	57	126	2	2	Clinique Vétérinaire Wavre	CHT/2025/0020	Chaussée de Bruxelles 200, 1300 Wavre	en_cours	2026-03-23	2026-09-09	\N	\N	680000	317900.0	336600.0	18700.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8311.1	55
\.


--
-- Data for Name: chantier_commande_fournisseur; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_commande_fournisseur (id, chantier_id, fournisseur_id, currency_id, create_uid, write_uid, name, state, date, date_livraison_prevue, note, montant_total, create_date, write_date) FROM stdin;
31	50	153	126	2	2	CMD/2025/0024	envoye	2026-01-11	2026-05-30	\N	36640.11	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
32	51	160	126	2	2	CMD/2025/0025	envoye	2026-01-22	2026-06-03	\N	49651.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
33	51	155	126	2	2	CMD/2025/0026	recu	2026-03-04	2026-05-27	\N	39120.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
34	51	154	126	2	2	CMD/2025/0027	envoye	2026-02-25	2026-06-06	\N	21608.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
4	2	10	126	2	2	CMD/2025/0001	envoye	2026-02-11	2026-06-01	\N	54088.12	2026-06-01 11:23:44.878308	2026-06-01 11:23:44.878308
5	2	11	126	2	2	CMD/2025/0002	recu	2026-04-02	2026-05-30	\N	15796.74	2026-06-01 11:23:44.878308	2026-06-01 11:23:44.878308
6	43	159	126	2	2	CMD/2025/0001	recu	2026-04-28	2026-06-05	\N	63898.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
7	43	158	126	2	2	CMD/2025/0002	envoye	2026-03-08	2026-05-31	\N	22300.14	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
8	43	153	126	2	2	CMD/2025/0003	brouillon	2026-01-12	2026-05-29	\N	37347.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
9	43	159	126	2	2	CMD/2025/0004	envoye	2026-01-08	2026-05-29	\N	15811.11	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
10	44	159	126	2	2	CMD/2025/0004	brouillon	2026-03-06	2026-05-23	\N	40951.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
11	44	154	126	2	2	CMD/2025/0005	recu	2026-01-16	2026-05-25	\N	12979.51	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
12	44	156	126	2	2	CMD/2025/0006	envoye	2026-04-02	2026-05-30	\N	23421.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
13	45	155	126	2	2	CMD/2025/0007	brouillon	2026-02-24	2026-05-26	\N	29728.68	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
14	45	155	126	2	2	CMD/2025/0008	recu	2026-03-04	2026-06-06	\N	39259.97	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
15	45	155	126	2	2	CMD/2025/0009	envoye	2026-05-06	2026-06-01	\N	17536.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
16	45	157	126	2	2	CMD/2025/0010	recu	2026-01-06	2026-06-06	\N	27581.29	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
17	46	155	126	2	2	CMD/2025/0010	recu	2026-04-29	2026-05-26	\N	34849.86	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
18	46	160	126	2	2	CMD/2025/0011	brouillon	2026-05-21	2026-06-04	\N	22843.17	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
19	47	155	126	2	2	CMD/2025/0013	brouillon	2026-05-11	2026-05-23	\N	23353.29	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
20	47	159	126	2	2	CMD/2025/0014	envoye	2026-04-30	2026-05-27	\N	23282.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
21	47	153	126	2	2	CMD/2025/0015	recu	2026-03-16	2026-06-06	\N	22894.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
22	48	153	126	2	2	CMD/2025/0016	recu	2026-05-22	2026-06-04	\N	34386.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
23	48	153	126	2	2	CMD/2025/0017	recu	2026-01-31	2026-05-28	\N	16212.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
24	48	157	126	2	2	CMD/2025/0018	brouillon	2026-02-16	2026-05-31	\N	24990.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
25	49	156	126	2	2	CMD/2025/0019	brouillon	2026-04-05	2026-05-30	\N	70014.52	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
26	49	153	126	2	2	CMD/2025/0020	envoye	2026-03-03	2026-05-31	\N	32089.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
27	49	156	126	2	2	CMD/2025/0021	brouillon	2026-03-16	2026-05-26	\N	33020.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
28	49	155	126	2	2	CMD/2025/0022	brouillon	2026-05-13	2026-06-01	\N	33359.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
29	50	154	126	2	2	CMD/2025/0022	brouillon	2026-02-25	2026-05-31	\N	12200.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
30	50	160	126	2	2	CMD/2025/0023	brouillon	2026-04-17	2026-05-28	\N	21603.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
35	51	155	126	2	2	CMD/2025/0028	brouillon	2026-05-22	2026-05-25	\N	12957.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
36	52	155	126	2	2	CMD/2025/0028	recu	2026-03-05	2026-05-26	\N	49844.29	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
37	52	156	126	2	2	CMD/2025/0029	envoye	2026-03-04	2026-05-23	\N	20506.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
38	53	156	126	2	2	CMD/2025/0031	recu	2026-02-09	2026-06-01	\N	24509.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
39	53	160	126	2	2	CMD/2025/0032	recu	2026-05-14	2026-06-03	\N	45653.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
40	54	156	126	2	2	CMD/2025/0034	recu	2026-05-18	2026-06-02	\N	41700.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
41	54	159	126	2	2	CMD/2025/0035	brouillon	2026-01-28	2026-05-23	\N	19767.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
42	55	155	126	2	2	CMD/2025/0037	recu	2026-04-24	2026-05-28	\N	48009.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
43	55	153	126	2	2	CMD/2025/0038	envoye	2026-03-16	2026-06-01	\N	36130.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
44	55	156	126	2	2	CMD/2025/0039	recu	2026-03-24	2026-05-26	\N	23878.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
45	56	158	126	2	2	CMD/2025/0040	envoye	2026-03-05	2026-06-01	\N	35182.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
46	56	158	126	2	2	CMD/2025/0041	brouillon	2026-04-01	2026-05-25	\N	30428.96	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
47	56	157	126	2	2	CMD/2025/0042	envoye	2026-02-24	2026-05-26	\N	36434.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
48	57	153	126	2	2	CMD/2025/0043	envoye	2026-02-17	2026-05-27	\N	25092.52	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
49	57	156	126	2	2	CMD/2025/0044	brouillon	2026-04-15	2026-06-01	\N	22845.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
50	57	160	126	2	2	CMD/2025/0045	envoye	2026-02-19	2026-05-30	\N	27436.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
51	58	158	126	2	2	CMD/2025/0046	envoye	2026-04-10	2026-05-25	\N	35890.57	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
52	58	155	126	2	2	CMD/2025/0047	brouillon	2026-03-02	2026-05-27	\N	66170.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
53	58	157	126	2	2	CMD/2025/0048	envoye	2026-02-13	2026-06-01	\N	26761.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
54	59	160	126	2	2	CMD/2025/0049	recu	2026-04-16	2026-05-26	\N	24689.21	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
55	59	158	126	2	2	CMD/2025/0050	recu	2026-04-03	2026-05-30	\N	41977.58	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
56	59	155	126	2	2	CMD/2025/0051	recu	2026-02-07	2026-05-28	\N	42370.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
57	59	155	126	2	2	CMD/2025/0052	recu	2026-04-27	2026-06-02	\N	27548.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
58	60	158	126	2	2	CMD/2025/0052	recu	2026-04-21	2026-05-31	\N	21561.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
59	60	153	126	2	2	CMD/2025/0053	recu	2026-03-11	2026-05-30	\N	10014.17	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
60	60	158	126	2	2	CMD/2025/0054	envoye	2026-01-16	2026-06-02	\N	68989.97	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
61	61	156	126	2	2	CMD/2025/0055	recu	2026-01-25	2026-06-04	\N	40903.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
62	61	158	126	2	2	CMD/2025/0056	envoye	2026-03-16	2026-06-02	\N	29853.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
63	61	160	126	2	2	CMD/2025/0057	envoye	2026-02-28	2026-05-28	\N	49450.31	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
64	62	159	126	2	2	CMD/2025/0058	brouillon	2026-04-22	2026-05-26	\N	22924.86	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
65	62	153	126	2	2	CMD/2025/0059	envoye	2026-04-17	2026-06-06	\N	14277.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
66	62	156	126	2	2	CMD/2025/0060	recu	2026-03-27	2026-05-28	\N	12665.09	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Data for Name: chantier_commande_fournisseur_ligne; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_commande_fournisseur_ligne (id, commande_id, sequence, materiau_id, create_uid, write_uid, description, unite, prix_unitaire, sous_total, create_date, write_date, quantite) FROM stdin;
3	4	10	1	2	2	Approvisionnement chantier	sac	149.29	29021.98	2026-06-01 11:23:44.878308	2026-06-01 11:23:44.878308	194.4
4	4	10	2	2	2	Approvisionnement chantier	kg	128.79	13162.34	2026-06-01 11:23:44.878308	2026-06-01 11:23:44.878308	102.2
5	4	10	2	2	2	Approvisionnement chantier	kg	121.22	11903.8	2026-06-01 11:23:44.878308	2026-06-01 11:23:44.878308	98.2
6	5	10	2	2	2	Approvisionnement chantier	m2	85.46	2247.6	2026-06-01 11:23:44.878308	2026-06-01 11:23:44.878308	26.3
7	5	10	1	2	2	Approvisionnement chantier	m3	53.57	3712.4	2026-06-01 11:23:44.878308	2026-06-01 11:23:44.878308	69.3
8	5	10	2	2	2	Approvisionnement chantier	m2	63.42	8904.17	2026-06-01 11:23:44.878308	2026-06-01 11:23:44.878308	140.4
9	5	10	2	2	2	Approvisionnement chantier	kg	5.88	932.57	2026-06-01 11:23:44.878308	2026-06-01 11:23:44.878308	158.6
10	6	10	151	2	2	Approvisionnement chantier	sac	104.08	2830.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	27.2
11	6	10	152	2	2	Approvisionnement chantier	piece	56.32	8622.59	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	153.1
12	6	10	129	2	2	Approvisionnement chantier	m3	116.09	18911.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	162.9
13	6	10	129	2	2	Approvisionnement chantier	m2	124.37	21777.19	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	175.1
14	6	10	145	2	2	Approvisionnement chantier	sac	103.49	11756.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	113.6
15	7	10	141	2	2	Approvisionnement chantier	sac	50.66	273.56	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.4
16	7	10	149	2	2	Approvisionnement chantier	piece	105.37	7101.94	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	67.4
17	7	10	139	2	2	Approvisionnement chantier	kg	94.4	14924.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	158.1
18	8	10	150	2	2	Approvisionnement chantier	piece	70.1	12961.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	184.9
19	8	10	121	2	2	Approvisionnement chantier	m3	46.15	5436.47	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	117.8
20	8	10	143	2	2	Approvisionnement chantier	kg	53.34	9163.81	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	171.8
21	8	10	117	2	2	Approvisionnement chantier	piece	91.97	9785.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	106.4
22	9	10	119	2	2	Approvisionnement chantier	piece	5.59	1049.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	187.8
23	9	10	140	2	2	Approvisionnement chantier	m3	42.92	4317.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	100.6
24	9	10	134	2	2	Approvisionnement chantier	m3	52.65	2548.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	48.4
25	9	10	115	2	2	Approvisionnement chantier	piece	69.6	5143.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	73.9
26	9	10	105	2	2	Approvisionnement chantier	piece	17.45	2751.86	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	157.7
27	10	10	109	2	2	Approvisionnement chantier	m3	20.16	594.72	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	29.5
28	10	10	107	2	2	Approvisionnement chantier	m2	45.96	5763.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	125.4
29	10	10	105	2	2	Approvisionnement chantier	m2	53.55	1290.56	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	24.1
30	10	10	152	2	2	Approvisionnement chantier	m3	68.55	3914.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	57.1
31	10	10	105	2	2	Approvisionnement chantier	m2	117.36	14540.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	123.9
32	10	10	104	2	2	Approvisionnement chantier	m2	76.93	14847.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	193
33	11	10	108	2	2	Approvisionnement chantier	piece	32.12	1233.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.4
34	11	10	150	2	2	Approvisionnement chantier	piece	87.39	10224.63	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	117
35	11	10	138	2	2	Approvisionnement chantier	piece	12.41	1521.47	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	122.6
36	12	10	138	2	2	Approvisionnement chantier	m3	18.55	519.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	28
37	12	10	115	2	2	Approvisionnement chantier	kg	43.7	5960.68	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	136.4
38	12	10	137	2	2	Approvisionnement chantier	m3	18.99	206.99	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	10.9
39	12	10	151	2	2	Approvisionnement chantier	m3	113.61	16734.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	147.3
40	13	10	133	2	2	Approvisionnement chantier	sac	76.07	14788.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	194.4
41	13	10	124	2	2	Approvisionnement chantier	m3	100.28	5685.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	56.7
42	13	10	130	2	2	Approvisionnement chantier	kg	70.77	2689.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38
43	13	10	124	2	2	Approvisionnement chantier	sac	29.15	4264.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	146.3
44	13	10	116	2	2	Approvisionnement chantier	m3	87.82	2300.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	26.2
45	14	10	140	2	2	Approvisionnement chantier	piece	56.57	4638.74	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	82
46	14	10	130	2	2	Approvisionnement chantier	kg	96.04	15760.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	164.1
47	14	10	107	2	2	Approvisionnement chantier	piece	61.75	5217.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	84.5
48	14	10	142	2	2	Approvisionnement chantier	kg	75.2	6219.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	82.7
49	14	10	113	2	2	Approvisionnement chantier	m3	55.57	7424.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	133.6
50	15	10	151	2	2	Approvisionnement chantier	m2	8.76	1024.92	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	117
51	15	10	130	2	2	Approvisionnement chantier	m3	49.06	4964.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	101.2
52	15	10	105	2	2	Approvisionnement chantier	m2	37.64	4178.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	111
53	15	10	126	2	2	Approvisionnement chantier	kg	145.62	7368.37	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	50.6
54	16	10	113	2	2	Approvisionnement chantier	kg	64.78	4962.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	76.6
55	16	10	115	2	2	Approvisionnement chantier	m2	79.83	7280.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	91.2
56	16	10	134	2	2	Approvisionnement chantier	m3	73.28	7276.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	99.3
57	16	10	140	2	2	Approvisionnement chantier	m3	105.11	8061.94	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	76.7
58	17	10	110	2	2	Approvisionnement chantier	m2	51.18	8823.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	172.4
59	17	10	111	2	2	Approvisionnement chantier	sac	115.56	1883.63	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	16.3
60	17	10	111	2	2	Approvisionnement chantier	sac	65.16	7910.42	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	121.4
61	17	10	112	2	2	Approvisionnement chantier	piece	127.28	13428.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	105.5
62	17	10	103	2	2	Approvisionnement chantier	sac	132.28	2804.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21.2
63	18	10	105	2	2	Approvisionnement chantier	kg	81.51	7441.86	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	91.3
64	18	10	135	2	2	Approvisionnement chantier	m2	54.63	3430.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	62.8
65	18	10	149	2	2	Approvisionnement chantier	m3	66.28	1915.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	28.9
66	18	10	115	2	2	Approvisionnement chantier	kg	18.03	3377.02	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	187.3
67	18	10	103	2	2	Approvisionnement chantier	piece	91.48	6678.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	73
68	19	10	117	2	2	Approvisionnement chantier	kg	57.86	5132.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	88.7
69	19	10	145	2	2	Approvisionnement chantier	sac	128.44	5715.58	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	44.5
70	19	10	121	2	2	Approvisionnement chantier	sac	100.35	11480.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	114.4
71	19	10	122	2	2	Approvisionnement chantier	piece	8.56	1025.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	119.8
72	20	10	152	2	2	Approvisionnement chantier	m2	103.74	2095.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20.2
73	20	10	142	2	2	Approvisionnement chantier	m3	133.95	18846.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	140.7
74	20	10	139	2	2	Approvisionnement chantier	sac	12.03	2339.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	194.5
75	21	10	133	2	2	Approvisionnement chantier	m3	69.39	4489.53	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	64.7
76	21	10	144	2	2	Approvisionnement chantier	m3	113.98	11774.13	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	103.3
77	21	10	126	2	2	Approvisionnement chantier	m3	38.73	6630.58	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	171.2
78	22	10	139	2	2	Approvisionnement chantier	m2	129.48	9063.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	70
79	22	10	116	2	2	Approvisionnement chantier	kg	79.57	15436.58	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	194
80	22	10	117	2	2	Approvisionnement chantier	sac	126.02	9602.72	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	76.2
81	22	10	129	2	2	Approvisionnement chantier	sac	19.02	283.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.9
82	23	10	117	2	2	Approvisionnement chantier	m3	136.02	6760.19	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	49.7
83	23	10	143	2	2	Approvisionnement chantier	piece	120.92	6662.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	55.1
84	23	10	105	2	2	Approvisionnement chantier	kg	13.15	1698.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	129.2
85	23	10	130	2	2	Approvisionnement chantier	piece	71.28	1090.58	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	15.3
86	24	10	123	2	2	Approvisionnement chantier	piece	121.0	8796.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	72.7
87	24	10	103	2	2	Approvisionnement chantier	m2	93.45	4485.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	48
88	24	10	144	2	2	Approvisionnement chantier	kg	83.02	10485.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	126.3
89	24	10	138	2	2	Approvisionnement chantier	sac	44.46	1222.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	27.5
90	25	10	104	2	2	Approvisionnement chantier	m3	133.3	21381.32	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	160.4
91	25	10	109	2	2	Approvisionnement chantier	m3	25.95	4639.86	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	178.8
92	25	10	151	2	2	Approvisionnement chantier	m3	149.62	27739.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	185.4
93	25	10	103	2	2	Approvisionnement chantier	sac	149.17	11023.66	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	73.9
94	25	10	142	2	2	Approvisionnement chantier	m3	36.27	5230.13	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	144.2
95	26	10	134	2	2	Approvisionnement chantier	m2	25.32	741.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	29.3
96	26	10	133	2	2	Approvisionnement chantier	m2	70.93	8575.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	120.9
97	26	10	146	2	2	Approvisionnement chantier	kg	58.38	3911.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	67
98	26	10	114	2	2	Approvisionnement chantier	sac	135.19	7340.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	54.3
99	26	10	118	2	2	Approvisionnement chantier	m3	95.18	5311.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	55.8
100	26	10	108	2	2	Approvisionnement chantier	sac	43.6	6208.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	142.4
101	27	10	151	2	2	Approvisionnement chantier	m3	134.14	9523.94	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	71
102	27	10	150	2	2	Approvisionnement chantier	m2	78.96	13794.31	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	174.7
103	27	10	117	2	2	Approvisionnement chantier	piece	93.74	9055.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	96.6
104	27	10	121	2	2	Approvisionnement chantier	m3	10.71	646.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	60.4
105	28	10	106	2	2	Approvisionnement chantier	m2	91.2	11664.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	127.9
106	28	10	123	2	2	Approvisionnement chantier	kg	140.94	16433.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	116.6
107	28	10	127	2	2	Approvisionnement chantier	m2	32.36	5261.74	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	162.6
108	29	10	152	2	2	Approvisionnement chantier	m2	10.01	1186.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	118.5
109	29	10	152	2	2	Approvisionnement chantier	kg	50.35	1535.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	30.5
110	29	10	144	2	2	Approvisionnement chantier	kg	147.85	3711.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.1
111	29	10	136	2	2	Approvisionnement chantier	sac	6.79	828.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	122
112	29	10	143	2	2	Approvisionnement chantier	kg	34.04	4939.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	145.1
113	30	10	143	2	2	Approvisionnement chantier	kg	95.77	1484.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	15.5
114	30	10	151	2	2	Approvisionnement chantier	m3	96.79	14073.27	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	145.4
115	30	10	109	2	2	Approvisionnement chantier	piece	27.72	4000.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	144.3
116	30	10	142	2	2	Approvisionnement chantier	sac	33.37	2045.58	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	61.3
117	31	10	139	2	2	Approvisionnement chantier	piece	51.35	7199.27	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	140.2
118	31	10	136	2	2	Approvisionnement chantier	m2	43.16	3565.02	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	82.6
119	31	10	103	2	2	Approvisionnement chantier	kg	107.9	20447.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	189.5
120	31	10	107	2	2	Approvisionnement chantier	m2	37.99	5428.77	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	142.9
121	32	10	121	2	2	Approvisionnement chantier	m3	130.45	22176.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	170
122	32	10	105	2	2	Approvisionnement chantier	kg	45.11	2905.08	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	64.4
123	32	10	121	2	2	Approvisionnement chantier	piece	103.14	14006.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	135.8
124	32	10	111	2	2	Approvisionnement chantier	piece	6.41	235.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	36.7
125	32	10	117	2	2	Approvisionnement chantier	m2	55.71	10328.63	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	185.4
126	33	10	105	2	2	Approvisionnement chantier	kg	81.94	6899.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	84.2
127	33	10	149	2	2	Approvisionnement chantier	m2	11.02	1859.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	168.7
128	33	10	142	2	2	Approvisionnement chantier	m2	38.33	1468.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.3
129	33	10	141	2	2	Approvisionnement chantier	m2	146.52	17245.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	117.7
130	33	10	108	2	2	Approvisionnement chantier	sac	107.01	8143.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	76.1
131	33	10	106	2	2	Approvisionnement chantier	piece	20.51	3505.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	170.9
132	34	10	151	2	2	Approvisionnement chantier	kg	77.15	1265.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	16.4
133	34	10	120	2	2	Approvisionnement chantier	sac	61.07	7365.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	120.6
134	34	10	134	2	2	Approvisionnement chantier	piece	5.4	152.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	28.2
135	34	10	121	2	2	Approvisionnement chantier	piece	49.95	8941.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	179
136	34	10	127	2	2	Approvisionnement chantier	kg	35.77	3884.62	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	108.6
137	35	10	111	2	2	Approvisionnement chantier	piece	34.68	6422.74	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	185.2
138	35	10	142	2	2	Approvisionnement chantier	m3	10.97	957.68	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	87.3
139	35	10	126	2	2	Approvisionnement chantier	m3	16.59	822.86	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	49.6
140	35	10	151	2	2	Approvisionnement chantier	m2	30.15	4754.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	157.7
141	36	10	103	2	2	Approvisionnement chantier	kg	137.91	19169.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	139
142	36	10	152	2	2	Approvisionnement chantier	sac	81.11	10771.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	132.8
143	36	10	147	2	2	Approvisionnement chantier	piece	86.76	5014.73	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	57.8
144	36	10	121	2	2	Approvisionnement chantier	piece	96.18	14888.66	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	154.8
145	37	10	125	2	2	Approvisionnement chantier	m3	82.25	5905.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	71.8
146	37	10	132	2	2	Approvisionnement chantier	m3	74.0	4047.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	54.7
147	37	10	133	2	2	Approvisionnement chantier	sac	61.53	8035.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	130.6
148	37	10	134	2	2	Approvisionnement chantier	m3	99.48	2516.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.3
149	38	10	146	2	2	Approvisionnement chantier	m3	124.97	19532.81	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	156.3
150	38	10	117	2	2	Approvisionnement chantier	sac	104.87	3565.58	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	34
151	38	10	138	2	2	Approvisionnement chantier	kg	41.75	1411.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	33.8
152	39	10	145	2	2	Approvisionnement chantier	m3	139.54	21810.1	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	156.3
153	39	10	132	2	2	Approvisionnement chantier	m3	124.8	23262.72	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	186.4
154	39	10	148	2	2	Approvisionnement chantier	sac	52.31	580.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	11.1
155	40	10	142	2	2	Approvisionnement chantier	m3	108.19	3299.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	30.5
156	40	10	127	2	2	Approvisionnement chantier	m2	134.11	22248.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	165.9
157	40	10	112	2	2	Approvisionnement chantier	sac	95.46	16151.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	169.2
158	41	10	141	2	2	Approvisionnement chantier	kg	66.56	1930.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	29
159	41	10	103	2	2	Approvisionnement chantier	m2	127.26	15538.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	122.1
160	41	10	133	2	2	Approvisionnement chantier	m3	131.38	2299.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.5
161	42	10	149	2	2	Approvisionnement chantier	piece	30.46	3789.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	124.4
162	42	10	144	2	2	Approvisionnement chantier	m2	138.43	13303.12	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	96.1
163	42	10	142	2	2	Approvisionnement chantier	piece	66.96	13318.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	198.9
164	42	10	132	2	2	Approvisionnement chantier	sac	89.56	17598.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	196.5
165	43	10	107	2	2	Approvisionnement chantier	m3	135.05	19784.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	146.5
166	43	10	119	2	2	Approvisionnement chantier	piece	24.31	393.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	16.2
167	43	10	122	2	2	Approvisionnement chantier	m3	48.43	5240.13	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	108.2
168	43	10	112	2	2	Approvisionnement chantier	kg	76.51	10711.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	140
169	44	10	114	2	2	Approvisionnement chantier	sac	32.36	4388.02	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	135.6
170	44	10	133	2	2	Approvisionnement chantier	piece	100.29	2958.56	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	29.5
171	44	10	142	2	2	Approvisionnement chantier	m2	84.17	14308.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	170
172	44	10	133	2	2	Approvisionnement chantier	m2	46.5	2222.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	47.8
173	45	10	134	2	2	Approvisionnement chantier	piece	47.31	6443.62	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	136.2
174	45	10	138	2	2	Approvisionnement chantier	m3	76.91	10498.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	136.5
175	45	10	114	2	2	Approvisionnement chantier	m2	97.92	16137.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	164.8
176	45	10	138	2	2	Approvisionnement chantier	piece	105.15	2103.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20
177	46	10	149	2	2	Approvisionnement chantier	sac	20.33	3826.11	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	188.2
178	46	10	106	2	2	Approvisionnement chantier	m3	147.02	10894.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	74.1
179	46	10	117	2	2	Approvisionnement chantier	m2	102.27	15708.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	153.6
180	47	10	123	2	2	Approvisionnement chantier	kg	38.17	5465.94	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	143.2
181	47	10	138	2	2	Approvisionnement chantier	m2	73.51	1933.31	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	26.3
182	47	10	113	2	2	Approvisionnement chantier	kg	147.89	15705.92	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	106.2
183	47	10	112	2	2	Approvisionnement chantier	piece	132.63	13329.31	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	100.5
184	48	10	139	2	2	Approvisionnement chantier	sac	61.28	7231.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	118
185	48	10	147	2	2	Approvisionnement chantier	kg	45.32	5207.27	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	114.9
186	48	10	129	2	2	Approvisionnement chantier	sac	42.73	7234.19	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	169.3
187	48	10	148	2	2	Approvisionnement chantier	kg	118.6	5420.02	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	45.7
188	49	10	130	2	2	Approvisionnement chantier	kg	37.59	2469.66	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	65.7
189	49	10	139	2	2	Approvisionnement chantier	kg	66.98	3221.74	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	48.1
190	49	10	115	2	2	Approvisionnement chantier	piece	129.68	16456.39	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	126.9
191	49	10	116	2	2	Approvisionnement chantier	m3	5.9	697.97	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	118.3
192	50	10	120	2	2	Approvisionnement chantier	m2	121.21	18096.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	149.3
193	50	10	114	2	2	Approvisionnement chantier	sac	80.51	531.37	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.6
194	50	10	109	2	2	Approvisionnement chantier	kg	26.55	1014.21	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.2
195	50	10	142	2	2	Approvisionnement chantier	kg	65.81	6949.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	105.6
196	50	10	105	2	2	Approvisionnement chantier	m3	98.22	844.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.6
197	51	10	128	2	2	Approvisionnement chantier	sac	27.17	228.23	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.4
198	51	10	118	2	2	Approvisionnement chantier	m3	46.12	1992.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	43.2
199	51	10	151	2	2	Approvisionnement chantier	m2	46.97	4776.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	101.7
200	51	10	118	2	2	Approvisionnement chantier	sac	94.69	10974.57	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	115.9
201	51	10	145	2	2	Approvisionnement chantier	m2	86.19	5774.73	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	67
202	51	10	127	2	2	Approvisionnement chantier	m3	93.63	12143.81	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	129.7
203	52	10	113	2	2	Approvisionnement chantier	kg	5.81	851.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	146.6
204	52	10	107	2	2	Approvisionnement chantier	sac	120.55	22277.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	184.8
205	52	10	128	2	2	Approvisionnement chantier	sac	134.57	12380.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	92
206	52	10	123	2	2	Approvisionnement chantier	kg	36.05	4571.14	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	126.8
207	52	10	114	2	2	Approvisionnement chantier	m2	122.02	22915.36	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	187.8
208	52	10	137	2	2	Approvisionnement chantier	piece	131.7	3173.97	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	24.1
209	53	10	103	2	2	Approvisionnement chantier	m3	107.47	806.02	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.5
210	53	10	140	2	2	Approvisionnement chantier	piece	136.17	18927.63	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	139
211	53	10	117	2	2	Approvisionnement chantier	sac	29.76	2830.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	95.1
212	53	10	126	2	2	Approvisionnement chantier	m2	93.91	4197.78	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	44.7
213	54	10	112	2	2	Approvisionnement chantier	sac	55.42	5691.63	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	102.7
214	54	10	109	2	2	Approvisionnement chantier	m3	55.66	4146.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	74.5
215	54	10	148	2	2	Approvisionnement chantier	m2	89.15	6980.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	78.3
216	54	10	128	2	2	Approvisionnement chantier	piece	94.37	7870.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	83.4
217	55	10	111	2	2	Approvisionnement chantier	sac	56.85	5639.52	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	99.2
218	55	10	129	2	2	Approvisionnement chantier	kg	100.6	10251.14	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	101.9
219	55	10	151	2	2	Approvisionnement chantier	m2	88.43	7348.53	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	83.1
220	55	10	105	2	2	Approvisionnement chantier	sac	133.94	14880.73	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	111.1
221	55	10	144	2	2	Approvisionnement chantier	kg	109.55	2103.36	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	19.2
222	55	10	134	2	2	Approvisionnement chantier	sac	26.5	1754.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	66.2
223	56	10	108	2	2	Approvisionnement chantier	m2	82.12	8540.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	104
224	56	10	115	2	2	Approvisionnement chantier	sac	51.83	9811.42	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	189.3
225	56	10	131	2	2	Approvisionnement chantier	m3	121.25	7844.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	64.7
226	56	10	151	2	2	Approvisionnement chantier	kg	26.58	2416.12	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	90.9
227	56	10	111	2	2	Approvisionnement chantier	m3	124.05	13757.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	110.9
228	57	10	136	2	2	Approvisionnement chantier	m3	50.94	5195.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	102
229	57	10	119	2	2	Approvisionnement chantier	kg	32.22	3753.63	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	116.5
230	57	10	143	2	2	Approvisionnement chantier	m3	72.03	2787.56	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.7
231	57	10	147	2	2	Approvisionnement chantier	piece	101.49	13345.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	131.5
232	57	10	150	2	2	Approvisionnement chantier	sac	99.64	1703.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.1
233	57	10	112	2	2	Approvisionnement chantier	kg	76.15	761.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	10
234	58	10	150	2	2	Approvisionnement chantier	m3	131.02	5738.68	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	43.8
235	58	10	119	2	2	Approvisionnement chantier	piece	80.51	3727.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	46.3
236	58	10	145	2	2	Approvisionnement chantier	kg	95.43	10296.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	107.9
237	58	10	115	2	2	Approvisionnement chantier	kg	58.39	1798.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	30.8
238	59	10	130	2	2	Approvisionnement chantier	kg	138.33	4924.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	35.6
239	59	10	148	2	2	Approvisionnement chantier	m2	39.59	1484.63	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	37.5
240	59	10	150	2	2	Approvisionnement chantier	sac	102.78	1541.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	15
241	59	10	115	2	2	Approvisionnement chantier	m2	12.76	2063.29	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	161.7
242	60	10	116	2	2	Approvisionnement chantier	piece	130.41	22404.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	171.8
243	60	10	127	2	2	Approvisionnement chantier	piece	105.72	15086.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	142.7
244	60	10	145	2	2	Approvisionnement chantier	kg	42.9	3629.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	84.6
245	60	10	110	2	2	Approvisionnement chantier	kg	134.58	24628.14	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	183
246	60	10	144	2	2	Approvisionnement chantier	m2	18.05	870.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	48.2
247	60	10	116	2	2	Approvisionnement chantier	m3	118.0	2371.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20.1
248	61	10	116	2	2	Approvisionnement chantier	kg	56.14	7309.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	130.2
249	61	10	111	2	2	Approvisionnement chantier	piece	113.15	9278.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	82
250	61	10	146	2	2	Approvisionnement chantier	kg	44.54	4641.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	104.2
251	61	10	107	2	2	Approvisionnement chantier	sac	76.89	6020.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	78.3
252	61	10	151	2	2	Approvisionnement chantier	piece	141.06	13654.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	96.8
253	62	10	115	2	2	Approvisionnement chantier	m3	22.11	3917.89	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	177.2
254	62	10	137	2	2	Approvisionnement chantier	piece	113.98	3704.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	32.5
255	62	10	128	2	2	Approvisionnement chantier	piece	14.85	1204.33	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	81.1
256	62	10	118	2	2	Approvisionnement chantier	m2	60.81	7576.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	124.6
257	62	10	107	2	2	Approvisionnement chantier	sac	70.45	8545.59	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	121.3
258	62	10	150	2	2	Approvisionnement chantier	m2	112.23	4904.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	43.7
259	63	10	107	2	2	Approvisionnement chantier	piece	58.26	10620.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	182.3
260	63	10	125	2	2	Approvisionnement chantier	sac	35.9	2372.99	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	66.1
261	63	10	113	2	2	Approvisionnement chantier	m3	110.11	10812.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	98.2
262	63	10	145	2	2	Approvisionnement chantier	sac	8.73	263.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	30.2
263	63	10	121	2	2	Approvisionnement chantier	sac	109.65	16535.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	150.8
264	63	10	118	2	2	Approvisionnement chantier	m3	113.98	8844.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	77.6
265	64	10	115	2	2	Approvisionnement chantier	sac	95.29	9910.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	104
266	64	10	103	2	2	Approvisionnement chantier	m3	137.01	1575.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	11.5
267	64	10	116	2	2	Approvisionnement chantier	kg	56.47	6386.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	113.1
268	64	10	119	2	2	Approvisionnement chantier	m3	138.42	5052.33	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	36.5
269	65	10	114	2	2	Approvisionnement chantier	sac	104.71	11120.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	106.2
270	65	10	116	2	2	Approvisionnement chantier	m3	129.82	2232.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.2
271	65	10	108	2	2	Approvisionnement chantier	kg	9.75	924.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	94.8
272	66	10	117	2	2	Approvisionnement chantier	sac	94.78	4094.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	43.2
273	66	10	142	2	2	Approvisionnement chantier	m3	47.81	6583.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	137.7
274	66	10	140	2	2	Approvisionnement chantier	m2	28.51	1987.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	69.7
\.


--
-- Data for Name: chantier_demande_materiel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_demande_materiel (id, chantier_id, ouvrier_id, materiau_id, validateur_id, create_uid, write_uid, description, urgence, state, date, note, create_date, write_date, quantite) FROM stdin;
257	43	47	105	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-04-09	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	43.1
258	43	41	150	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	62.6
259	43	44	143	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-05-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	65.2
260	43	41	146	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-05-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	56.4
261	43	41	132	\N	2	2	Besoin pour avancement travaux	urgente	refuse	2026-02-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	18.3
262	43	41	110	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-05-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	30.7
263	43	42	127	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-03-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	69.9
264	43	48	150	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-04-16	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.9
265	44	50	146	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-05-09	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	69.5
266	44	44	140	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-01-16	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	86.5
267	44	44	148	\N	2	2	Besoin pour avancement travaux	normale	soumis	2025-12-21	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	41.6
268	44	47	103	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21.6
269	44	42	109	\N	2	2	Besoin pour avancement travaux	urgente	soumis	2026-01-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	62.7
270	45	41	146	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-02-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	65.1
271	45	50	119	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-04-02	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	66.9
272	45	51	131	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	60.6
273	45	42	129	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-05-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	31.9
274	45	46	142	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-03-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
275	46	47	123	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-05-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	22.9
276	46	52	147	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-01-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.7
277	46	43	129	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-03-16	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	60.5
278	46	48	107	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-02-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	72.3
279	46	52	118	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-04-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	13.9
280	46	45	133	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-03-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	88.8
281	47	42	116	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	97.1
282	47	42	126	\N	2	2	Besoin pour avancement travaux	normale	valide	2025-12-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	83.2
283	47	48	109	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-03-10	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	97.4
284	47	50	134	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.4
285	47	48	119	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-02-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	84.3
286	47	44	117	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-02-16	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.2
287	47	49	136	\N	2	2	Besoin pour avancement travaux	urgente	brouillon	2026-01-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	82.9
288	47	49	142	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-04-21	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	13.6
289	48	50	118	\N	2	2	Besoin pour avancement travaux	urgente	valide	2025-12-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	96.4
290	48	45	128	\N	2	2	Besoin pour avancement travaux	normale	soumis	2025-12-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	27.9
291	48	44	123	\N	2	2	Besoin pour avancement travaux	urgente	soumis	2026-01-09	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.9
292	48	41	136	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-02-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	15.3
293	48	50	142	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-05-21	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	28.2
294	49	42	118	\N	2	2	Besoin pour avancement travaux	normale	refuse	2025-12-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	46.4
295	49	47	120	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-03-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	77.7
296	49	44	104	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-05-22	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	43.7
297	49	44	130	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-21	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	93.8
298	49	46	108	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-01-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	53.8
299	50	45	106	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	24
300	50	46	143	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	22.8
301	50	48	140	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-02-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	78.6
302	50	45	139	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-02-02	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	16.3
303	50	41	148	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-04-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.3
304	51	48	142	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-02-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	36
305	51	42	109	\N	2	2	Besoin pour avancement travaux	urgente	refuse	2026-04-03	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	23.6
306	51	49	110	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-05-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	79.1
307	51	43	137	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	66.1
308	51	44	131	\N	2	2	Besoin pour avancement travaux	urgente	soumis	2026-02-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	78.1
309	52	44	125	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-04-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	67.2
310	52	46	129	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-09	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	51.5
311	52	42	116	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21.3
312	52	44	120	\N	2	2	Besoin pour avancement travaux	normale	soumis	2025-12-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	11.6
313	52	45	141	\N	2	2	Besoin pour avancement travaux	urgente	brouillon	2026-02-10	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	87.9
314	53	43	109	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-02-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	55.5
315	53	45	114	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-01-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	52.7
316	53	45	113	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-01-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	48
317	53	41	130	\N	2	2	Besoin pour avancement travaux	urgente	brouillon	2026-02-03	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	61.6
318	53	49	135	\N	2	2	Besoin pour avancement travaux	normale	valide	2025-12-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	69.1
319	54	48	117	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-05-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	98.9
320	54	50	132	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-04-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	80.4
321	54	51	104	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-04-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	54.2
322	54	50	139	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-02-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	98.4
323	54	51	140	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-03-10	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	87.5
324	54	47	138	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-03-07	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	98.5
325	55	41	118	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-02-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	33
326	55	51	118	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-05-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.8
327	55	42	135	\N	2	2	Besoin pour avancement travaux	urgente	refuse	2026-01-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	90.2
328	55	48	110	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-02-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	60
329	55	42	122	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-04-22	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	94
330	55	47	107	\N	2	2	Besoin pour avancement travaux	normale	refuse	2025-12-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	43.5
331	55	43	111	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-02-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	89.5
332	55	44	126	\N	2	2	Besoin pour avancement travaux	normale	refuse	2025-12-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	32.9
333	56	42	104	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-03-01	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	27.3
334	56	44	151	\N	2	2	Besoin pour avancement travaux	urgente	soumis	2026-03-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	74.4
335	56	46	107	\N	2	2	Besoin pour avancement travaux	urgente	soumis	2026-01-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	47.3
336	56	45	147	\N	2	2	Besoin pour avancement travaux	urgente	brouillon	2026-01-03	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	80
337	56	47	126	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-01-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	87.4
338	56	50	113	\N	2	2	Besoin pour avancement travaux	urgente	brouillon	2026-05-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	89.9
339	57	52	140	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-04-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	78.2
340	57	50	134	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-01-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	51
341	57	41	116	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.1
342	57	47	130	\N	2	2	Besoin pour avancement travaux	urgente	brouillon	2026-01-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
343	57	45	128	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-04-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	16.1
344	57	50	127	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-05-21	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	70.8
345	58	48	126	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-03-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	49.7
346	58	51	145	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-01-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	86.7
347	58	50	138	\N	2	2	Besoin pour avancement travaux	urgente	refuse	2026-03-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	85.8
348	58	52	111	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-03-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	67.2
349	58	46	125	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-05-02	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	42.6
350	58	45	123	\N	2	2	Besoin pour avancement travaux	normale	soumis	2025-12-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	68.2
351	58	42	111	\N	2	2	Besoin pour avancement travaux	normale	valide	2025-12-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	31.9
352	59	43	133	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-03-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	44.5
353	59	45	122	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-01-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	30.1
354	59	47	128	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-09	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	82.2
355	59	46	141	\N	2	2	Besoin pour avancement travaux	normale	soumis	2025-12-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	41.7
356	59	49	117	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-03-10	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.1
357	60	45	116	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-01-07	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	44.4
358	60	43	142	\N	2	2	Besoin pour avancement travaux	urgente	brouillon	2026-02-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	84.5
359	60	52	104	\N	2	2	Besoin pour avancement travaux	urgente	valide	2026-04-01	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	47.7
360	60	46	121	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-04-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	19.2
361	60	44	143	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-03-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	36.4
362	60	48	103	\N	2	2	Besoin pour avancement travaux	normale	refuse	2026-02-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	68.1
363	60	49	136	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-01-09	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	60.7
364	61	48	131	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-03-09	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	80.3
365	61	43	118	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-01-07	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.5
366	61	51	146	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-03-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	34.1
367	61	44	152	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-01-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	79.5
368	61	49	137	\N	2	2	Besoin pour avancement travaux	urgente	brouillon	2026-01-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	33.1
369	61	41	129	\N	2	2	Besoin pour avancement travaux	normale	soumis	2025-12-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	91.7
370	62	52	149	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-04-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	85.4
371	62	41	122	\N	2	2	Besoin pour avancement travaux	normale	soumis	2026-03-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	69.9
372	62	50	105	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-03-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	41.9
373	62	52	126	\N	2	2	Besoin pour avancement travaux	normale	valide	2026-05-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	29.8
374	62	52	112	\N	2	2	Besoin pour avancement travaux	normale	brouillon	2026-02-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	54
\.


--
-- Data for Name: chantier_devis; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_devis (id, chantier_id, currency_id, create_uid, write_uid, name, state, date, date_validite, note, montant_ht, tva, montant_ttc, create_date, write_date) FROM stdin;
34	43	126	2	2	DEV/2025/0001	accepte	2025-12-03	2026-05-03	\N	79559.72	16707.54	96267.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
35	44	126	2	2	DEV/2025/0003	accepte	2026-04-11	2026-05-08	\N	229788.96	48255.68	278044.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
36	45	126	2	2	DEV/2025/0005	accepte	2026-01-15	2026-05-17	\N	192668.6	40460.41	233129.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
37	45	126	2	2	DEV/2025/0006	accepte	2026-04-10	2026-05-12	\N	182521.06	38329.42	220850.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
38	46	126	2	2	DEV/2025/0007	envoye	2025-12-18	2026-05-06	\N	165884.81	34835.81	200720.62	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
39	46	126	2	2	DEV/2025/0008	brouillon	2025-12-07	2026-05-08	\N	170104.49	35721.94	205826.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
40	47	126	2	2	DEV/2025/0009	accepte	2026-04-09	2026-05-10	\N	161392.1	33892.34	195284.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
41	48	126	2	2	DEV/2025/0011	accepte	2026-01-22	2026-05-14	\N	76533.61	16072.06	92605.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
42	49	126	2	2	DEV/2025/0013	brouillon	2026-02-21	2026-05-19	\N	156975.56	32964.87	189940.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
43	49	126	2	2	DEV/2025/0014	accepte	2026-02-25	2026-05-27	\N	102373.68	21498.47	123872.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
44	50	126	2	2	DEV/2025/0015	envoye	2025-12-15	2026-05-07	\N	112111.16	23543.34	135654.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
45	50	126	2	2	DEV/2025/0016	accepte	2026-02-17	2026-05-18	\N	164249.23	34492.34	198741.57	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
46	51	126	2	2	DEV/2025/0017	brouillon	2025-12-14	2026-05-17	\N	109919.24	23083.04	133002.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
47	52	126	2	2	DEV/2025/0019	envoye	2025-11-17	2026-05-23	\N	111761.01	23469.81	135230.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
48	52	126	2	2	DEV/2025/0020	brouillon	2026-01-12	2026-05-08	\N	213518.85	44838.96	258357.81	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
49	53	126	2	2	DEV/2025/0021	accepte	2026-01-28	2026-05-12	\N	166785.36	35024.93	201810.29	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
50	53	126	2	2	DEV/2025/0022	envoye	2025-12-11	2026-05-25	\N	63952.54	13430.03	77382.57	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
51	54	126	2	2	DEV/2025/0023	accepte	2026-05-01	2026-05-08	\N	51249.09	10762.31	62011.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
52	55	126	2	2	DEV/2025/0025	accepte	2026-02-01	2026-05-15	\N	160566.05	33718.87	194284.92	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
53	56	126	2	2	DEV/2025/0027	envoye	2026-02-26	2026-05-21	\N	116244.48	24411.34	140655.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
54	56	126	2	2	DEV/2025/0028	brouillon	2025-12-18	2026-05-20	\N	215088.56	45168.6	260257.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
55	57	126	2	2	DEV/2025/0029	accepte	2026-03-29	2026-05-07	\N	139827.09	29363.69	169190.78	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
56	58	126	2	2	DEV/2025/0031	accepte	2025-12-12	2026-05-11	\N	119427.65	25079.81	144507.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
57	59	126	2	2	DEV/2025/0033	accepte	2025-12-26	2026-05-19	\N	56190.16	11799.93	67990.09	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
58	60	126	2	2	DEV/2025/0035	envoye	2026-04-22	2026-05-15	\N	240750.25	50557.55	291307.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
59	60	126	2	2	DEV/2025/0036	accepte	2026-04-02	2026-05-03	\N	211289.61	44370.82	255660.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
60	61	126	2	2	DEV/2025/0037	accepte	2026-02-18	2026-05-03	\N	213127.99	44756.88	257884.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
61	61	126	2	2	DEV/2025/0038	envoye	2026-01-30	2026-05-30	\N	181439.93	38102.39	219542.32	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
62	62	126	2	2	DEV/2025/0039	accepte	2026-01-17	2026-05-20	\N	172110.39	36143.18	208253.57	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
63	62	126	2	2	DEV/2025/0040	accepte	2026-01-15	2026-05-17	\N	151650.69	31846.64	183497.33	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Data for Name: chantier_devis_ligne; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_devis_ligne (id, devis_id, sequence, create_uid, write_uid, type_ligne, name, unite, prix_unitaire, sous_total, create_date, write_date, quantite) FROM stdin;
186	34	10	2	2	materiau	Prestation materiau - lot 1	piece	10.61	1627.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	153.37
187	34	20	2	2	prestation	Prestation prestation - lot 2	h	11.8	1397.12	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	118.4
188	34	30	2	2	forfait	Prestation forfait - lot 3	m2	189.96	18376.73	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	96.74
189	34	40	2	2	forfait	Prestation forfait - lot 4	m2	418.98	58158.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	138.81
190	35	10	2	2	forfait	Prestation forfait - lot 1	h	487.32	65992.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	135.42
191	35	20	2	2	forfait	Prestation forfait - lot 2	h	364.68	64975.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	178.17
192	35	30	2	2	materiau	Prestation materiau - lot 3	piece	133.94	24584.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	183.55
193	35	40	2	2	forfait	Prestation forfait - lot 4	forfait	169.13	6587.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.95
194	35	50	2	2	prestation	Prestation prestation - lot 5	m3	23.6	4143.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	175.57
195	35	60	2	2	forfait	Prestation forfait - lot 6	h	183.86	24628.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	133.95
196	35	70	2	2	materiau	Prestation materiau - lot 7	piece	322.41	17065.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	52.93
197	35	80	2	2	main_oeuvre	Prestation main oeuvre - lot 8	piece	275.44	21812.09	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	79.19
198	36	10	2	2	prestation	Prestation prestation - lot 1	h	120.23	16228.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	134.98
199	36	20	2	2	main_oeuvre	Prestation main oeuvre - lot 2	m2	327.17	41311.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	126.27
200	36	30	2	2	main_oeuvre	Prestation main oeuvre - lot 3	piece	426.88	77743.39	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	182.12
201	36	40	2	2	materiau	Prestation materiau - lot 4	piece	76.81	6840.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	89.06
202	36	50	2	2	prestation	Prestation prestation - lot 5	forfait	65.52	6075.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	92.72
203	36	60	2	2	materiau	Prestation materiau - lot 6	piece	105.84	15412.42	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	145.62
204	36	70	2	2	forfait	Prestation forfait - lot 7	h	402.67	29056.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	72.16
205	37	10	2	2	materiau	Prestation materiau - lot 1	m2	433.15	65864.79	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	152.06
206	37	20	2	2	forfait	Prestation forfait - lot 2	h	256.99	32948.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	128.21
207	37	30	2	2	forfait	Prestation forfait - lot 3	piece	284.89	27779.62	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	97.51
208	37	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	h	244.22	10142.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	41.53
209	37	50	2	2	main_oeuvre	Prestation main oeuvre - lot 5	forfait	64.96	3364.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	51.8
210	37	60	2	2	forfait	Prestation forfait - lot 6	m3	362.6	42420.57	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	116.99
211	38	10	2	2	materiau	Prestation materiau - lot 1	m3	487.93	18756.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.44
212	38	20	2	2	main_oeuvre	Prestation main oeuvre - lot 2	forfait	408.54	43709.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	106.99
213	38	30	2	2	forfait	Prestation forfait - lot 3	h	162.73	1568.72	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.64
214	38	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	piece	63.2	8879.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	140.5
215	38	50	2	2	materiau	Prestation materiau - lot 5	m2	378.59	25168.66	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	66.48
216	38	60	2	2	materiau	Prestation materiau - lot 6	h	378.99	20181.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	53.25
217	38	70	2	2	prestation	Prestation prestation - lot 7	h	330.24	44060.62	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	133.42
218	38	80	2	2	materiau	Prestation materiau - lot 8	m3	50.06	3560.27	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	71.12
219	39	10	2	2	main_oeuvre	Prestation main oeuvre - lot 1	m2	470.54	64718.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	137.54
220	39	20	2	2	forfait	Prestation forfait - lot 2	h	73.51	6049.14	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	82.29
221	39	30	2	2	forfait	Prestation forfait - lot 3	h	470.92	82425.13	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	175.03
222	39	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	m3	187.33	16912.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	90.28
223	40	10	2	2	main_oeuvre	Prestation main oeuvre - lot 1	forfait	388.25	45009.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	115.93
224	40	20	2	2	forfait	Prestation forfait - lot 2	m2	418.21	63082.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	150.84
225	40	30	2	2	materiau	Prestation materiau - lot 3	m3	496.52	41523.97	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	83.63
226	40	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	h	369.95	11775.51	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	31.83
227	41	10	2	2	prestation	Prestation prestation - lot 1	forfait	37.18	5813.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	156.37
228	41	20	2	2	forfait	Prestation forfait - lot 2	forfait	297.08	12218.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	41.13
229	41	30	2	2	forfait	Prestation forfait - lot 3	piece	222.79	5420.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	24.33
230	41	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	m2	388.78	48018.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	123.51
231	41	50	2	2	materiau	Prestation materiau - lot 5	m3	100.82	862.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.55
232	41	60	2	2	materiau	Prestation materiau - lot 6	h	304.58	4200.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	13.79
233	42	10	2	2	main_oeuvre	Prestation main oeuvre - lot 1	m3	263.46	40997.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	155.61
234	42	20	2	2	forfait	Prestation forfait - lot 2	h	151.84	2102.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	13.85
235	42	30	2	2	prestation	Prestation prestation - lot 3	m2	136.21	18461.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	135.54
236	42	40	2	2	prestation	Prestation prestation - lot 4	piece	422.79	72554.99	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	171.61
237	42	50	2	2	main_oeuvre	Prestation main oeuvre - lot 5	piece	44.68	4006.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	89.67
238	42	60	2	2	prestation	Prestation prestation - lot 6	h	416.9	18852.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	45.22
239	43	10	2	2	prestation	Prestation prestation - lot 1	h	435.52	15630.81	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	35.89
240	43	20	2	2	forfait	Prestation forfait - lot 2	h	97.03	3169.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	32.66
241	43	30	2	2	materiau	Prestation materiau - lot 3	piece	225.95	19612.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	86.8
242	43	40	2	2	prestation	Prestation prestation - lot 4	h	14.16	2143.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	151.37
243	43	50	2	2	main_oeuvre	Prestation main oeuvre - lot 5	forfait	33.94	4230.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	124.64
244	43	60	2	2	main_oeuvre	Prestation main oeuvre - lot 6	h	402.43	57587.73	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	143.1
245	44	10	2	2	main_oeuvre	Prestation main oeuvre - lot 1	m2	152.77	29996.39	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	196.35
246	44	20	2	2	forfait	Prestation forfait - lot 2	m3	212.07	11895.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	56.09
247	44	30	2	2	materiau	Prestation materiau - lot 3	piece	365.3	48128.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	131.75
248	44	40	2	2	prestation	Prestation prestation - lot 4	piece	253.75	22091.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	87.06
249	45	10	2	2	main_oeuvre	Prestation main oeuvre - lot 1	h	442.11	50166.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	113.47
250	45	20	2	2	materiau	Prestation materiau - lot 2	piece	206.78	41242.27	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	199.45
251	45	30	2	2	main_oeuvre	Prestation main oeuvre - lot 3	m2	193.55	530.33	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	2.74
252	45	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	m3	80.18	722.42	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.01
253	45	50	2	2	materiau	Prestation materiau - lot 5	m2	354.49	14105.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	39.79
254	45	60	2	2	main_oeuvre	Prestation main oeuvre - lot 6	h	279.07	42502.36	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	152.3
255	45	70	2	2	main_oeuvre	Prestation main oeuvre - lot 7	m3	202.85	14980.47	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	73.85
256	46	10	2	2	forfait	Prestation forfait - lot 1	h	18.56	2436.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	131.25
257	46	20	2	2	forfait	Prestation forfait - lot 2	m3	20.26	4022.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	198.56
258	46	30	2	2	materiau	Prestation materiau - lot 3	piece	455.82	52186.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	114.49
259	46	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	m3	20.26	3404.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	168.06
260	46	50	2	2	forfait	Prestation forfait - lot 5	piece	212.23	15913.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	74.98
261	46	60	2	2	forfait	Prestation forfait - lot 6	piece	127.76	19243.21	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	150.62
262	46	70	2	2	forfait	Prestation forfait - lot 7	piece	335.6	2325.71	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.93
263	46	80	2	2	forfait	Prestation forfait - lot 8	piece	165.21	10386.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	62.87
264	47	10	2	2	forfait	Prestation forfait - lot 1	forfait	276.01	7305.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	26.47
265	47	20	2	2	main_oeuvre	Prestation main oeuvre - lot 2	m3	201.0	20518.08	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	102.08
266	47	30	2	2	main_oeuvre	Prestation main oeuvre - lot 3	piece	85.86	10923.97	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	127.23
267	47	40	2	2	materiau	Prestation materiau - lot 4	m2	194.21	13208.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	68.01
268	47	50	2	2	forfait	Prestation forfait - lot 5	h	64.01	6315.23	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	98.66
269	47	60	2	2	materiau	Prestation materiau - lot 6	h	356.93	53489.53	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	149.86
270	48	10	2	2	materiau	Prestation materiau - lot 1	m2	359.75	3190.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.87
271	48	20	2	2	materiau	Prestation materiau - lot 2	piece	250.41	44407.71	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	177.34
272	48	30	2	2	forfait	Prestation forfait - lot 3	piece	405.61	67736.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	167
273	48	40	2	2	forfait	Prestation forfait - lot 4	forfait	155.99	16823.52	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	107.85
274	48	50	2	2	materiau	Prestation materiau - lot 5	m3	249.45	41428.66	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	166.08
275	48	60	2	2	forfait	Prestation forfait - lot 6	m3	419.54	28453.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	67.82
276	48	70	2	2	materiau	Prestation materiau - lot 7	piece	57.75	9776.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	169.29
277	48	80	2	2	materiau	Prestation materiau - lot 8	h	44.25	1701.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.45
278	49	10	2	2	forfait	Prestation forfait - lot 1	m3	77.43	13985.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	180.62
279	49	20	2	2	prestation	Prestation prestation - lot 2	forfait	105.34	3372.99	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	32.02
280	49	30	2	2	prestation	Prestation prestation - lot 3	h	370.96	72719.29	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	196.03
281	49	40	2	2	forfait	Prestation forfait - lot 4	h	478.75	22965.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	47.97
282	49	50	2	2	forfait	Prestation forfait - lot 5	m2	464.59	20651.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	44.45
283	49	60	2	2	main_oeuvre	Prestation main oeuvre - lot 6	m3	464.98	17971.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.65
284	49	70	2	2	materiau	Prestation materiau - lot 7	m2	41.09	3404.72	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	82.86
285	49	80	2	2	forfait	Prestation forfait - lot 8	forfait	498.29	11714.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	23.51
286	50	10	2	2	prestation	Prestation prestation - lot 1	forfait	354.66	24992.89	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	70.47
287	50	20	2	2	prestation	Prestation prestation - lot 2	piece	357.54	1444.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.04
288	50	30	2	2	forfait	Prestation forfait - lot 3	forfait	329.48	21291.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	64.62
289	50	40	2	2	materiau	Prestation materiau - lot 4	m3	393.6	16224.19	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	41.22
290	51	10	2	2	forfait	Prestation forfait - lot 1	piece	142.27	26701.23	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	187.68
291	51	20	2	2	materiau	Prestation materiau - lot 2	forfait	15.1	930.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	61.63
292	51	30	2	2	forfait	Prestation forfait - lot 3	m3	122.87	12160.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	98.97
293	51	40	2	2	materiau	Prestation materiau - lot 4	piece	430.76	8619.51	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20.01
294	51	50	2	2	forfait	Prestation forfait - lot 5	forfait	79.21	2837.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	35.82
295	52	10	2	2	prestation	Prestation prestation - lot 1	forfait	72.02	2789.33	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.73
296	52	20	2	2	materiau	Prestation materiau - lot 2	m2	359.7	54580.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	151.74
297	52	30	2	2	main_oeuvre	Prestation main oeuvre - lot 3	forfait	92.49	1029.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	11.13
298	52	40	2	2	forfait	Prestation forfait - lot 4	h	101.36	11032.02	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	108.84
299	52	50	2	2	forfait	Prestation forfait - lot 5	forfait	480.54	91134.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	189.65
300	53	10	2	2	main_oeuvre	Prestation main oeuvre - lot 1	piece	383.55	25049.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	65.31
301	53	20	2	2	forfait	Prestation forfait - lot 2	forfait	334.85	15670.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	46.8
302	53	30	2	2	materiau	Prestation materiau - lot 3	piece	473.01	50035.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	105.78
303	53	40	2	2	materiau	Prestation materiau - lot 4	h	168.41	25488.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	151.35
304	54	10	2	2	main_oeuvre	Prestation main oeuvre - lot 1	piece	210.71	4882.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	23.17
305	54	20	2	2	main_oeuvre	Prestation main oeuvre - lot 2	forfait	475.15	38135.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	80.26
306	54	30	2	2	forfait	Prestation forfait - lot 3	h	462.62	69702.96	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	150.67
307	54	40	2	2	materiau	Prestation materiau - lot 4	m2	339.09	11325.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	33.4
308	54	50	2	2	prestation	Prestation prestation - lot 5	m3	329.01	4175.14	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	12.69
309	54	60	2	2	forfait	Prestation forfait - lot 6	m2	397.16	71723.12	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	180.59
310	54	70	2	2	materiau	Prestation materiau - lot 7	m2	264.34	15144.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	57.29
311	55	10	2	2	forfait	Prestation forfait - lot 1	forfait	321.64	31649.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	98.4
312	55	20	2	2	materiau	Prestation materiau - lot 2	m2	477.35	2558.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.36
313	55	30	2	2	main_oeuvre	Prestation main oeuvre - lot 3	h	446.82	18368.77	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	41.11
314	55	40	2	2	forfait	Prestation forfait - lot 4	piece	318.19	42357.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	133.12
315	55	50	2	2	main_oeuvre	Prestation main oeuvre - lot 5	m3	97.64	3003.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	30.76
316	55	60	2	2	main_oeuvre	Prestation main oeuvre - lot 6	h	222.19	41889.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	188.53
317	56	10	2	2	forfait	Prestation forfait - lot 1	m3	259.71	12268.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	47.24
318	56	20	2	2	main_oeuvre	Prestation main oeuvre - lot 2	m3	251.07	4514.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.98
319	56	30	2	2	main_oeuvre	Prestation main oeuvre - lot 3	forfait	364.48	4249.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	11.66
320	56	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	m3	206.54	22118.37	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	107.09
321	56	50	2	2	forfait	Prestation forfait - lot 5	h	118.92	9574.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	80.51
322	56	60	2	2	materiau	Prestation materiau - lot 6	forfait	371.29	66702.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	179.65
323	57	10	2	2	main_oeuvre	Prestation main oeuvre - lot 1	h	81.0	15589.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	192.46
324	57	20	2	2	prestation	Prestation prestation - lot 2	forfait	105.75	997.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.43
325	57	30	2	2	materiau	Prestation materiau - lot 3	h	16.37	1803.32	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	110.16
326	57	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	m3	401.15	37800.36	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	94.23
327	58	10	2	2	forfait	Prestation forfait - lot 1	m2	468.04	53028.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	113.3
328	58	20	2	2	main_oeuvre	Prestation main oeuvre - lot 2	m2	34.79	3920.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	112.7
329	58	30	2	2	prestation	Prestation prestation - lot 3	m2	287.54	40157.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	139.66
330	58	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	m2	457.42	79458.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	173.71
331	58	50	2	2	forfait	Prestation forfait - lot 5	h	23.2	1473.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	63.51
332	58	60	2	2	prestation	Prestation prestation - lot 6	h	149.89	24604.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	164.15
333	58	70	2	2	forfait	Prestation forfait - lot 7	forfait	364.41	38106.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	104.57
334	59	10	2	2	forfait	Prestation forfait - lot 1	h	439.53	52027.17	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	118.37
335	59	20	2	2	forfait	Prestation forfait - lot 2	h	115.11	5413.62	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	47.03
336	59	30	2	2	main_oeuvre	Prestation main oeuvre - lot 3	m2	287.07	28428.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	99.03
337	59	40	2	2	prestation	Prestation prestation - lot 4	piece	498.0	19870.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	39.9
338	59	50	2	2	prestation	Prestation prestation - lot 5	forfait	155.1	22156.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	142.85
339	59	60	2	2	materiau	Prestation materiau - lot 6	m3	376.06	52434.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	139.43
340	59	70	2	2	prestation	Prestation prestation - lot 7	h	35.81	5413.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	151.18
341	59	80	2	2	forfait	Prestation forfait - lot 8	h	142.98	25546.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	178.67
342	60	10	2	2	main_oeuvre	Prestation main oeuvre - lot 1	piece	151.23	6779.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	44.83
343	60	20	2	2	forfait	Prestation forfait - lot 2	piece	476.92	91010.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	190.83
344	60	30	2	2	prestation	Prestation prestation - lot 3	h	489.86	36127.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	73.75
345	60	40	2	2	forfait	Prestation forfait - lot 4	forfait	90.87	13392.42	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	147.38
346	60	50	2	2	main_oeuvre	Prestation main oeuvre - lot 5	h	152.08	28343.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	186.37
347	60	60	2	2	materiau	Prestation materiau - lot 6	piece	320.82	21815.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	68
348	60	70	2	2	prestation	Prestation prestation - lot 7	m3	47.81	1240.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.95
349	60	80	2	2	prestation	Prestation prestation - lot 8	h	237.03	14418.53	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	60.83
350	61	10	2	2	forfait	Prestation forfait - lot 1	forfait	341.54	23579.92	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	69.04
351	61	20	2	2	materiau	Prestation materiau - lot 2	m2	473.03	70997.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	150.09
352	61	30	2	2	prestation	Prestation prestation - lot 3	forfait	294.02	19728.74	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	67.1
353	61	40	2	2	materiau	Prestation materiau - lot 4	forfait	453.7	21518.99	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	47.43
354	61	50	2	2	prestation	Prestation prestation - lot 5	forfait	434.3	6075.86	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	13.99
355	61	60	2	2	prestation	Prestation prestation - lot 6	m2	252.89	39539.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	156.35
356	62	10	2	2	main_oeuvre	Prestation main oeuvre - lot 1	m3	217.29	40342.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	185.66
357	62	20	2	2	materiau	Prestation materiau - lot 2	m3	162.9	10811.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	66.37
358	62	30	2	2	forfait	Prestation forfait - lot 3	m2	86.59	16556.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	191.21
359	62	40	2	2	main_oeuvre	Prestation main oeuvre - lot 4	forfait	156.83	21990.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	140.22
360	62	50	2	2	forfait	Prestation forfait - lot 5	m2	343.43	31066.68	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	90.46
361	62	60	2	2	forfait	Prestation forfait - lot 6	m2	433.05	51342.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	118.56
362	63	10	2	2	prestation	Prestation prestation - lot 1	m3	452.9	88419.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	195.23
363	63	20	2	2	main_oeuvre	Prestation main oeuvre - lot 2	m2	139.26	17234.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	123.76
364	63	30	2	2	materiau	Prestation materiau - lot 3	m3	262.18	44851.13	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	171.07
365	63	40	2	2	prestation	Prestation prestation - lot 4	h	31.04	1145.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	36.89
\.


--
-- Data for Name: chantier_estimation_materiau; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_estimation_materiau (id, chantier_id, materiau_id, currency_id, create_uid, write_uid, note, montant_estime, create_date, write_date, quantite_estimee, quantite_manquante) FROM stdin;
384	43	148	126	2	2	\N	9358.71	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	399.1	48.9
385	43	135	126	2	2	\N	23028.33	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	313.4	6.2
386	43	119	126	2	2	\N	419.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	10.5	0.5
2	2	2	126	2	2	\N	0.00	2026-06-01 08:24:43.33006	2026-06-01 08:39:21.813107	1	0
387	43	107	126	2	2	\N	23225.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	488.9	102.5
388	43	128	126	2	2	\N	5400.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	350.1	89
389	43	146	126	2	2	\N	1820.51	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.2	2.8
390	43	103	126	2	2	\N	29098.72	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	415.7	83.6
391	43	131	126	2	2	\N	22734.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	334.1	82.6
392	44	106	126	2	2	\N	37618.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	403	110.1
393	44	128	126	2	2	\N	39788.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	399.6	42.5
394	44	119	126	2	2	\N	23249.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	367.7	82.7
395	44	144	126	2	2	\N	6757.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	232.6	68.6
396	44	116	126	2	2	\N	2189.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	178.7	43.2
397	44	121	126	2	2	\N	6033.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	175.9	44
398	44	105	126	2	2	\N	15475.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	221.4	20.2
399	44	134	126	2	2	\N	1320.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	188.7	24.2
400	44	139	126	2	2	\N	2727.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	40.9	3.2
401	44	137	126	2	2	\N	10417.81	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	310.9	35.1
402	44	124	126	2	2	\N	1379.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	110.1	22.4
403	44	152	126	2	2	\N	5940.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	256.2	54.3
404	45	108	126	2	2	\N	28804.74	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	383	86.9
405	45	104	126	2	2	\N	7636.89	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	104.2	4
406	45	132	126	2	2	\N	29398.66	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	425	112.1
407	45	151	126	2	2	\N	42154.02	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	451.8	5.3
408	45	119	126	2	2	\N	13799.39	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	324.8	63.4
409	45	131	126	2	2	\N	34324.88	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	369.3	29.2
410	45	126	126	2	2	\N	1236.58	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	24.7	5.8
411	45	116	126	2	2	\N	2102.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	84.8	1.4
412	45	127	126	2	2	\N	26442.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	278.2	35.9
413	45	147	126	2	2	\N	11944.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	212.3	3.8
414	45	136	126	2	2	\N	1474.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	24.1	2.9
415	45	129	126	2	2	\N	37377.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	394.4	9.3
416	46	119	126	2	2	\N	7054.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	191.8	46.6
417	46	131	126	2	2	\N	22301.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	246.2	71.5
418	46	125	126	2	2	\N	2697.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	27.8	5.6
419	46	111	126	2	2	\N	8336.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	454.6	82.5
420	46	112	126	2	2	\N	5376.94	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	88	6.2
421	46	121	126	2	2	\N	12314.27	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	197	17.4
422	46	107	126	2	2	\N	9808.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	232.7	7.9
423	46	132	126	2	2	\N	7061.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	102.3	30.6
424	46	142	126	2	2	\N	4751.92	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	74.8	20.6
425	46	150	126	2	2	\N	17432.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	197.9	16.2
426	46	143	126	2	2	\N	13824.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	422	110.7
427	46	105	126	2	2	\N	7601.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	218	61.1
428	47	131	126	2	2	\N	1809.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	26	1.2
429	47	111	126	2	2	\N	17953.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	389.5	101.2
430	47	109	126	2	2	\N	7620.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	93.6	26.2
431	47	108	126	2	2	\N	44669.53	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	478.6	99.5
432	47	130	126	2	2	\N	29340.57	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	331.2	64.5
433	47	124	126	2	2	\N	35869.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	412.1	72.5
434	47	117	126	2	2	\N	5683.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	495.3	68.4
435	47	145	126	2	2	\N	32916.29	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	360.3	3.8
436	48	136	126	2	2	\N	39057.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	401.7	90.6
437	48	137	126	2	2	\N	1806.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	188.4	55.1
438	48	149	126	2	2	\N	14570.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	160.8	1.9
439	48	121	126	2	2	\N	14441.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	290.6	56.7
440	48	123	126	2	2	\N	9292.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	96.6	19.8
441	48	141	126	2	2	\N	7861.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	336.1	86.5
442	48	122	126	2	2	\N	36483.74	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	394.2	89.1
443	48	104	126	2	2	\N	11444.42	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	138.4	0.1
444	48	132	126	2	2	\N	1675.81	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	181.4	26.8
445	48	145	126	2	2	\N	4838.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	104.3	19
446	49	109	126	2	2	\N	7947.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	399.7	14.3
447	49	147	126	2	2	\N	11704.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	417.3	94.4
448	49	111	126	2	2	\N	7758.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	231.5	30.9
449	49	120	126	2	2	\N	18847.77	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	258	68.1
450	49	118	126	2	2	\N	3677.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	140.6	32.8
451	49	149	126	2	2	\N	31978.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	336.3	51.6
452	49	142	126	2	2	\N	1705.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	223.5	12.5
453	49	145	126	2	2	\N	7589.78	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	399.2	36.7
454	49	123	126	2	2	\N	2300.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	319	92.7
455	49	105	126	2	2	\N	5563.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	58.7	4.1
456	49	114	126	2	2	\N	9162.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	337.8	92.5
457	50	113	126	2	2	\N	23165.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	268	13.4
458	50	105	126	2	2	\N	14820.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	269.5	49
459	50	138	126	2	2	\N	4217.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	89.2	4.4
460	50	129	126	2	2	\N	4111.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	120.7	18.7
461	50	149	126	2	2	\N	2641.92	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	482.5	143.9
462	50	137	126	2	2	\N	12762.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	203	22.9
463	50	111	126	2	2	\N	9228.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	205.6	34.6
464	50	127	126	2	2	\N	6410.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	241.8	43.6
465	50	117	126	2	2	\N	16475.91	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	453.2	79
466	50	104	126	2	2	\N	2835.59	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	245.6	37.1
467	50	147	126	2	2	\N	5712.71	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	290.4	27.5
468	51	144	126	2	2	\N	10781.53	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	463.4	17.2
469	51	120	126	2	2	\N	20833.58	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	326.8	20.4
470	51	141	126	2	2	\N	24559.77	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	419.8	111.1
471	51	137	126	2	2	\N	14629.36	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	424.6	6.9
472	51	122	126	2	2	\N	3870.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	442.5	118.5
473	51	132	126	2	2	\N	10562.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	123.6	14.5
474	51	150	126	2	2	\N	2679.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	384.8	8.6
475	51	143	126	2	2	\N	23595.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	441.6	69.8
476	51	138	126	2	2	\N	18263.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	195.7	39.2
477	51	116	126	2	2	\N	27614.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	400.5	41
478	51	152	126	2	2	\N	13269.81	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	467.5	12.2
479	52	132	126	2	2	\N	20513.32	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	219.7	54.3
480	52	118	126	2	2	\N	21208.97	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	352.5	30.9
481	52	120	126	2	2	\N	6320.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	118.1	12.1
482	52	112	126	2	2	\N	18110.68	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	271.4	30.5
483	52	138	126	2	2	\N	7281.92	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	101.1	5.7
484	52	140	126	2	2	\N	37374.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	375.1	54
485	52	150	126	2	2	\N	26803.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	293.6	24.9
486	52	125	126	2	2	\N	3209.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	172.3	37.1
487	52	105	126	2	2	\N	1316.1	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.7	0.6
488	52	146	126	2	2	\N	11297.02	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	315.9	26.5
489	53	144	126	2	2	\N	2368.37	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	91.5	17.6
490	53	103	126	2	2	\N	3758.36	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	171.1	1.6
491	53	128	126	2	2	\N	13184.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	202.9	23.8
492	53	149	126	2	2	\N	33861.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	413.1	7.1
493	53	114	126	2	2	\N	17858.96	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	450.1	1
494	53	123	126	2	2	\N	37438.23	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	389.9	90.9
495	53	143	126	2	2	\N	3717.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	53.9	1.3
496	53	106	126	2	2	\N	2134.72	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	36.9	9.3
497	53	108	126	2	2	\N	16514.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	270.5	26
498	53	147	126	2	2	\N	12982.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	205.9	11.6
499	53	148	126	2	2	\N	13567.36	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	218.8	65.1
500	53	113	126	2	2	\N	2491.04	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	160.3	31.9
501	54	106	126	2	2	\N	2694.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	226.3	59.2
502	54	147	126	2	2	\N	4877.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	136.2	9.1
503	54	136	126	2	2	\N	30968.92	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	362.6	36.4
504	54	130	126	2	2	\N	3085.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	100.5	14.6
505	54	109	126	2	2	\N	15156.09	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	498.3	77.3
506	54	120	126	2	2	\N	17299.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	275.7	12.5
507	54	122	126	2	2	\N	2604.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	35.8	0.5
508	54	121	126	2	2	\N	19918.96	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	392.5	6.6
509	54	137	126	2	2	\N	2407.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	28.7	6.1
510	54	112	126	2	2	\N	1442.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	216.1	49
511	55	105	126	2	2	\N	12161.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	470	88.3
512	55	129	126	2	2	\N	19232.73	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	447.6	127.5
513	55	108	126	2	2	\N	2415.23	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.7	0.3
514	55	107	126	2	2	\N	5513.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	186.1	42.4
515	55	128	126	2	2	\N	2984.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	38.5	3.8
516	55	115	126	2	2	\N	6169.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	317.5	80.5
517	55	117	126	2	2	\N	14075.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	155.8	11.9
518	55	118	126	2	2	\N	18699.21	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	313.8	22
519	55	124	126	2	2	\N	13251.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	454.1	17.5
520	55	148	126	2	2	\N	6589.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	84	4.7
521	56	149	126	2	2	\N	4526.21	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	203.2	0.8
522	56	124	126	2	2	\N	22771.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	327.2	96
523	56	148	126	2	2	\N	32698.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	485.1	55.7
524	56	131	126	2	2	\N	2611.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	125.8	5.2
525	56	112	126	2	2	\N	7779.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	182.6	49.9
526	56	134	126	2	2	\N	3798.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	102.8	21.6
527	56	105	126	2	2	\N	6323.19	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	68.1	7.9
528	56	129	126	2	2	\N	4453.39	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	330.7	95.7
529	56	132	126	2	2	\N	10982.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	276.9	75.4
530	56	120	126	2	2	\N	12561.12	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	201.5	24.3
531	56	115	126	2	2	\N	13294.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	481	74.3
532	57	110	126	2	2	\N	19319.27	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	201.1	6.4
533	57	137	126	2	2	\N	12551.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	471	107.2
534	57	103	126	2	2	\N	17883.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	385.8	112.5
535	57	124	126	2	2	\N	2973.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	353.8	78.4
536	57	122	126	2	2	\N	19218.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	472.2	17
537	57	109	126	2	2	\N	2960.29	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	245.6	42
538	57	134	126	2	2	\N	4759.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	119.5	18
539	57	105	126	2	2	\N	33210.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	433.4	122.4
540	57	147	126	2	2	\N	6264.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	140.3	6.7
541	58	120	126	2	2	\N	25156.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	295.9	88.4
542	58	118	126	2	2	\N	36281.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	432.4	89
543	58	133	126	2	2	\N	20645.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	335.7	22.7
544	58	145	126	2	2	\N	13635.79	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	443.5	0.6
545	58	117	126	2	2	\N	1922.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	49	4.2
546	58	129	126	2	2	\N	14042.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	205	32.9
547	58	106	126	2	2	\N	1092.95	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	29.1	6.1
548	58	136	126	2	2	\N	6714.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	82.5	10.6
549	59	105	126	2	2	\N	40295.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	424.9	82.5
550	59	118	126	2	2	\N	2632.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	160.4	31.1
551	59	137	126	2	2	\N	12180.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	175	16.4
552	59	106	126	2	2	\N	5706.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	315	59.9
553	59	141	126	2	2	\N	4847.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	108.2	21.6
554	59	112	126	2	2	\N	17376.17	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	485.9	20.2
555	59	125	126	2	2	\N	31927.53	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	319.3	74.7
556	59	108	126	2	2	\N	10787.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	238.8	14
557	59	139	126	2	2	\N	1826.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	207.4	47.9
558	59	128	126	2	2	\N	7312.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	92.6	4.3
559	59	143	126	2	2	\N	20288.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	325.7	29.7
560	59	121	126	2	2	\N	33686.56	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	439.2	78.6
561	60	147	126	2	2	\N	43218.66	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	457.4	73.7
562	60	136	126	2	2	\N	13611.13	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	266	33.3
563	60	130	126	2	2	\N	30612.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	472	102.3
564	60	119	126	2	2	\N	18110.19	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	264.4	67.9
565	60	121	126	2	2	\N	2641.13	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	352.6	17.7
566	60	104	126	2	2	\N	11792.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	342.7	15
567	60	139	126	2	2	\N	3224.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	207.6	10.9
568	60	110	126	2	2	\N	7808.31	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	137.8	12
569	60	103	126	2	2	\N	3250.37	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	109.9	8.5
570	60	116	126	2	2	\N	9541.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	494.2	71.9
571	60	150	126	2	2	\N	4412.66	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	240.2	40.5
572	60	152	126	2	2	\N	3576.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	185.4	52.5
573	61	135	126	2	2	\N	27671.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	409.8	67.2
574	61	143	126	2	2	\N	12187.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	308.2	23.4
575	61	103	126	2	2	\N	10964.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	489.1	41.4
576	61	114	126	2	2	\N	13832.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	467.6	122.2
577	61	151	126	2	2	\N	2699.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	69.2	11.3
578	61	123	126	2	2	\N	25541.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	490.4	114.2
579	61	112	126	2	2	\N	10745.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	278.8	8.2
580	61	124	126	2	2	\N	10365.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	187.1	17.3
581	62	149	126	2	2	\N	10411.97	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	180	33.9
582	62	109	126	2	2	\N	16178.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	471.4	63.9
583	62	114	126	2	2	\N	1763.91	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	344.4	47.8
584	62	125	126	2	2	\N	33425.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	420.3	63.5
585	62	126	126	2	2	\N	3141.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	273.9	25.6
586	62	111	126	2	2	\N	15315.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	187.4	32.8
587	62	136	126	2	2	\N	962.68	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	11.3	0.3
588	62	113	126	2	2	\N	8772.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	202.8	60.4
\.


--
-- Data for Name: chantier_estimation_outil; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_estimation_outil (id, chantier_id, outil_id, create_uid, write_uid, date_debut_prevue, date_fin_prevue, note, create_date, write_date) FROM stdin;
249	43	136	2	2	2026-02-21	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
2	2	2	2	2	2026-06-10	2026-06-17	\N	2026-06-01 08:45:30.333929	2026-06-01 08:46:57.707284
250	43	129	2	2	2026-04-16	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
251	43	107	2	2	2026-04-01	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
252	43	143	2	2	2026-03-18	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
253	43	112	2	2	2026-03-10	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
254	43	115	2	2	2026-03-07	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
255	43	124	2	2	2026-02-22	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
256	43	147	2	2	2026-04-17	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
257	44	126	2	2	2026-03-11	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
258	44	150	2	2	2026-03-21	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
259	44	133	2	2	2026-03-12	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
260	44	151	2	2	2026-02-24	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
261	44	143	2	2	2026-03-20	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
262	44	142	2	2	2026-04-17	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
263	45	103	2	2	2026-03-13	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
264	45	136	2	2	2026-05-14	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
265	45	117	2	2	2026-03-27	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
266	45	138	2	2	2026-05-05	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
267	46	147	2	2	2026-05-19	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
268	46	120	2	2	2026-05-13	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
269	46	108	2	2	2026-04-07	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
270	46	137	2	2	2026-02-27	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
271	46	103	2	2	2026-05-17	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
272	47	148	2	2	2026-04-09	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
273	47	151	2	2	2026-04-25	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
274	47	109	2	2	2026-04-04	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
275	47	103	2	2	2026-04-01	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
276	47	132	2	2	2026-04-13	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
277	47	110	2	2	2026-05-16	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
278	48	115	2	2	2026-03-25	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
279	48	108	2	2	2026-05-21	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
280	48	116	2	2	2026-04-16	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
281	48	145	2	2	2026-02-24	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
282	48	123	2	2	2026-03-25	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
283	48	128	2	2	2026-03-07	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
284	48	130	2	2	2026-03-03	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
285	48	129	2	2	2026-05-15	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
286	49	136	2	2	2026-04-09	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
287	49	150	2	2	2026-03-11	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
288	49	152	2	2	2026-04-09	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
289	49	110	2	2	2026-03-18	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
290	49	119	2	2	2026-03-13	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
291	49	149	2	2	2026-03-19	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
292	50	114	2	2	2026-04-18	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
293	50	107	2	2	2026-03-21	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
294	50	131	2	2	2026-05-09	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
295	50	144	2	2	2026-02-23	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
296	51	144	2	2	2026-04-24	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
297	51	103	2	2	2026-05-17	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
298	51	143	2	2	2026-03-03	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
299	51	150	2	2	2026-03-21	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
300	51	105	2	2	2026-03-26	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
301	51	114	2	2	2026-05-17	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
302	51	137	2	2	2026-04-17	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
303	52	140	2	2	2026-04-02	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
304	52	128	2	2	2026-04-09	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
305	52	113	2	2	2026-02-28	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
306	52	141	2	2	2026-03-04	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
307	52	138	2	2	2026-04-16	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
308	52	129	2	2	2026-03-07	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
309	53	139	2	2	2026-03-29	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
310	53	114	2	2	2026-03-21	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
311	53	112	2	2	2026-04-01	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
312	53	117	2	2	2026-05-16	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
313	53	113	2	2	2026-03-15	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
314	53	127	2	2	2026-04-18	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
315	53	109	2	2	2026-03-18	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
316	53	111	2	2	2026-03-10	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
317	54	138	2	2	2026-04-30	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
318	54	108	2	2	2026-03-25	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
319	54	123	2	2	2026-05-22	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
320	54	117	2	2	2026-05-22	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
321	54	149	2	2	2026-04-02	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
322	54	113	2	2	2026-05-08	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
323	54	134	2	2	2026-04-07	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
324	54	132	2	2	2026-03-04	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
325	55	121	2	2	2026-03-06	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
326	55	150	2	2	2026-02-25	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
327	55	105	2	2	2026-03-28	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
328	55	117	2	2	2026-02-26	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
329	56	104	2	2	2026-05-14	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
330	56	112	2	2	2026-03-19	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
331	56	135	2	2	2026-03-27	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
332	56	123	2	2	2026-05-02	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
333	57	129	2	2	2026-05-13	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
334	57	114	2	2	2026-05-07	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
335	57	124	2	2	2026-03-05	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
336	57	149	2	2	2026-05-06	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
337	58	137	2	2	2026-02-23	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
338	58	115	2	2	2026-04-27	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
339	58	111	2	2	2026-04-19	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
340	58	150	2	2	2026-03-06	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
341	58	135	2	2	2026-05-07	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
342	58	127	2	2	2026-05-19	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
343	58	125	2	2	2026-03-06	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
344	58	148	2	2	2026-03-03	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
345	59	123	2	2	2026-03-29	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
346	59	141	2	2	2026-04-24	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
347	59	131	2	2	2026-05-14	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
348	59	137	2	2	2026-04-17	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
349	59	114	2	2	2026-02-27	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
350	59	139	2	2	2026-02-28	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
351	60	124	2	2	2026-03-19	2026-05-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
352	60	111	2	2	2026-05-18	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
353	60	105	2	2	2026-03-25	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
354	60	144	2	2	2026-03-29	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
355	60	139	2	2	2026-04-22	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
356	60	151	2	2	2026-03-19	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
357	60	106	2	2	2026-04-10	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
358	60	113	2	2	2026-05-15	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
359	61	149	2	2	2026-05-14	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
360	61	151	2	2	2026-05-20	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
361	61	152	2	2	2026-04-12	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
362	61	125	2	2	2026-03-01	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
363	61	109	2	2	2026-03-19	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
364	61	112	2	2	2026-05-22	2026-05-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
365	61	103	2	2	2026-05-11	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
366	61	137	2	2	2026-04-14	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
367	62	121	2	2	2026-04-27	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
368	62	133	2	2	2026-05-11	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
369	62	119	2	2	2026-02-22	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
370	62	141	2	2	2026-04-13	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
371	62	117	2	2	2026-03-12	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
372	62	150	2	2	2026-05-01	2026-05-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
373	62	144	2	2	2026-03-24	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
374	62	110	2	2	2026-04-29	2026-05-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Data for Name: chantier_facture; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_facture (id, chantier_id, devis_id, currency_id, create_uid, write_uid, name, type_facture, state, date, date_echeance, note, montant_ht, tva, montant_total, create_date, write_date, pourcentage_avancement) FROM stdin;
128	43	34	126	2	2	FAC/2025/0001	avancement	envoyee	2026-05-19	2026-06-19	\N	9346.57	1962.78	11309.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.3
129	43	34	126	2	2	FAC/2025/0002	avancement	brouillon	2026-02-14	2026-06-30	\N	35352.05	7423.93	42775.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.8
130	43	34	126	2	2	FAC/2025/0003	avancement	brouillon	2026-03-31	2026-06-16	\N	48112.88	10103.7	58216.58	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	29.6
131	43	34	126	2	2	FAC/2025/0004	avancement	brouillon	2026-03-05	2026-05-28	\N	25755.61	5408.68	31164.29	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	19.1
132	44	35	126	2	2	FAC/2025/0005	avancement	brouillon	2026-01-30	2026-06-24	\N	38100.52	8001.11	46101.63	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21.5
133	44	35	126	2	2	FAC/2025/0006	avancement	payee	2026-04-20	2026-06-10	\N	47315.2	9936.19	57251.39	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	11.7
134	45	36	126	2	2	FAC/2025/0009	avancement	envoyee	2026-02-22	2026-06-20	\N	31865.68	6691.79	38557.47	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20.6
135	45	36	126	2	2	FAC/2025/0010	avancement	brouillon	2026-04-15	2026-06-03	\N	79716.78	16740.52	96457.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	10.9
136	45	37	126	2	2	FAC/2025/0013	avancement	payee	2026-01-16	2026-06-27	\N	36824.52	7733.15	44557.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21.5
137	45	37	126	2	2	FAC/2025/0014	avancement	payee	2026-01-21	2026-06-18	\N	5370.47	1127.8	6498.27	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	22.2
138	45	37	126	2	2	FAC/2025/0015	avancement	payee	2026-05-10	2026-06-30	\N	40297.93	8462.57	48760.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	11.9
139	46	38	126	2	2	FAC/2025/0017	avancement	brouillon	2026-05-20	2026-06-26	\N	33597.12	7055.4	40652.52	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.8
140	46	38	126	2	2	FAC/2025/0018	avancement	payee	2026-01-24	2026-06-05	\N	71076.38	14926.04	86002.42	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.8
141	46	38	126	2	2	FAC/2025/0019	avancement	payee	2026-03-19	2026-06-25	\N	47029.07	9876.1	56905.17	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	27.6
142	46	38	126	2	2	FAC/2025/0020	avancement	payee	2026-03-02	2026-06-18	\N	20321.86	4267.59	24589.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.6
143	46	39	126	2	2	FAC/2025/0021	avancement	brouillon	2026-03-21	2026-05-31	\N	60883.67	12785.57	73669.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	16
144	46	39	126	2	2	FAC/2025/0022	avancement	payee	2026-04-15	2026-06-26	\N	18968.88	3983.46	22952.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	29.5
145	46	39	126	2	2	FAC/2025/0023	avancement	payee	2026-03-30	2026-05-29	\N	50488.82	10602.65	61091.47	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	26.9
146	47	40	126	2	2	FAC/2025/0025	avancement	payee	2026-03-08	2026-06-03	\N	61915.72	13002.3	74918.02	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	15.1
147	47	40	126	2	2	FAC/2025/0026	avancement	envoyee	2026-03-29	2026-06-15	\N	76262.92	16015.21	92278.13	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	13.4
148	47	40	126	2	2	FAC/2025/0027	avancement	payee	2026-01-08	2026-06-25	\N	25624.23	5381.09	31005.32	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.6
149	47	40	126	2	2	FAC/2025/0028	avancement	brouillon	2026-03-02	2026-06-16	\N	22256.7	4673.91	26930.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	23.2
150	48	41	126	2	2	FAC/2025/0029	avancement	brouillon	2026-04-30	2026-06-02	\N	44582.56	9362.34	53944.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	18.3
151	48	41	126	2	2	FAC/2025/0030	avancement	payee	2026-04-16	2026-06-21	\N	40091.09	8419.13	48510.22	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	23.4
152	48	41	126	2	2	FAC/2025/0031	avancement	payee	2026-03-08	2026-05-29	\N	26420.43	5548.29	31968.72	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.4
153	49	42	126	2	2	FAC/2025/0033	avancement	payee	2026-01-29	2026-06-03	\N	66907.13	14050.5	80957.63	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	19.2
154	49	42	126	2	2	FAC/2025/0034	avancement	payee	2026-03-09	2026-06-04	\N	68209.22	14323.94	82533.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	10.4
155	49	42	126	2	2	FAC/2025/0035	avancement	payee	2026-04-27	2026-06-11	\N	52278.93	10978.58	63257.51	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	22.9
156	49	43	126	2	2	FAC/2025/0037	avancement	payee	2026-05-15	2026-06-28	\N	34625.28	7271.31	41896.59	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21.3
157	49	43	126	2	2	FAC/2025/0038	avancement	envoyee	2026-03-17	2026-06-08	\N	61835.7	12985.5	74821.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	22.6
158	49	43	126	2	2	FAC/2025/0039	avancement	payee	2026-04-21	2026-06-23	\N	43843.79	9207.2	53050.99	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	19.4
159	49	43	126	2	2	FAC/2025/0040	avancement	brouillon	2026-05-16	2026-05-30	\N	27469.76	5768.65	33238.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	19.4
160	49	43	126	2	2	FAC/2025/0041	avancement	payee	2026-03-23	2026-06-02	\N	6036.39	1267.64	7304.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.7
161	50	44	126	2	2	FAC/2025/0041	avancement	envoyee	2026-05-15	2026-06-17	\N	6398.66	1343.72	7742.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	10.8
162	50	44	126	2	2	FAC/2025/0042	avancement	payee	2026-04-13	2026-05-31	\N	76570.04	16079.71	92649.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	28.8
163	50	44	126	2	2	FAC/2025/0043	avancement	payee	2026-03-06	2026-06-30	\N	34058.63	7152.31	41210.94	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	15.7
164	50	44	126	2	2	FAC/2025/0044	avancement	envoyee	2026-01-18	2026-05-30	\N	22051.39	4630.79	26682.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.6
165	50	45	126	2	2	FAC/2025/0045	avancement	payee	2026-05-01	2026-06-21	\N	73829.94	15504.29	89334.23	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20.2
166	50	45	126	2	2	FAC/2025/0046	avancement	payee	2026-01-11	2026-05-31	\N	72012.26	15122.57	87134.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	18
167	50	45	126	2	2	FAC/2025/0047	avancement	envoyee	2026-05-25	2026-06-25	\N	49000.47	10290.1	59290.57	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21
168	51	46	126	2	2	FAC/2025/0049	avancement	payee	2026-03-25	2026-06-07	\N	62046.02	13029.66	75075.68	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	11.5
169	51	46	126	2	2	FAC/2025/0050	avancement	payee	2026-05-16	2026-06-25	\N	41208.97	8653.88	49862.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	26.4
170	51	46	126	2	2	FAC/2025/0051	avancement	envoyee	2026-05-01	2026-06-09	\N	43704.23	9177.89	52882.12	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	18.9
171	52	47	126	2	2	FAC/2025/0053	avancement	brouillon	2026-05-22	2026-06-23	\N	42811.24	8990.36	51801.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	28.6
172	52	47	126	2	2	FAC/2025/0054	avancement	envoyee	2026-01-05	2026-06-05	\N	71080.98	14927.01	86007.99	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	12
173	52	47	126	2	2	FAC/2025/0055	avancement	brouillon	2026-05-19	2026-06-18	\N	64395.51	13523.06	77918.57	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.1
174	52	47	126	2	2	FAC/2025/0056	avancement	payee	2026-04-04	2026-06-01	\N	43389.87	9111.87	52501.74	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21.7
175	52	47	126	2	2	FAC/2025/0057	avancement	brouillon	2026-04-30	2026-06-01	\N	48665.23	10219.7	58884.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	26.4
176	52	48	126	2	2	FAC/2025/0057	avancement	brouillon	2026-02-24	2026-05-28	\N	52317.52	10986.68	63304.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.6
177	52	48	126	2	2	FAC/2025/0058	avancement	payee	2026-03-08	2026-06-24	\N	10450.42	2194.59	12645.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25
178	53	49	126	2	2	FAC/2025/0061	avancement	payee	2026-04-25	2026-06-29	\N	50695.14	10645.98	61341.12	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	15.6
179	53	49	126	2	2	FAC/2025/0062	avancement	brouillon	2026-05-12	2026-06-12	\N	5602.93	1176.62	6779.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	23.6
180	53	50	126	2	2	FAC/2025/0065	avancement	envoyee	2026-01-15	2026-06-04	\N	74666.99	15680.07	90347.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	13
181	53	50	126	2	2	FAC/2025/0066	avancement	payee	2026-04-19	2026-06-16	\N	18036.39	3787.64	21824.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	24.3
182	53	50	126	2	2	FAC/2025/0067	avancement	brouillon	2026-02-20	2026-06-04	\N	39721.63	8341.54	48063.17	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	18.9
183	53	50	126	2	2	FAC/2025/0068	avancement	envoyee	2026-03-14	2026-06-16	\N	30668.22	6440.33	37108.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	19.6
184	54	51	126	2	2	FAC/2025/0069	avancement	brouillon	2026-04-15	2026-06-29	\N	17882.61	3755.35	21637.96	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20.2
185	54	51	126	2	2	FAC/2025/0070	avancement	envoyee	2026-02-11	2026-06-19	\N	64205.32	13483.12	77688.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	18.1
186	54	51	126	2	2	FAC/2025/0071	avancement	envoyee	2026-01-27	2026-07-01	\N	20921.77	4393.57	25315.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	22.9
187	55	52	126	2	2	FAC/2025/0073	avancement	envoyee	2026-05-22	2026-06-22	\N	54427.51	11429.78	65857.29	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	19.9
188	55	52	126	2	2	FAC/2025/0074	avancement	brouillon	2026-04-11	2026-06-18	\N	6619.41	1390.08	8009.49	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20.4
189	56	53	126	2	2	FAC/2025/0077	avancement	payee	2026-05-10	2026-06-04	\N	22953.46	4820.23	27773.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.2
190	56	53	126	2	2	FAC/2025/0078	avancement	payee	2026-03-09	2026-06-24	\N	49146.7	10320.81	59467.51	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	16.1
191	56	53	126	2	2	FAC/2025/0079	avancement	envoyee	2026-03-20	2026-06-28	\N	65001.76	13650.37	78652.13	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	27.9
192	56	53	126	2	2	FAC/2025/0080	avancement	brouillon	2026-01-27	2026-06-25	\N	51716.66	10860.5	62577.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	15.9
193	56	54	126	2	2	FAC/2025/0081	avancement	envoyee	2026-02-11	2026-06-05	\N	9645.43	2025.54	11670.97	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	13.9
194	56	54	126	2	2	FAC/2025/0082	avancement	envoyee	2026-03-20	2026-06-25	\N	47292.09	9931.34	57223.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.7
195	57	55	126	2	2	FAC/2025/0085	avancement	envoyee	2026-01-03	2026-06-10	\N	24703.01	5187.63	29890.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	19
196	57	55	126	2	2	FAC/2025/0086	avancement	payee	2026-01-27	2026-06-22	\N	76964.4	16162.52	93126.92	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	10.8
197	57	55	126	2	2	FAC/2025/0087	avancement	brouillon	2026-02-20	2026-06-04	\N	15619.06	3280.0	18899.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	26.1
198	58	56	126	2	2	FAC/2025/0089	avancement	payee	2026-01-18	2026-06-17	\N	29268.8	6146.45	35415.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.8
199	58	56	126	2	2	FAC/2025/0090	avancement	envoyee	2026-03-14	2026-06-14	\N	29008.73	6091.83	35100.56	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	27
200	58	56	126	2	2	FAC/2025/0091	avancement	brouillon	2026-01-14	2026-06-27	\N	15680.61	3292.93	18973.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.3
201	59	57	126	2	2	FAC/2025/0093	avancement	payee	2026-02-25	2026-06-24	\N	45365.49	9526.75	54892.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.7
202	59	57	126	2	2	FAC/2025/0094	avancement	payee	2026-02-17	2026-06-28	\N	67185.65	14108.99	81294.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	16.8
203	60	58	126	2	2	FAC/2025/0097	avancement	payee	2026-03-26	2026-06-25	\N	52428.12	11009.91	63438.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	24
204	60	58	126	2	2	FAC/2025/0098	avancement	payee	2026-04-15	2026-06-17	\N	23397.29	4913.43	28310.72	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21.7
205	60	58	126	2	2	FAC/2025/0099	avancement	envoyee	2026-03-28	2026-06-04	\N	67237.93	14119.97	81357.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20.2
206	60	58	126	2	2	FAC/2025/0100	avancement	payee	2026-04-20	2026-06-27	\N	54109.97	11363.09	65473.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21.2
207	60	59	126	2	2	FAC/2025/0101	avancement	payee	2026-01-24	2026-06-26	\N	66951.99	14059.92	81011.91	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	29.1
208	60	59	126	2	2	FAC/2025/0102	avancement	envoyee	2026-01-25	2026-06-21	\N	7388.79	1551.65	8940.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20
209	61	60	126	2	2	FAC/2025/0105	avancement	payee	2026-05-22	2026-06-02	\N	54073.55	11355.45	65429.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	27.3
210	61	60	126	2	2	FAC/2025/0106	avancement	envoyee	2026-01-21	2026-06-19	\N	30354.41	6374.43	36728.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	21.1
211	61	60	126	2	2	FAC/2025/0107	avancement	payee	2026-05-15	2026-06-15	\N	70915.19	14892.19	85807.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	25.7
212	61	61	126	2	2	FAC/2025/0109	avancement	payee	2026-05-20	2026-06-28	\N	63268.18	13286.32	76554.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.5
213	61	61	126	2	2	FAC/2025/0110	avancement	payee	2026-04-13	2026-06-10	\N	50522.9	10609.81	61132.71	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14
214	61	61	126	2	2	FAC/2025/0111	avancement	payee	2026-03-11	2026-06-15	\N	14269.97	2996.69	17266.66	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	15.3
215	61	61	126	2	2	FAC/2025/0112	avancement	payee	2026-01-18	2026-05-29	\N	19146.84	4020.84	23167.68	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	26.3
216	61	61	126	2	2	FAC/2025/0113	avancement	payee	2026-03-11	2026-06-17	\N	49968.32	10493.35	60461.67	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	14.7
217	62	62	126	2	2	FAC/2025/0113	avancement	envoyee	2026-05-17	2026-06-09	\N	8538.79	1793.15	10331.94	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	26
218	62	62	126	2	2	FAC/2025/0114	avancement	envoyee	2026-02-28	2026-06-08	\N	23405.93	4915.25	28321.18	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	28.4
219	62	63	126	2	2	FAC/2025/0117	avancement	payee	2026-03-19	2026-06-28	\N	25785.18	5414.89	31200.07	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	20.7
220	62	63	126	2	2	FAC/2025/0118	avancement	payee	2026-02-05	2026-06-08	\N	57137.96	11998.97	69136.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	24.6
221	62	63	126	2	2	FAC/2025/0119	avancement	brouillon	2026-02-14	2026-06-12	\N	67838.87	14246.16	82085.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	27.6
222	62	63	126	2	2	FAC/2025/0120	avancement	payee	2026-02-09	2026-06-18	\N	55088.35	11568.55	66656.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	17.3
\.


--
-- Data for Name: chantier_heure_prestee; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_heure_prestee (id, chantier_id, ouvrier_id, currency_id, validateur_id, create_uid, write_uid, description, state, date, note_refus, taux_horaire, montant, create_date, write_date, nb_heures) FROM stdin;
377	43	49	126	\N	2	2	\N	brouillon	2026-04-03	\N	15.5	114.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.4
378	43	47	126	\N	2	2	\N	valide	2026-01-30	\N	18.0	144.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
379	43	50	126	\N	2	2	\N	valide	2025-12-06	\N	15.5	119.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
380	43	50	126	\N	2	2	\N	valide	2026-03-13	\N	18.0	108.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6
381	43	41	126	\N	2	2	\N	valide	2026-03-01	\N	15.5	93.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6
382	43	52	126	\N	2	2	\N	valide	2026-02-03	\N	22.5	182.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.1
2	2	2	126	2	2	2	\N	valide	2026-06-01	\N	15.00	150.00	2026-06-01 08:24:43.33006	2026-06-01 08:36:44.561675	10
383	43	50	126	\N	2	2	\N	valide	2026-04-10	\N	17.5	134.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
384	43	47	126	\N	2	2	\N	brouillon	2026-01-23	\N	17.5	134.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
385	44	52	126	\N	2	2	\N	valide	2026-05-07	\N	22.5	139.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.2
386	44	49	126	\N	2	2	\N	brouillon	2026-05-31	\N	16.0	136.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.5
387	44	48	126	\N	2	2	\N	soumis	2025-12-24	\N	18.0	108.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6
388	44	46	126	\N	2	2	\N	valide	2026-03-06	\N	16.0	145.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.1
389	44	43	126	\N	2	2	\N	soumis	2026-02-22	\N	17.5	84.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.8
390	44	52	126	\N	2	2	\N	valide	2026-02-01	\N	22.5	94.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.2
391	44	44	126	\N	2	2	\N	soumis	2026-05-30	\N	15.5	134.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.7
392	45	50	126	\N	2	2	\N	soumis	2026-05-29	\N	16.0	80.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5
393	45	46	126	\N	2	2	\N	valide	2026-01-14	\N	18.0	144.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
394	45	50	126	\N	2	2	\N	brouillon	2026-02-01	\N	15.5	85.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.5
395	45	46	126	\N	2	2	\N	valide	2026-02-03	\N	17.5	150.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.6
396	45	52	126	\N	2	2	\N	valide	2026-03-15	\N	15.5	137.95	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.9
397	45	42	126	\N	2	2	\N	soumis	2026-02-19	\N	16.0	132.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.3
398	45	52	126	\N	2	2	\N	valide	2026-04-12	\N	20.0	154.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
399	45	51	126	\N	2	2	\N	brouillon	2026-01-30	\N	20.0	136.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.8
400	45	48	126	\N	2	2	\N	soumis	2026-03-17	\N	18.0	160.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.9
401	45	44	126	\N	2	2	\N	valide	2026-04-05	\N	22.5	150.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.7
402	45	48	126	\N	2	2	\N	brouillon	2026-01-16	\N	22.5	180.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
403	45	45	126	\N	2	2	\N	valide	2025-12-16	\N	15.5	113.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.3
404	46	43	126	\N	2	2	\N	valide	2026-04-29	\N	18.0	88.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.9
405	46	45	126	\N	2	2	\N	valide	2025-12-17	\N	22.5	211.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.4
406	46	51	126	\N	2	2	\N	soumis	2026-05-20	\N	18.0	109.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.1
407	46	49	126	\N	2	2	\N	brouillon	2026-04-28	\N	17.5	134.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
408	46	45	126	\N	2	2	\N	soumis	2025-12-08	\N	17.5	120.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.9
409	46	48	126	\N	2	2	\N	valide	2026-05-22	\N	15.5	110.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.1
410	46	52	126	\N	2	2	\N	brouillon	2026-04-19	\N	15.5	79.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.1
411	47	52	126	\N	2	2	\N	valide	2026-02-14	\N	15.5	83.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.4
412	47	49	126	\N	2	2	\N	soumis	2026-02-27	\N	15.5	97.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.3
413	47	52	126	\N	2	2	\N	valide	2026-05-12	\N	20.0	110.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.5
414	47	43	126	\N	2	2	\N	soumis	2026-01-31	\N	15.5	110.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.1
415	47	48	126	\N	2	2	\N	valide	2026-05-02	\N	17.5	155.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.9
416	47	44	126	\N	2	2	\N	valide	2026-02-21	\N	17.5	141.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.1
417	47	47	126	\N	2	2	\N	valide	2026-04-03	\N	15.5	106.95	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.9
418	47	42	126	\N	2	2	\N	valide	2026-02-19	\N	20.0	186.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.3
419	47	52	126	\N	2	2	\N	valide	2026-05-23	\N	20.0	148.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.4
420	47	48	126	\N	2	2	\N	brouillon	2026-01-23	\N	16.0	70.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.4
421	47	52	126	\N	2	2	\N	valide	2026-01-03	\N	16.0	100.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.3
422	47	41	126	\N	2	2	\N	brouillon	2026-02-19	\N	15.5	122.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.9
423	48	42	126	\N	2	2	\N	valide	2026-02-26	\N	20.0	86.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.3
424	48	43	126	\N	2	2	\N	valide	2026-03-25	\N	18.0	73.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.1
425	48	47	126	\N	2	2	\N	valide	2026-03-21	\N	16.0	136.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.5
426	48	52	126	\N	2	2	\N	valide	2026-03-27	\N	22.5	157.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7
427	48	46	126	\N	2	2	\N	soumis	2026-04-03	\N	16.0	147.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.2
428	48	47	126	\N	2	2	\N	brouillon	2026-04-13	\N	15.5	137.95	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.9
429	48	41	126	\N	2	2	\N	soumis	2026-01-13	\N	18.0	156.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.7
430	48	47	126	\N	2	2	\N	valide	2026-05-13	\N	15.5	142.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.2
431	48	51	126	\N	2	2	\N	valide	2026-03-04	\N	20.0	144.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.2
432	48	41	126	\N	2	2	\N	brouillon	2026-01-20	\N	22.5	153.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.8
433	48	42	126	\N	2	2	\N	valide	2026-02-22	\N	22.5	191.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.5
434	49	49	126	\N	2	2	\N	soumis	2025-12-09	\N	22.5	103.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.6
435	49	46	126	\N	2	2	\N	soumis	2026-02-19	\N	18.0	109.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.1
436	49	44	126	\N	2	2	\N	brouillon	2026-05-21	\N	15.5	66.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.3
437	49	51	126	\N	2	2	\N	valide	2025-12-21	\N	17.5	126.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.2
438	49	48	126	\N	2	2	\N	soumis	2026-04-02	\N	20.0	186.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.3
439	49	50	126	\N	2	2	\N	soumis	2026-03-05	\N	18.0	104.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.8
440	49	45	126	\N	2	2	\N	soumis	2026-01-29	\N	16.0	100.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.3
441	49	43	126	\N	2	2	\N	brouillon	2026-02-09	\N	20.0	124.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.2
442	49	50	126	\N	2	2	\N	brouillon	2026-01-05	\N	20.0	86.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.3
443	49	52	126	\N	2	2	\N	valide	2026-04-22	\N	16.0	147.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.2
444	49	49	126	\N	2	2	\N	valide	2026-03-10	\N	16.0	89.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.6
445	50	48	126	\N	2	2	\N	brouillon	2026-05-05	\N	20.0	162.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.1
446	50	44	126	\N	2	2	\N	valide	2026-03-03	\N	15.5	133.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.6
447	50	51	126	\N	2	2	\N	brouillon	2026-04-17	\N	18.0	127.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.1
448	50	50	126	\N	2	2	\N	brouillon	2026-03-13	\N	22.5	173.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
449	50	51	126	\N	2	2	\N	valide	2026-01-11	\N	17.5	157.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9
450	50	42	126	\N	2	2	\N	soumis	2026-02-06	\N	16.0	107.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.7
451	50	41	126	\N	2	2	\N	soumis	2026-02-17	\N	22.5	123.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.5
452	50	52	126	\N	2	2	\N	valide	2026-03-04	\N	15.5	86.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.6
453	51	42	126	\N	2	2	\N	soumis	2026-05-16	\N	22.5	191.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.5
454	51	45	126	\N	2	2	\N	valide	2026-02-10	\N	18.0	84.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.7
455	51	43	126	\N	2	2	\N	valide	2026-04-22	\N	16.0	107.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.7
456	51	41	126	\N	2	2	\N	brouillon	2026-05-24	\N	16.0	129.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.1
457	51	48	126	\N	2	2	\N	valide	2026-03-27	\N	17.5	115.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.6
458	51	51	126	\N	2	2	\N	soumis	2026-04-02	\N	22.5	173.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
459	51	45	126	\N	2	2	\N	valide	2026-05-23	\N	16.0	68.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.3
460	51	41	126	\N	2	2	\N	valide	2026-04-03	\N	20.0	182.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.1
461	51	45	126	\N	2	2	\N	valide	2025-12-09	\N	17.5	96.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.5
462	51	45	126	\N	2	2	\N	valide	2026-01-13	\N	15.5	102.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.6
463	51	41	126	\N	2	2	\N	valide	2026-05-12	\N	20.0	144.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.2
464	51	51	126	\N	2	2	\N	brouillon	2026-05-21	\N	16.0	128.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
465	52	49	126	\N	2	2	\N	soumis	2026-03-27	\N	15.5	147.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.5
466	52	46	126	\N	2	2	\N	brouillon	2026-01-07	\N	17.5	134.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
467	52	43	126	\N	2	2	\N	valide	2026-03-10	\N	20.0	110.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.5
468	52	44	126	\N	2	2	\N	valide	2026-02-23	\N	16.0	86.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.4
469	52	48	126	\N	2	2	\N	soumis	2026-02-05	\N	20.0	172.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.6
470	52	51	126	\N	2	2	\N	valide	2026-02-02	\N	15.5	89.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.8
471	52	46	126	\N	2	2	\N	valide	2026-04-07	\N	16.0	110.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.9
472	52	46	126	\N	2	2	\N	valide	2026-02-14	\N	18.0	120.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.7
473	52	46	126	\N	2	2	\N	soumis	2026-02-13	\N	18.0	81.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.5
474	52	46	126	\N	2	2	\N	valide	2025-12-13	\N	18.0	84.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.7
475	52	48	126	\N	2	2	\N	brouillon	2026-05-25	\N	18.0	140.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.8
476	52	45	126	\N	2	2	\N	valide	2025-12-31	\N	17.5	99.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.7
477	53	45	126	\N	2	2	\N	valide	2026-01-27	\N	20.0	92.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.6
478	53	47	126	\N	2	2	\N	valide	2026-04-29	\N	22.5	173.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
479	53	50	126	\N	2	2	\N	soumis	2026-03-16	\N	17.5	112.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.4
480	53	46	126	\N	2	2	\N	valide	2025-12-24	\N	16.0	136.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.5
481	53	44	126	\N	2	2	\N	valide	2026-03-19	\N	18.0	88.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.9
482	53	46	126	\N	2	2	\N	brouillon	2026-05-23	\N	18.0	171.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.5
483	53	49	126	\N	2	2	\N	valide	2026-05-26	\N	22.5	200.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.9
484	53	44	126	\N	2	2	\N	brouillon	2026-03-08	\N	16.0	131.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.2
485	53	43	126	\N	2	2	\N	valide	2025-12-23	\N	17.5	106.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.1
486	53	41	126	\N	2	2	\N	brouillon	2026-02-08	\N	17.5	140.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
487	53	51	126	\N	2	2	\N	brouillon	2026-02-17	\N	20.0	104.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.2
488	54	46	126	\N	2	2	\N	valide	2026-03-23	\N	15.5	113.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.3
489	54	48	126	\N	2	2	\N	brouillon	2026-03-07	\N	16.0	113.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.1
490	54	47	126	\N	2	2	\N	valide	2026-04-18	\N	20.0	100.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5
491	54	44	126	\N	2	2	\N	soumis	2026-05-05	\N	15.5	80.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.2
492	54	51	126	\N	2	2	\N	valide	2026-01-10	\N	17.5	131.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.5
493	54	50	126	\N	2	2	\N	valide	2025-12-12	\N	16.0	147.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.2
494	54	45	126	\N	2	2	\N	valide	2026-05-24	\N	18.0	102.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.7
495	54	47	126	\N	2	2	\N	valide	2025-12-08	\N	20.0	174.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.7
496	54	51	126	\N	2	2	\N	valide	2026-05-17	\N	22.5	153.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.8
497	54	52	126	\N	2	2	\N	valide	2025-12-16	\N	22.5	121.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.4
498	54	52	126	\N	2	2	\N	brouillon	2025-12-03	\N	20.0	118.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.9
499	55	52	126	\N	2	2	\N	valide	2025-12-12	\N	15.5	124.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
500	55	43	126	\N	2	2	\N	valide	2025-12-25	\N	18.0	122.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.8
501	55	47	126	\N	2	2	\N	valide	2026-01-27	\N	16.0	91.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.7
502	55	48	126	\N	2	2	\N	valide	2026-02-01	\N	18.0	144.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
503	55	44	126	\N	2	2	\N	valide	2026-02-04	\N	16.0	102.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.4
504	55	51	126	\N	2	2	\N	brouillon	2025-12-03	\N	17.5	92.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.3
505	55	42	126	\N	2	2	\N	valide	2025-12-19	\N	22.5	146.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.5
506	55	46	126	\N	2	2	\N	soumis	2026-01-24	\N	17.5	101.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.8
507	55	42	126	\N	2	2	\N	soumis	2026-04-01	\N	16.0	107.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.7
508	55	41	126	\N	2	2	\N	valide	2026-04-12	\N	15.5	128.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.3
509	56	43	126	\N	2	2	\N	valide	2026-02-24	\N	18.0	165.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.2
510	56	42	126	\N	2	2	\N	valide	2026-02-20	\N	20.0	124.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.2
511	56	52	126	\N	2	2	\N	valide	2026-04-27	\N	16.0	67.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.2
512	56	42	126	\N	2	2	\N	soumis	2026-05-28	\N	18.0	115.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.4
513	56	42	126	\N	2	2	\N	brouillon	2026-04-09	\N	18.0	79.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.4
514	56	47	126	\N	2	2	\N	valide	2026-01-29	\N	17.5	78.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.5
515	56	48	126	\N	2	2	\N	brouillon	2026-01-03	\N	17.5	106.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.1
516	56	47	126	\N	2	2	\N	valide	2025-12-05	\N	18.0	97.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.4
517	56	45	126	\N	2	2	\N	valide	2026-02-27	\N	17.5	110.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.3
518	56	49	126	\N	2	2	\N	valide	2026-04-20	\N	18.0	109.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.1
519	56	49	126	\N	2	2	\N	soumis	2025-12-04	\N	15.5	120.9	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.8
520	56	49	126	\N	2	2	\N	brouillon	2026-05-17	\N	17.5	145.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.3
521	57	47	126	\N	2	2	\N	valide	2026-03-10	\N	15.5	71.3	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.6
522	57	42	126	\N	2	2	\N	soumis	2026-02-18	\N	20.0	118.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.9
523	57	46	126	\N	2	2	\N	brouillon	2026-05-17	\N	18.0	144.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
524	57	50	126	\N	2	2	\N	soumis	2025-12-25	\N	20.0	90.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.5
525	57	52	126	\N	2	2	\N	valide	2026-03-09	\N	15.5	91.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.9
526	57	50	126	\N	2	2	\N	soumis	2026-03-28	\N	22.5	191.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.5
527	57	47	126	\N	2	2	\N	brouillon	2025-12-22	\N	17.5	73.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.2
528	57	41	126	\N	2	2	\N	valide	2026-04-09	\N	20.0	164.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.2
529	57	41	126	\N	2	2	\N	valide	2026-04-08	\N	17.5	112.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.4
530	57	41	126	\N	2	2	\N	brouillon	2026-04-05	\N	18.0	108.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6
531	57	42	126	\N	2	2	\N	valide	2026-03-25	\N	17.5	161.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.2
532	57	46	126	\N	2	2	\N	valide	2026-03-16	\N	18.0	126.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7
533	58	49	126	\N	2	2	\N	valide	2026-04-08	\N	18.0	122.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.8
534	58	45	126	\N	2	2	\N	brouillon	2025-12-28	\N	20.0	118.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.9
535	58	42	126	\N	2	2	\N	valide	2026-01-25	\N	22.5	200.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.9
536	58	41	126	\N	2	2	\N	soumis	2026-01-26	\N	18.0	138.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
537	58	50	126	\N	2	2	\N	valide	2026-04-09	\N	15.5	96.1	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.2
538	58	45	126	\N	2	2	\N	soumis	2026-03-06	\N	16.0	75.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.7
539	58	50	126	\N	2	2	\N	brouillon	2026-02-01	\N	20.0	150.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.5
540	58	48	126	\N	2	2	\N	valide	2025-12-15	\N	15.5	94.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.1
541	58	45	126	\N	2	2	\N	brouillon	2026-03-06	\N	15.5	91.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.9
542	59	51	126	\N	2	2	\N	valide	2026-04-18	\N	15.5	125.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.1
543	59	48	126	\N	2	2	\N	valide	2026-04-01	\N	20.0	128.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.4
544	59	43	126	\N	2	2	\N	valide	2026-01-12	\N	18.0	118.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.6
545	59	50	126	\N	2	2	\N	valide	2026-03-20	\N	22.5	157.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7
546	59	41	126	\N	2	2	\N	soumis	2026-05-26	\N	15.5	141.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.1
547	59	48	126	\N	2	2	\N	valide	2025-12-29	\N	22.5	182.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.1
548	59	47	126	\N	2	2	\N	valide	2026-05-17	\N	17.5	106.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.1
549	59	42	126	\N	2	2	\N	valide	2026-04-12	\N	18.0	108.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6
550	59	48	126	\N	2	2	\N	brouillon	2026-02-11	\N	22.5	182.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.1
551	59	48	126	\N	2	2	\N	valide	2026-04-09	\N	20.0	158.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.9
552	59	41	126	\N	2	2	\N	brouillon	2026-03-26	\N	16.0	137.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.6
553	59	46	126	\N	2	2	\N	valide	2026-04-10	\N	17.5	117.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.7
554	60	43	126	\N	2	2	\N	valide	2026-03-13	\N	15.5	130.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.4
555	60	41	126	\N	2	2	\N	valide	2026-01-23	\N	18.0	129.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.2
556	60	43	126	\N	2	2	\N	brouillon	2026-01-16	\N	17.5	157.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9
557	60	48	126	\N	2	2	\N	brouillon	2025-12-22	\N	18.0	84.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.7
558	60	43	126	\N	2	2	\N	valide	2026-04-28	\N	22.5	186.75	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.3
559	60	52	126	\N	2	2	\N	brouillon	2026-03-31	\N	17.5	91.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.2
560	60	42	126	\N	2	2	\N	valide	2026-01-09	\N	15.5	77.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5
561	60	44	126	\N	2	2	\N	valide	2026-03-15	\N	17.5	96.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.5
562	60	52	126	\N	2	2	\N	valide	2026-05-28	\N	20.0	180.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9
563	60	47	126	\N	2	2	\N	soumis	2026-03-01	\N	22.5	211.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	9.4
564	60	43	126	\N	2	2	\N	valide	2026-01-28	\N	18.0	154.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8.6
565	61	41	126	\N	2	2	\N	valide	2025-12-06	\N	17.5	70.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4
566	61	46	126	\N	2	2	\N	brouillon	2026-03-12	\N	17.5	94.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.4
567	61	43	126	\N	2	2	\N	valide	2025-12-06	\N	22.5	112.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5
568	61	51	126	\N	2	2	\N	brouillon	2026-05-08	\N	18.0	84.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.7
569	61	50	126	\N	2	2	\N	valide	2025-12-28	\N	16.0	113.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.1
570	61	50	126	\N	2	2	\N	valide	2026-02-17	\N	15.5	63.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.1
571	61	41	126	\N	2	2	\N	valide	2026-01-16	\N	22.5	90.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4
572	61	49	126	\N	2	2	\N	valide	2026-05-21	\N	20.0	160.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
573	61	43	126	\N	2	2	\N	soumis	2026-03-10	\N	20.0	84.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.2
574	61	45	126	\N	2	2	\N	valide	2025-12-06	\N	22.5	135.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6
575	61	43	126	\N	2	2	\N	brouillon	2026-01-30	\N	22.5	180.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8
576	61	47	126	\N	2	2	\N	valide	2026-01-03	\N	18.0	120.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.7
577	62	49	126	\N	2	2	\N	brouillon	2026-01-07	\N	17.5	84.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.8
578	62	48	126	\N	2	2	\N	valide	2026-02-07	\N	18.0	81.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.5
579	62	51	126	\N	2	2	\N	valide	2026-04-01	\N	16.0	97.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	6.1
580	62	48	126	\N	2	2	\N	brouillon	2025-12-23	\N	16.0	124.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.8
581	62	49	126	\N	2	2	\N	soumis	2026-02-14	\N	15.5	116.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.5
582	62	45	126	\N	2	2	\N	valide	2025-12-17	\N	22.5	108.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.8
583	62	48	126	\N	2	2	\N	valide	2025-12-12	\N	17.5	98.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5.6
584	62	41	126	\N	2	2	\N	brouillon	2026-05-04	\N	16.0	68.8	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.3
585	62	46	126	\N	2	2	\N	valide	2026-02-03	\N	20.0	154.0	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	7.7
586	62	45	126	\N	2	2	\N	valide	2026-02-25	\N	16.0	73.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4.6
\.


--
-- Data for Name: chantier_materiau; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_materiau (id, currency_id, create_uid, write_uid, name, ref_interne, categorie, unite, description, prix_unitaire, actif, create_date, write_date, stock_disponible, seuil_alerte) FROM stdin;
1	1	2	2	marteau pic	\N	isolation	piece	\N	0.00	t	2026-05-31 22:31:18.413232	2026-05-31 22:31:18.413232	0	0
103	126	2	2	Ciment Portland CEM I 52.5	MAT-001	beton	sac	\N	8.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	250	50
2	1	2	2	isolation	\N	autre	piece	\N	\N	t	2026-05-31 22:31:50.482033	2026-06-01 08:42:42.204015	37	\N
104	126	2	2	Ciment Portland CEM II 32.5	MAT-002	beton	sac	\N	7.2	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	180	40
105	126	2	2	Sable de rivière 0/4	MAT-003	beton	m3	\N	45.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	80	20
106	126	2	2	Gravier calcaire 4/20	MAT-004	beton	m3	\N	52.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	60	15
107	126	2	2	Béton prêt à l'emploi C25/30	MAT-005	beton	m3	\N	125.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	30	10
108	126	2	2	Bloc béton 39x19x19	MAT-006	beton	piece	\N	1.85	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	5000	500
109	126	2	2	Brique de parement rouge	MAT-007	beton	piece	\N	0.95	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	8000	1000
110	126	2	2	Brique de parement blanc	MAT-008	beton	piece	\N	1.05	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	4000	500
111	126	2	2	Planche pin 22x100mm	MAT-009	bois	m	\N	2.4	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	500	100
112	126	2	2	Planche épicéa 22x150mm	MAT-010	bois	m	\N	3.2	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	400	80
113	126	2	2	Chevron 60x80mm	MAT-011	bois	m	\N	4.8	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	600	100
114	126	2	2	Panneau OSB 18mm 250x122	MAT-012	bois	piece	\N	22.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	200	40
115	126	2	2	Contreplaqué bouleau 15mm	MAT-013	bois	piece	\N	38.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	100	20
116	126	2	2	Poutre HEA 200 acier S235	MAT-014	metal	m	\N	28.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	120	20
117	126	2	2	Poutre IPE 160 acier S235	MAT-015	metal	m	\N	18.7	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	150	30
118	126	2	2	Tube acier carré 50x50x3	MAT-016	metal	m	\N	9.2	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	200	40
119	126	2	2	Tige filetée M12 zinc	MAT-017	metal	m	\N	2.8	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	300	50
120	126	2	2	Tôle acier galvanisé 1mm	MAT-018	metal	m2	\N	14.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	180	30
121	126	2	2	Laine de verre 100mm	MAT-019	isolation	m2	\N	8.2	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	400	80
122	126	2	2	Laine de roche 80mm	MAT-020	isolation	m2	\N	9.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	350	60
123	126	2	2	Polystyrène expansé 60mm	MAT-021	isolation	m2	\N	6.8	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	500	100
124	126	2	2	Polyuréthane projeté	MAT-022	isolation	m2	\N	18.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	200	40
125	126	2	2	Membrane EPDM 1.2mm	MAT-023	toiture	m2	\N	22.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	400	80
126	126	2	2	Tuile béton rouge 40x30	MAT-024	toiture	piece	\N	1.2	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	3000	500
127	126	2	2	Ardoise naturelle 30x20	MAT-025	toiture	piece	\N	2.8	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	2000	400
128	126	2	2	Zinc toiture 0.8mm	MAT-026	toiture	m2	\N	35.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	150	30
129	126	2	2	Panne de toit 60x120mm	MAT-027	toiture	m	\N	5.6	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	300	50
130	126	2	2	Placo BA13 standard	MAT-028	finition	piece	\N	7.2	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	600	100
131	126	2	2	Placo BA13 hydro	MAT-029	finition	piece	\N	9.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	300	50
132	126	2	2	Enduit de façade blanc	MAT-030	finition	sac	\N	18.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	200	40
133	126	2	2	Peinture façade blanche 15L	MAT-031	finition	piece	\N	68.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	80	15
134	126	2	2	Carrelage grès cérame 60x60	MAT-032	finition	m2	\N	32.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	300	60
135	126	2	2	Parquet chêne massif 90mm	MAT-033	finition	m2	\N	85.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	200	40
136	126	2	2	Câble électrique 3G2.5mm	MAT-034	electricite	m	\N	1.85	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	1000	200
137	126	2	2	Câble électrique 3G6mm	MAT-035	electricite	m	\N	3.2	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	500	100
138	126	2	2	Tableau électrique 24 mod	MAT-036	electricite	piece	\N	145.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	30	5
139	126	2	2	Disjoncteur 16A courbe C	MAT-037	electricite	piece	\N	12.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	100	20
140	126	2	2	Gaine ICTA 20mm	MAT-038	electricite	m	\N	0.45	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	2000	300
141	126	2	2	Tuyau PVC pression 32mm	MAT-039	plomberie	m	\N	4.8	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	400	80
142	126	2	2	Tuyau cuivre 22mm	MAT-040	plomberie	m	\N	8.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	300	60
143	126	2	2	Raccord coude cuivre 22mm	MAT-041	plomberie	piece	\N	3.2	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	200	40
144	126	2	2	Robinet vanné 1/2 pouce	MAT-042	plomberie	piece	\N	18.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	60	10
145	126	2	2	Chasse d'eau 6/3L	MAT-043	plomberie	piece	\N	85.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	40	8
146	126	2	2	Ciment colle C2 25kg	MAT-044	beton	sac	\N	22.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	150	30
147	126	2	2	Joint silicone transparent	MAT-045	finition	piece	\N	5.8	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	120	20
148	126	2	2	Mortier de jointement gris	MAT-046	beton	sac	\N	12.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	100	20
149	126	2	2	Cheville Hilti M8x80	MAT-047	metal	piece	\N	0.85	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	500	100
150	126	2	2	Vis inox 5x70mm	MAT-048	metal	piece	\N	0.12	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	1000	200
151	126	2	2	Fenêtre PVC double vitrage	MAT-049	finition	piece	\N	380.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	50	10
152	126	2	2	Porte intérieure chêne 83x204	MAT-050	bois	piece	\N	285.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482	30	5
\.


--
-- Data for Name: chantier_outil; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_outil (id, currency_id, create_uid, write_uid, name, ref_interne, categorie, etat, date_achat, description, valeur_achat, actif, create_date, write_date) FROM stdin;
1	1	2	2	visseuse	\N	outillage_electrique	attribue	\N	\N	400.00	t	2026-05-31 22:32:45.844401	2026-05-31 22:33:24.762351
2	126	2	2	echafaudage	\N	levage	disponible	\N	\N	\N	f	2026-06-01 08:45:22.547871	2026-06-01 08:46:02.558615
103	126	2	2	Marteau-piqueur Hilti TE 500-AVR	OUT-001	outillage_electrique	disponible	2022-03-15	\N	1850.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
104	126	2	2	Marteau-piqueur Bosch GSH 16-30	OUT-002	outillage_electrique	disponible	2022-04-10	\N	1650.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
105	126	2	2	Foreuse Makita HR2630	OUT-003	outillage_electrique	disponible	2023-01-20	\N	420.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
106	126	2	2	Foreuse Hilti TE 7-C	OUT-004	outillage_electrique	disponible	2023-02-14	\N	680.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
107	126	2	2	Visseuse Milwaukee M18 FPD2	OUT-005	outillage_electrique	disponible	2023-05-08	\N	380.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
108	126	2	2	Visseuse Dewalt DCD996P2	OUT-006	outillage_electrique	disponible	2023-06-12	\N	420.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
109	126	2	2	Scie circulaire Festool TS 55	OUT-007	outillage_electrique	disponible	2022-08-22	\N	680.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
110	126	2	2	Scie circulaire Makita HS7611	OUT-008	outillage_electrique	disponible	2022-09-15	\N	220.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
111	126	2	2	Scie sauteuse Bosch GST 18V	OUT-009	outillage_electrique	disponible	2023-03-10	\N	280.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
112	126	2	2	Meuleuse Dewalt DCG412P2	OUT-010	outillage_electrique	disponible	2023-04-05	\N	320.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
113	126	2	2	Meuleuse Makita GA9020	OUT-011	outillage_electrique	disponible	2022-11-18	\N	180.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
114	126	2	2	Niveaux laser Leica Lino L4P1	OUT-012	mesure	disponible	2023-07-01	\N	950.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
115	126	2	2	Niveau laser Bosch GLL 3-80	OUT-013	mesure	disponible	2023-08-14	\N	580.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
116	126	2	2	Télémètre Leica DISTO D2	OUT-014	mesure	disponible	2022-06-30	\N	180.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
117	126	2	2	Niveau à bulle 120cm Stabila	OUT-015	mesure	disponible	2021-04-20	\N	85.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
118	126	2	2	Niveau à bulle 60cm Stanley	OUT-016	mesure	disponible	2021-05-10	\N	42.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
119	126	2	2	Echelle aluminium 3x12 échelons	OUT-017	levage	disponible	2021-09-05	\N	450.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
120	126	2	2	Echelle aluminium 2x8 échelons	OUT-018	levage	disponible	2021-10-12	\N	220.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
121	126	2	2	Echafaudage roulant 2m Zarges	OUT-019	levage	disponible	2022-01-18	\N	1200.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
122	126	2	2	Echafaudage roulant 4m Altrex	OUT-020	levage	disponible	2022-02-25	\N	1850.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
123	126	2	2	Nacelle ciseaux électrique	OUT-021	levage	disponible	2021-06-10	\N	18500.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
124	126	2	2	Chariot élévateur Toyota 2.5T	OUT-022	levage	disponible	2020-11-20	\N	25000.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
125	126	2	2	Bétonnière 350L Altrad	OUT-023	outillage_electrique	disponible	2021-03-14	\N	680.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
126	126	2	2	Bétonnière 160L Honda	OUT-024	outillage_electrique	disponible	2021-04-08	\N	420.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
127	126	2	2	Pompe à béton Atlas	OUT-025	outillage_electrique	disponible	2020-08-22	\N	8500.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
128	126	2	2	Compresseur d'air Michelin 50L	OUT-026	outillage_electrique	disponible	2022-07-15	\N	380.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
129	126	2	2	Compresseur d'air Fiac 100L	OUT-027	outillage_electrique	disponible	2022-08-20	\N	680.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
130	126	2	2	Cloueuse pneumatique Senco	OUT-028	outillage_electrique	disponible	2023-01-10	\N	320.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
131	126	2	2	Pistolet à colle Leister	OUT-029	outillage_electrique	disponible	2022-05-15	\N	185.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
132	126	2	2	Chalumeau gaz propane	OUT-030	outillage_electrique	disponible	2021-07-22	\N	95.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
133	126	2	2	Pelle ronde manche bois	OUT-031	outillage_main	disponible	2020-04-10	\N	28.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
134	126	2	2	Pelle carrée manche bois	OUT-032	outillage_main	disponible	2020-04-10	\N	26.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
135	126	2	2	Pioche manche bois	OUT-033	outillage_main	disponible	2020-05-15	\N	32.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
136	126	2	2	Brouette 90L acier galva	OUT-034	outillage_main	disponible	2020-06-20	\N	65.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
137	126	2	2	Brouette 80L acier galva	OUT-035	outillage_main	disponible	2020-07-10	\N	58.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
138	126	2	2	Taloche plastique 28x14cm	OUT-036	outillage_main	disponible	2020-08-05	\N	12.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
139	126	2	2	Truelle acier 28cm	OUT-037	outillage_main	disponible	2020-09-12	\N	18.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
140	126	2	2	Marteau de charpentier 600g	OUT-038	outillage_main	disponible	2020-10-18	\N	38.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
141	126	2	2	Masse 3kg manche fibre	OUT-039	outillage_main	disponible	2020-11-22	\N	45.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
142	126	2	2	Pince coupante 200mm	OUT-040	outillage_main	disponible	2020-12-15	\N	22.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
143	126	2	2	Casques de chantier Petzl	OUT-041	securite	disponible	2021-01-20	\N	35.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
144	126	2	2	Gilet haute visibilité classe 3	OUT-042	securite	disponible	2021-02-10	\N	18.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
145	126	2	2	Harnais anti-chute Petzl Avao	OUT-043	securite	disponible	2021-03-05	\N	285.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
146	126	2	2	Lunettes protection 3M	OUT-044	securite	disponible	2021-04-15	\N	12.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
147	126	2	2	Bouchons oreilles 3M 1100	OUT-045	securite	disponible	2021-05-20	\N	8.5	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
148	126	2	2	Détecteur multicâbles Bosch	OUT-046	mesure	disponible	2022-10-10	\N	120.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
149	126	2	2	Testeur réseau FLIR TA20	OUT-047	mesure	disponible	2022-11-05	\N	85.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
150	126	2	2	Thermomètre infrarouge Fluke	OUT-048	mesure	disponible	2023-02-20	\N	180.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
151	126	2	2	Tronçonneuse Stihl MS 261	OUT-049	outillage_electrique	disponible	2022-03-25	\N	680.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
152	126	2	2	Débroussailleuse Stihl FS 240	OUT-050	outillage_electrique	disponible	2022-04-18	\N	450.0	t	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Data for Name: chantier_paiement_fss; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_paiement_fss (id, chantier_id, ouvrier_id, currency_id, create_uid, write_uid, periode, state, reference_paiement, date, note, montant, create_date, write_date) FROM stdin;
1	2	6	126	2	2	Q1 2026	paye	FSS-0001	2026-01-28	\N	210.9	2026-06-01 11:23:44.878308	2026-06-01 11:23:44.878308
2	43	42	126	2	2	Q1 2025	paye	FSS-0001	2026-03-03	\N	274.47	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
3	43	46	126	2	2	Q2 2025	paye	FSS-0002	2026-03-12	\N	241.31	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
4	43	52	126	2	2	Q1 2026	paye	FSS-0003	2026-03-01	\N	147.89	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
5	43	43	126	2	2	Q1 2025	paye	FSS-0004	2026-02-28	\N	209.21	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
6	43	44	126	2	2	Q1 2026	paye	FSS-0005	2026-04-04	\N	90.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
7	43	45	126	2	2	Q1 2025	paye	FSS-0006	2026-03-31	\N	212.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
8	43	41	126	2	2	Q2 2025	paye	FSS-0007	2026-02-24	\N	280.56	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
9	44	51	126	2	2	Q1 2026	paye	FSS-0008	2026-05-25	\N	290.41	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
10	44	42	126	2	2	Q1 2026	paye	FSS-0009	2026-01-26	\N	156.36	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
11	44	44	126	2	2	Q4 2025	paye	FSS-0010	2026-04-24	\N	161.12	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
12	44	52	126	2	2	Q1 2026	paye	FSS-0011	2026-03-09	\N	173.97	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
13	44	41	126	2	2	Q1 2025	paye	FSS-0012	2026-01-19	\N	301.89	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
14	44	47	126	2	2	Q1 2026	paye	FSS-0013	2026-03-23	\N	98.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
15	45	51	126	2	2	Q2 2025	paye	FSS-0014	2025-12-17	\N	145.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
16	45	48	126	2	2	Q2 2025	paye	FSS-0015	2026-01-28	\N	193.7	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
17	45	41	126	2	2	Q2 2025	paye	FSS-0016	2026-05-14	\N	125.78	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
18	45	50	126	2	2	Q1 2026	paye	FSS-0017	2025-12-24	\N	141.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
19	45	45	126	2	2	Q1 2025	paye	FSS-0018	2026-05-01	\N	216.42	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
20	46	44	126	2	2	Q4 2025	paye	FSS-0019	2025-12-25	\N	223.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
21	46	49	126	2	2	Q1 2026	paye	FSS-0020	2026-04-18	\N	93.19	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
22	46	48	126	2	2	Q2 2025	a_payer	\N	2025-12-09	\N	135.86	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
23	46	45	126	2	2	Q1 2025	a_payer	\N	2025-12-27	\N	280.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
24	46	47	126	2	2	Q1 2025	a_payer	\N	2025-12-21	\N	114.56	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
25	46	52	126	2	2	Q4 2025	paye	FSS-0024	2026-03-02	\N	246.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
26	46	51	126	2	2	Q2 2025	paye	FSS-0025	2026-05-21	\N	189.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
27	47	46	126	2	2	Q1 2025	paye	FSS-0026	2026-05-01	\N	229.16	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
28	47	42	126	2	2	Q3 2025	paye	FSS-0027	2026-03-22	\N	293.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
29	47	47	126	2	2	Q1 2025	paye	FSS-0028	2026-04-21	\N	110.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
30	47	45	126	2	2	Q4 2025	paye	FSS-0029	2026-03-16	\N	109.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
31	48	44	126	2	2	Q1 2025	paye	FSS-0030	2026-05-10	\N	297.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
32	48	52	126	2	2	Q1 2026	paye	FSS-0031	2026-03-24	\N	138.68	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
33	48	49	126	2	2	Q4 2025	paye	FSS-0032	2026-04-20	\N	195.53	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
34	48	41	126	2	2	Q2 2025	a_payer	\N	2026-02-08	\N	301.62	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
35	48	50	126	2	2	Q1 2026	a_payer	\N	2026-01-15	\N	171.83	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
36	49	41	126	2	2	Q4 2025	paye	FSS-0035	2026-05-22	\N	106.15	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
37	49	46	126	2	2	Q4 2025	a_payer	\N	2026-05-02	\N	292.39	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
38	49	51	126	2	2	Q4 2025	a_payer	\N	2026-01-12	\N	269.89	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
39	49	48	126	2	2	Q3 2025	paye	FSS-0038	2026-02-08	\N	305.26	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
40	49	49	126	2	2	Q4 2025	paye	FSS-0039	2026-05-05	\N	206.73	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
41	49	47	126	2	2	Q2 2025	a_payer	\N	2026-01-26	\N	199.13	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
42	50	42	126	2	2	Q4 2025	paye	FSS-0041	2026-01-09	\N	316.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
43	50	48	126	2	2	Q2 2025	a_payer	\N	2025-12-19	\N	104.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
44	50	51	126	2	2	Q2 2025	paye	FSS-0043	2026-05-10	\N	303.02	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
45	50	41	126	2	2	Q4 2025	a_payer	\N	2026-03-27	\N	241.84	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
46	50	50	126	2	2	Q1 2025	a_payer	\N	2026-01-17	\N	272.47	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
47	51	43	126	2	2	Q4 2025	paye	FSS-0046	2025-12-21	\N	264.23	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
48	51	52	126	2	2	Q1 2025	paye	FSS-0047	2026-01-10	\N	134.31	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
49	51	48	126	2	2	Q2 2025	paye	FSS-0048	2026-04-10	\N	143.39	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
50	51	51	126	2	2	Q2 2025	paye	FSS-0049	2026-01-30	\N	304.38	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
51	52	52	126	2	2	Q1 2025	a_payer	\N	2026-02-13	\N	167.43	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
52	52	43	126	2	2	Q4 2025	a_payer	\N	2026-05-28	\N	259.37	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
53	52	46	126	2	2	Q1 2026	paye	FSS-0052	2026-04-02	\N	139.69	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
54	52	49	126	2	2	Q3 2025	paye	FSS-0053	2026-04-02	\N	272.6	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
55	52	45	126	2	2	Q3 2025	a_payer	\N	2025-12-31	\N	154.19	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
56	52	42	126	2	2	Q1 2025	paye	FSS-0055	2026-04-27	\N	119.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
57	53	42	126	2	2	Q2 2025	a_payer	\N	2026-05-30	\N	292.72	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
58	53	43	126	2	2	Q1 2025	a_payer	\N	2026-02-23	\N	136.12	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
59	53	52	126	2	2	Q1 2025	paye	FSS-0058	2026-04-19	\N	251.48	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
60	53	44	126	2	2	Q1 2025	paye	FSS-0059	2026-02-24	\N	182.76	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
61	53	46	126	2	2	Q1 2025	paye	FSS-0060	2026-03-02	\N	188.98	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
62	53	49	126	2	2	Q1 2025	paye	FSS-0061	2025-12-04	\N	283.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
63	54	48	126	2	2	Q1 2026	a_payer	\N	2026-04-17	\N	137.71	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
64	54	49	126	2	2	Q1 2026	paye	FSS-0063	2025-12-12	\N	120.28	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
65	54	44	126	2	2	Q2 2025	paye	FSS-0064	2026-02-19	\N	292.77	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
66	54	47	126	2	2	Q1 2025	a_payer	\N	2026-02-22	\N	114.14	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
67	54	43	126	2	2	Q2 2025	paye	FSS-0066	2026-04-05	\N	230.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
68	54	52	126	2	2	Q3 2025	paye	FSS-0067	2026-05-11	\N	158.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
69	55	51	126	2	2	Q1 2025	paye	FSS-0068	2025-12-23	\N	313.4	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
70	55	42	126	2	2	Q1 2025	paye	FSS-0069	2026-02-09	\N	204.12	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
71	55	47	126	2	2	Q1 2026	a_payer	\N	2026-03-26	\N	207.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
72	55	43	126	2	2	Q3 2025	paye	FSS-0071	2026-02-08	\N	144.86	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
73	55	48	126	2	2	Q1 2025	paye	FSS-0072	2026-04-27	\N	233.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
74	55	41	126	2	2	Q1 2026	a_payer	\N	2026-01-01	\N	167.61	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
75	56	50	126	2	2	Q3 2025	a_payer	\N	2026-05-22	\N	242.05	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
76	56	42	126	2	2	Q3 2025	paye	FSS-0075	2025-12-24	\N	158.65	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
77	56	49	126	2	2	Q3 2025	paye	FSS-0076	2026-03-05	\N	163.73	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
78	56	48	126	2	2	Q3 2025	paye	FSS-0077	2026-01-18	\N	181.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
79	56	44	126	2	2	Q4 2025	paye	FSS-0078	2026-04-28	\N	185.11	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
80	57	44	126	2	2	Q1 2025	paye	FSS-0079	2026-02-07	\N	194.09	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
81	57	52	126	2	2	Q3 2025	paye	FSS-0080	2026-04-27	\N	140.01	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
82	57	47	126	2	2	Q2 2025	paye	FSS-0081	2025-12-03	\N	107.24	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
83	57	49	126	2	2	Q1 2026	paye	FSS-0082	2026-02-24	\N	113.32	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
84	57	50	126	2	2	Q1 2025	paye	FSS-0083	2025-12-24	\N	238.45	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
85	57	45	126	2	2	Q3 2025	paye	FSS-0084	2026-05-23	\N	126.78	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
86	57	41	126	2	2	Q2 2025	paye	FSS-0085	2026-01-29	\N	201.27	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
87	58	47	126	2	2	Q2 2025	paye	FSS-0086	2026-05-29	\N	151.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
88	58	48	126	2	2	Q1 2025	paye	FSS-0087	2025-12-19	\N	151.82	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
89	58	46	126	2	2	Q1 2026	paye	FSS-0088	2026-05-25	\N	263.46	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
90	58	51	126	2	2	Q1 2026	a_payer	\N	2026-04-26	\N	314.37	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
91	59	43	126	2	2	Q1 2025	paye	FSS-0090	2026-02-10	\N	314.1	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
92	59	44	126	2	2	Q1 2026	paye	FSS-0091	2025-12-26	\N	219.77	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
93	59	41	126	2	2	Q1 2025	paye	FSS-0092	2026-01-14	\N	249.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
94	59	46	126	2	2	Q4 2025	paye	FSS-0093	2026-01-24	\N	227.06	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
95	59	45	126	2	2	Q4 2025	paye	FSS-0094	2026-02-06	\N	171.27	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
96	60	45	126	2	2	Q1 2025	a_payer	\N	2026-02-24	\N	290.55	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
97	60	49	126	2	2	Q1 2025	a_payer	\N	2026-04-19	\N	105.03	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
98	60	52	126	2	2	Q1 2026	a_payer	\N	2026-01-18	\N	255.99	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
99	60	48	126	2	2	Q1 2026	a_payer	\N	2026-02-21	\N	310.93	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
100	60	46	126	2	2	Q1 2025	paye	FSS-0099	2026-01-27	\N	217.17	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
101	60	43	126	2	2	Q4 2025	paye	FSS-0100	2026-01-17	\N	164.34	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
102	60	51	126	2	2	Q3 2025	a_payer	\N	2026-01-11	\N	294.85	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
103	61	52	126	2	2	Q4 2025	paye	FSS-0102	2026-05-22	\N	207.79	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
104	61	50	126	2	2	Q2 2025	paye	FSS-0103	2026-01-10	\N	180.47	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
105	61	47	126	2	2	Q1 2026	paye	FSS-0104	2026-05-05	\N	310.42	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
106	61	44	126	2	2	Q3 2025	paye	FSS-0105	2025-12-12	\N	198.35	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
107	61	48	126	2	2	Q4 2025	a_payer	\N	2026-03-28	\N	219.64	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
108	62	51	126	2	2	Q1 2025	paye	FSS-0107	2026-01-05	\N	86.87	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
109	62	44	126	2	2	Q3 2025	a_payer	\N	2026-04-09	\N	116.54	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
110	62	41	126	2	2	Q2 2025	paye	FSS-0109	2026-02-27	\N	286.5	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
111	62	50	126	2	2	Q3 2025	a_payer	\N	2026-03-10	\N	206.32	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
112	62	49	126	2	2	Q1 2026	paye	FSS-0111	2026-02-13	\N	223.25	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
113	62	43	126	2	2	Q1 2026	paye	FSS-0112	2026-05-23	\N	231.2	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
114	62	47	126	2	2	Q1 2025	paye	FSS-0113	2026-01-18	\N	145.44	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Data for Name: chantier_photo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_photo (id, chantier_id, auteur_id, create_uid, write_uid, name, date, description, create_date, write_date) FROM stdin;
261	43	55	2	2	Sanitaires installation	2026-02-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
262	43	56	2	2	Toiture pose ardoises	2026-05-07	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
263	43	41	2	2	Voirie accès chantier	2026-03-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
264	43	57	2	2	Escalier béton	2026-04-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
265	43	53	2	2	Façade Nord avancement	2026-04-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
266	43	41	2	2	Carrelage pose cuisine	2026-01-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
267	44	55	2	2	Vue générale chantier J1	2026-04-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
268	44	55	2	2	Voirie accès chantier	2025-12-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
269	44	56	2	2	Électricité tableau principal	2026-05-07	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
270	44	54	2	2	Sanitaires installation	2026-04-01	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
271	44	57	2	2	Voirie accès chantier	2025-12-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
272	44	53	2	2	Livraison matériaux bois	2025-12-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
273	44	53	2	2	Électricité tableau principal	2026-05-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
274	45	56	2	2	Escalier béton	2026-01-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
275	45	54	2	2	Vue drone chantier semaine 8	2025-12-03	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
276	45	54	2	2	Réunion de chantier	2026-05-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
277	45	54	2	2	Façade Nord avancement	2026-03-20	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
278	45	56	2	2	Intérieur séjour placo	2026-04-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
279	45	41	2	2	Escalier béton	2026-02-01	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
280	45	43	2	2	Structure R+1 terminée	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
281	46	54	2	2	Vue générale chantier J1	2026-03-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
282	46	55	2	2	Façade Nord avancement	2026-02-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
283	46	41	2	2	Carrelage pose cuisine	2025-11-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
284	46	41	2	2	Intérieur séjour placo	2025-12-21	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
285	46	43	2	2	Façade Nord avancement	2026-01-09	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
286	46	43	2	2	Escalier béton	2026-03-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
287	46	54	2	2	Voirie accès chantier	2026-03-20	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
288	47	43	2	2	Électricité tableau principal	2026-02-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
289	47	41	2	2	Sanitaires installation	2026-05-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
290	47	53	2	2	Livraison matériaux bois	2026-05-22	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
291	47	53	2	2	Intérieur séjour placo	2026-02-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
292	47	42	2	2	Toiture pose ardoises	2025-11-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
293	47	57	2	2	Voirie accès chantier	2025-12-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
294	48	41	2	2	Réunion de chantier	2026-01-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
295	48	41	2	2	Carrelage pose cuisine	2025-12-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
296	48	54	2	2	Réunion de chantier	2026-05-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
297	48	53	2	2	Toiture pose ardoises	2026-02-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
298	48	43	2	2	Intérieur séjour placo	2025-11-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
299	48	55	2	2	Carrelage pose cuisine	2026-05-10	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
300	48	54	2	2	Intérieur séjour placo	2026-05-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
301	49	54	2	2	Sanitaires installation	2026-01-20	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
302	49	56	2	2	Sanitaires installation	2026-04-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
303	49	57	2	2	Vue générale chantier J1	2026-03-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
304	49	53	2	2	Toiture pose ardoises	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
305	49	42	2	2	Structure R+1 terminée	2025-12-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
306	50	41	2	2	Sanitaires installation	2026-02-03	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
307	50	41	2	2	Peinture salon terminée	2026-03-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
308	50	56	2	2	Toiture pose ardoises	2026-03-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
309	50	55	2	2	Électricité tableau principal	2026-01-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
310	50	57	2	2	Vue drone chantier semaine 8	2026-01-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
311	50	56	2	2	Intérieur séjour placo	2025-12-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
312	50	54	2	2	Voirie accès chantier	2026-04-01	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
313	51	55	2	2	Façade Nord avancement	2026-04-02	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
314	51	55	2	2	Intérieur séjour placo	2025-11-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
315	51	54	2	2	Peinture salon terminée	2025-12-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
316	51	54	2	2	Voirie accès chantier	2026-02-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
317	51	42	2	2	Façade Nord avancement	2026-05-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
318	51	41	2	2	Voirie accès chantier	2026-02-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
319	52	56	2	2	Structure R+1 terminée	2026-03-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
320	52	42	2	2	Peinture salon terminée	2026-05-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
321	52	56	2	2	Réunion de chantier	2025-11-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
322	52	57	2	2	Toiture pose ardoises	2026-01-21	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
323	52	55	2	2	Carrelage pose cuisine	2025-12-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
324	52	55	2	2	Structure R+1 terminée	2025-11-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
325	52	55	2	2	Livraison matériaux bois	2026-03-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
326	53	57	2	2	Peinture salon terminée	2025-12-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
327	53	54	2	2	Voirie accès chantier	2026-05-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
328	53	53	2	2	Livraison matériaux bois	2025-11-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
329	53	43	2	2	Structure R+1 terminée	2026-01-22	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
330	53	56	2	2	Carrelage pose cuisine	2026-01-21	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
331	53	57	2	2	Fondations coulées	2025-12-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
332	53	43	2	2	Façade Nord avancement	2026-04-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
333	53	55	2	2	Vue générale chantier J1	2026-04-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
334	54	41	2	2	Escalier béton	2025-12-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
335	54	42	2	2	Voirie accès chantier	2026-05-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
336	54	54	2	2	Vue drone chantier semaine 8	2026-02-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
337	54	41	2	2	Électricité tableau principal	2025-11-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
338	54	57	2	2	Peinture salon terminée	2026-03-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
339	54	43	2	2	Livraison matériaux bois	2026-02-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
340	54	43	2	2	Structure R+1 terminée	2025-12-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
341	54	57	2	2	Intérieur séjour placo	2026-03-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
342	55	53	2	2	Sanitaires installation	2025-12-03	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
343	55	56	2	2	Toiture pose ardoises	2026-03-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
344	55	55	2	2	Vue générale chantier J1	2025-12-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
345	55	56	2	2	Livraison matériaux bois	2026-04-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
346	55	56	2	2	Peinture salon terminée	2026-05-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
347	55	56	2	2	Électricité tableau principal	2026-03-01	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
348	56	43	2	2	Toiture pose ardoises	2026-01-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
349	56	56	2	2	Électricité tableau principal	2026-01-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
350	56	54	2	2	Intérieur séjour placo	2026-03-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
351	56	41	2	2	Électricité tableau principal	2026-02-03	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
352	56	57	2	2	Livraison matériaux bois	2026-02-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
353	57	41	2	2	Électricité tableau principal	2026-04-20	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
354	57	53	2	2	Voirie accès chantier	2026-05-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
355	57	41	2	2	Façade Nord avancement	2025-12-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
356	57	56	2	2	Électricité tableau principal	2025-11-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
357	57	55	2	2	Vue générale chantier J1	2025-11-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
358	57	55	2	2	Livraison matériaux bois	2026-01-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
359	57	55	2	2	Électricité tableau principal	2025-12-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
360	57	57	2	2	Façade Nord avancement	2026-01-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
361	58	43	2	2	Structure R+1 terminée	2026-02-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
362	58	57	2	2	Peinture salon terminée	2026-05-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
363	58	43	2	2	Façade Nord avancement	2025-12-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
364	58	54	2	2	Intérieur séjour placo	2025-11-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
365	58	54	2	2	Voirie accès chantier	2026-01-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
366	58	56	2	2	Fondations coulées	2025-12-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
367	58	56	2	2	Escalier béton	2026-02-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
368	59	53	2	2	Fondations coulées	2026-05-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
369	59	53	2	2	Structure R+1 terminée	2025-12-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
370	59	57	2	2	Sanitaires installation	2026-01-20	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
371	59	54	2	2	Vue drone chantier semaine 8	2026-03-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
372	59	42	2	2	Intérieur séjour placo	2026-01-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
373	59	55	2	2	Toiture pose ardoises	2026-01-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
374	59	56	2	2	Carrelage pose cuisine	2025-12-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
375	60	54	2	2	Voirie accès chantier	2026-01-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
376	60	55	2	2	Intérieur séjour placo	2026-02-18	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
377	60	43	2	2	Électricité tableau principal	2026-03-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
378	60	42	2	2	Intérieur séjour placo	2026-01-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
379	60	57	2	2	Électricité tableau principal	2026-01-07	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
380	60	57	2	2	Vue drone chantier semaine 8	2026-05-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
381	60	42	2	2	Voirie accès chantier	2026-03-22	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
382	60	54	2	2	Peinture salon terminée	2026-04-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
383	61	43	2	2	Voirie accès chantier	2026-02-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
384	61	54	2	2	Intérieur séjour placo	2025-12-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
385	61	42	2	2	Voirie accès chantier	2026-03-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
386	61	56	2	2	Vue drone chantier semaine 8	2026-04-10	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
387	61	57	2	2	Électricité tableau principal	2025-11-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
388	61	41	2	2	Structure R+1 terminée	2026-03-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
389	61	42	2	2	Sanitaires installation	2026-05-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
390	62	54	2	2	Vue drone chantier semaine 8	2025-12-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
391	62	55	2	2	Réunion de chantier	2026-03-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
392	62	42	2	2	Voirie accès chantier	2026-02-01	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
393	62	42	2	2	Peinture salon terminée	2026-02-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
394	62	42	2	2	Vue drone chantier semaine 8	2026-05-09	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
395	62	42	2	2	Carrelage pose cuisine	2025-12-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
396	62	41	2	2	Réunion de chantier	2026-04-02	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Data for Name: chantier_plan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_plan (id, chantier_id, auteur_id, create_uid, write_uid, name, version, fichier_name, date, annotation, create_date, write_date) FROM stdin;
175	43	57	2	2	Plan d'implantation	v1	\N	2026-04-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
176	43	54	2	2	Plan R+1 architecte	v1	\N	2025-08-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
177	43	56	2	2	Plan plomberie étage	v1	\N	2026-02-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
178	44	54	2	2	Plan électricité RDC	v1	\N	2025-11-22	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
179	44	57	2	2	Plan électricité RDC	v1	\N	2025-08-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
180	44	53	2	2	Coupe AA architecte	v2	\N	2025-10-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
181	45	53	2	2	Coupe AA architecte	v2	\N	2025-09-20	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
182	45	57	2	2	Plan R+1 architecte	v1	\N	2026-05-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
183	45	56	2	2	Plan toiture	v1	\N	2026-01-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
184	45	53	2	2	Plan d'implantation	v1	\N	2025-10-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
185	45	53	2	2	Plan façades	v2	\N	2025-12-03	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
186	46	55	2	2	Plan façades	v2	\N	2026-03-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
187	46	55	2	2	Plan façades	v2	\N	2025-10-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
188	46	57	2	2	Plan d'implantation	v1	\N	2025-12-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
189	46	53	2	2	Plan plomberie étage	v1	\N	2026-01-30	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
190	46	53	2	2	Plan plomberie étage	v1	\N	2025-08-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
191	47	53	2	2	Plan R+1 architecte	v1	\N	2026-03-28	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
192	47	55	2	2	Plan de masse	v1	\N	2026-03-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
193	47	54	2	2	Plan de masse	v1	\N	2026-02-16	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
194	48	53	2	2	Plan de masse	v1	\N	2026-05-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
195	48	53	2	2	Plan électricité RDC	v1	\N	2026-04-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
196	48	54	2	2	Coupe AA architecte	v2	\N	2025-09-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
197	49	55	2	2	Plan d'implantation	v1	\N	2025-08-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
198	49	56	2	2	Plan façades	v2	\N	2026-05-09	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
199	49	53	2	2	Plan façades	v2	\N	2025-10-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
200	49	54	2	2	Plan R+1 architecte	v1	\N	2025-10-02	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
201	50	57	2	2	Plan structure béton	v3	\N	2025-09-07	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
202	50	57	2	2	Plan RDC architecte	v2	\N	2026-04-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
203	50	56	2	2	Plan électricité RDC	v1	\N	2026-04-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
204	51	55	2	2	Plan RDC architecte	v2	\N	2025-11-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
205	51	57	2	2	Plan électricité RDC	v1	\N	2025-11-15	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
206	51	57	2	2	Plan toiture	v1	\N	2026-02-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
207	51	56	2	2	Plan d'implantation	v1	\N	2026-03-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
208	51	53	2	2	Coupe AA architecte	v2	\N	2026-01-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
209	51	56	2	2	Plan façades	v2	\N	2026-05-24	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
210	52	55	2	2	Plan d'implantation	v1	\N	2026-01-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
211	52	53	2	2	Coupe AA architecte	v2	\N	2025-12-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
212	52	57	2	2	Plan structure béton	v3	\N	2026-02-02	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
213	52	57	2	2	Plan électricité RDC	v1	\N	2025-12-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
214	52	57	2	2	Plan structure béton	v3	\N	2025-12-20	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
215	52	54	2	2	Plan RDC architecte	v2	\N	2026-01-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
216	53	53	2	2	Plan électricité RDC	v1	\N	2026-04-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
217	53	53	2	2	Plan toiture	v1	\N	2025-10-17	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
218	53	53	2	2	Plan de masse	v1	\N	2026-01-01	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
219	53	54	2	2	Plan toiture	v1	\N	2026-02-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
220	53	57	2	2	Plan électricité RDC	v1	\N	2025-12-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
221	54	53	2	2	Plan de masse	v1	\N	2025-08-25	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
222	54	53	2	2	Plan électricité RDC	v1	\N	2025-09-12	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
223	54	53	2	2	Plan R+1 architecte	v1	\N	2025-10-10	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
224	55	56	2	2	Plan RDC architecte	v2	\N	2026-01-10	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
225	55	53	2	2	Plan RDC architecte	v2	\N	2026-02-01	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
226	55	57	2	2	Plan RDC architecte	v2	\N	2026-02-04	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
227	55	54	2	2	Plan électricité RDC	v1	\N	2026-01-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
228	56	55	2	2	Plan R+1 architecte	v1	\N	2026-03-01	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
229	56	55	2	2	Coupe AA architecte	v2	\N	2025-12-29	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
230	56	55	2	2	Plan toiture	v1	\N	2026-05-10	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
231	56	56	2	2	Plan de masse	v1	\N	2025-12-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
232	56	54	2	2	Plan structure béton	v3	\N	2026-03-10	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
233	56	54	2	2	Plan structure béton	v3	\N	2026-01-21	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
234	57	55	2	2	Plan toiture	v1	\N	2025-12-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
235	57	57	2	2	Plan d'implantation	v1	\N	2025-09-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
236	57	56	2	2	Plan R+1 architecte	v1	\N	2026-04-23	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
237	58	57	2	2	Plan de masse	v1	\N	2026-02-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
238	58	55	2	2	Plan plomberie étage	v1	\N	2025-11-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
239	58	54	2	2	Plan R+1 architecte	v1	\N	2026-01-22	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
240	58	53	2	2	Coupe AA architecte	v2	\N	2025-12-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
241	58	53	2	2	Plan électricité RDC	v1	\N	2025-11-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
242	59	57	2	2	Plan d'implantation	v1	\N	2026-03-22	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
243	59	57	2	2	Plan toiture	v1	\N	2025-10-06	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
244	59	55	2	2	Plan électricité RDC	v1	\N	2025-11-19	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
245	60	57	2	2	Plan de masse	v1	\N	2026-01-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
246	60	56	2	2	Plan toiture	v1	\N	2026-02-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
247	60	54	2	2	Plan RDC architecte	v2	\N	2025-08-13	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
248	60	53	2	2	Plan d'implantation	v1	\N	2026-02-14	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
249	60	54	2	2	Plan façades	v2	\N	2025-10-08	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
250	61	55	2	2	Plan plomberie étage	v1	\N	2025-11-16	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
251	61	55	2	2	Plan d'implantation	v1	\N	2025-10-11	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
252	61	53	2	2	Coupe AA architecte	v2	\N	2026-02-26	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
253	62	55	2	2	Plan façades	v2	\N	2025-11-16	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
254	62	55	2	2	Plan façades	v2	\N	2025-10-05	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
255	62	53	2	2	Plan R+1 architecte	v1	\N	2026-02-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
256	62	54	2	2	Plan de masse	v1	\N	2025-08-27	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
257	62	53	2	2	Plan électricité RDC	v1	\N	2025-08-31	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Data for Name: chantier_rapport_journalier; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_rapport_journalier (id, chantier_id, auteur_id, nb_ouvriers, create_uid, write_uid, meteo, date, travaux_realises, incidents, note, create_date, write_date) FROM stdin;
263	43	57	9	2	2	pluie	2026-03-06	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
264	43	57	8	2	2	nuageux	2026-04-11	Levage charpente métallique. Grue mobilisée. Météo favorable.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
265	43	55	9	2	2	soleil	2025-12-02	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
266	43	54	11	2	2	nuageux	2026-02-01	Plomberie salle de bain étage 2. Pose douche et WC. Conforme aux plans.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
267	43	55	11	2	2	soleil	2025-12-12	Levage charpente métallique. Grue mobilisée. Météo favorable.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
268	43	56	9	2	2	vent	2025-11-05	Bétonnage semelles filantes. Contrôle béton effectué par laborantin.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
269	43	54	5	2	2	soleil	2026-04-13	Travaux d'isolation thermique façade Sud. Conditions météo favorables.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
270	44	56	11	2	2	soleil	2025-08-08	Pose charpente bois. Livraison madriers retardée de 2h. 5 ouvriers présents.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
271	44	55	9	2	2	soleil	2025-10-11	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
272	44	53	5	2	2	soleil	2026-04-15	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
273	44	57	11	2	2	soleil	2026-02-09	Démolition cloisons existantes. Poussière importante, bâche mise en place.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
274	44	54	11	2	2	vent	2025-12-10	Pose charpente bois. Livraison madriers retardée de 2h. 5 ouvriers présents.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
275	45	53	12	2	2	vent	2026-05-04	Plomberie salle de bain étage 2. Pose douche et WC. Conforme aux plans.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
276	45	57	4	2	2	pluie	2026-03-18	Réception matériaux isolation. Contrôle quantités OK. Stockage en cours.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
277	45	57	5	2	2	pluie	2026-03-24	Bétonnage semelles filantes. Contrôle béton effectué par laborantin.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
278	45	57	3	2	2	soleil	2026-04-23	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
279	45	57	3	2	2	soleil	2026-01-08	Installation fenêtres double vitrage rez-de-chaussée. Travaux dans les délais.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
280	45	53	6	2	2	pluie	2026-05-15	Pose charpente bois. Livraison madriers retardée de 2h. 5 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
281	45	54	5	2	2	soleil	2025-10-10	Pose carrelage séjour et couloir. 3 carreleurs. Matériaux suffisants.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
282	46	53	7	2	2	vent	2026-03-29	Levage charpente métallique. Grue mobilisée. Météo favorable.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
283	46	53	6	2	2	nuageux	2026-01-27	Maçonnerie blocs béton mur Nord. Avancement conforme au planning. 6 ouvriers.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
284	46	54	7	2	2	nuageux	2026-01-14	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
285	46	57	3	2	2	vent	2025-08-07	Levage charpente métallique. Grue mobilisée. Météo favorable.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
286	46	54	6	2	2	nuageux	2026-05-23	Démolition cloisons existantes. Poussière importante, bâche mise en place.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
287	46	55	9	2	2	vent	2026-01-19	Pose charpente bois. Livraison madriers retardée de 2h. 5 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
288	47	55	9	2	2	nuageux	2026-02-25	Maçonnerie blocs béton mur Nord. Avancement conforme au planning. 6 ouvriers.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
289	47	53	11	2	2	nuageux	2025-12-15	Plomberie salle de bain étage 2. Pose douche et WC. Conforme aux plans.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
290	47	55	3	2	2	soleil	2025-11-27	Pose carrelage séjour et couloir. 3 carreleurs. Matériaux suffisants.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
291	47	54	11	2	2	vent	2025-10-11	Démolition cloisons existantes. Poussière importante, bâche mise en place.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
292	47	54	9	2	2	soleil	2026-04-12	Bétonnage semelles filantes. Contrôle béton effectué par laborantin.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
293	48	57	7	2	2	vent	2025-10-04	Bétonnage semelles filantes. Contrôle béton effectué par laborantin.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
294	48	53	7	2	2	soleil	2026-05-22	Démolition cloisons existantes. Poussière importante, bâche mise en place.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
295	48	55	5	2	2	soleil	2026-02-07	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
296	48	53	5	2	2	soleil	2026-03-08	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
297	48	57	6	2	2	vent	2026-05-25	Travaux d'isolation thermique façade Sud. Conditions météo favorables.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
298	48	56	4	2	2	soleil	2025-12-17	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
299	48	57	12	2	2	vent	2025-11-08	Démolition cloisons existantes. Poussière importante, bâche mise en place.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
300	48	54	9	2	2	soleil	2025-11-12	Pose charpente bois. Livraison madriers retardée de 2h. 5 ouvriers présents.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
301	49	54	3	2	2	nuageux	2025-12-24	Installation fenêtres double vitrage rez-de-chaussée. Travaux dans les délais.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
302	49	53	12	2	2	nuageux	2026-01-28	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
303	49	56	8	2	2	soleil	2026-04-08	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
304	49	57	3	2	2	nuageux	2026-05-04	Réception matériaux isolation. Contrôle quantités OK. Stockage en cours.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
305	49	55	11	2	2	vent	2026-04-17	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
306	49	53	5	2	2	soleil	2026-04-17	Réception matériaux isolation. Contrôle quantités OK. Stockage en cours.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
307	50	56	5	2	2	soleil	2026-03-09	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
308	50	55	4	2	2	nuageux	2026-05-31	Pose bardage bois façade Est. Profils fixés. 4 menuisiers présents.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
309	50	57	10	2	2	soleil	2025-11-01	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
310	50	53	9	2	2	pluie	2025-10-13	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
311	50	57	8	2	2	pluie	2026-02-12	Maçonnerie blocs béton mur Nord. Avancement conforme au planning. 6 ouvriers.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
312	50	56	9	2	2	soleil	2026-04-27	Pose carrelage séjour et couloir. 3 carreleurs. Matériaux suffisants.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
313	50	53	7	2	2	soleil	2026-03-15	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
314	51	54	7	2	2	soleil	2026-01-15	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
315	51	57	5	2	2	nuageux	2025-10-30	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
316	51	56	6	2	2	nuageux	2025-10-24	Pose charpente bois. Livraison madriers retardée de 2h. 5 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
317	51	54	6	2	2	vent	2025-11-21	Démolition cloisons existantes. Poussière importante, bâche mise en place.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
318	51	53	6	2	2	pluie	2025-11-21	Travaux d'isolation thermique façade Sud. Conditions météo favorables.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
319	51	53	4	2	2	soleil	2025-10-07	Pose carrelage séjour et couloir. 3 carreleurs. Matériaux suffisants.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
320	51	57	10	2	2	soleil	2026-03-05	Réception matériaux isolation. Contrôle quantités OK. Stockage en cours.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
321	51	53	3	2	2	pluie	2025-10-15	Plomberie salle de bain étage 2. Pose douche et WC. Conforme aux plans.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
322	52	53	5	2	2	soleil	2026-03-27	Pose bardage bois façade Est. Profils fixés. 4 menuisiers présents.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
323	52	55	6	2	2	soleil	2025-12-09	Réception matériaux isolation. Contrôle quantités OK. Stockage en cours.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
324	52	55	8	2	2	soleil	2025-11-04	Maçonnerie blocs béton mur Nord. Avancement conforme au planning. 6 ouvriers.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
325	52	55	6	2	2	soleil	2025-10-31	Maçonnerie blocs béton mur Nord. Avancement conforme au planning. 6 ouvriers.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
326	52	54	12	2	2	nuageux	2025-08-06	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
327	53	56	9	2	2	vent	2025-09-05	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
328	53	54	5	2	2	soleil	2025-08-25	Installation fenêtres double vitrage rez-de-chaussée. Travaux dans les délais.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
329	53	55	4	2	2	soleil	2025-09-29	Maçonnerie blocs béton mur Nord. Avancement conforme au planning. 6 ouvriers.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
330	53	57	11	2	2	soleil	2026-01-03	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
331	53	55	6	2	2	nuageux	2025-11-15	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
332	54	55	5	2	2	soleil	2026-01-26	Démolition cloisons existantes. Poussière importante, bâche mise en place.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
333	54	57	9	2	2	soleil	2025-09-18	Maçonnerie blocs béton mur Nord. Avancement conforme au planning. 6 ouvriers.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
334	54	54	7	2	2	soleil	2026-01-29	Plomberie salle de bain étage 2. Pose douche et WC. Conforme aux plans.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
335	54	57	7	2	2	soleil	2026-03-14	Pose bardage bois façade Est. Profils fixés. 4 menuisiers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
336	54	57	6	2	2	soleil	2025-10-21	Bétonnage semelles filantes. Contrôle béton effectué par laborantin.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
337	54	56	11	2	2	vent	2025-12-19	Pose charpente bois. Livraison madriers retardée de 2h. 5 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
338	54	56	10	2	2	soleil	2025-10-13	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
339	55	57	12	2	2	nuageux	2026-05-27	Pose bardage bois façade Est. Profils fixés. 4 menuisiers présents.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
340	55	53	12	2	2	nuageux	2025-11-16	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
341	55	55	5	2	2	pluie	2025-11-16	Installation fenêtres double vitrage rez-de-chaussée. Travaux dans les délais.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
342	55	53	8	2	2	vent	2026-01-27	Travaux d'isolation thermique façade Sud. Conditions météo favorables.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
343	55	54	6	2	2	vent	2025-12-10	Bétonnage semelles filantes. Contrôle béton effectué par laborantin.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
344	55	53	8	2	2	soleil	2025-08-17	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
345	55	53	10	2	2	nuageux	2026-04-11	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
346	56	56	8	2	2	pluie	2026-04-13	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
347	56	57	12	2	2	vent	2025-12-12	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
348	56	55	11	2	2	nuageux	2026-04-11	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
349	56	56	12	2	2	vent	2026-05-13	Installation fenêtres double vitrage rez-de-chaussée. Travaux dans les délais.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
350	56	57	6	2	2	vent	2026-04-15	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
351	56	54	8	2	2	soleil	2025-10-02	Levage charpente métallique. Grue mobilisée. Météo favorable.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
352	56	54	6	2	2	pluie	2025-12-23	Travaux d'isolation thermique façade Sud. Conditions météo favorables.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
353	57	57	4	2	2	soleil	2025-08-18	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
354	57	53	10	2	2	soleil	2026-02-08	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
355	57	55	4	2	2	soleil	2026-02-06	Pose charpente bois. Livraison madriers retardée de 2h. 5 ouvriers présents.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
356	57	54	9	2	2	nuageux	2025-10-06	Maçonnerie blocs béton mur Nord. Avancement conforme au planning. 6 ouvriers.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
357	57	56	11	2	2	nuageux	2025-08-14	Installation fenêtres double vitrage rez-de-chaussée. Travaux dans les délais.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
358	57	56	4	2	2	soleil	2026-03-06	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
359	58	57	4	2	2	soleil	2025-09-14	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
360	58	53	5	2	2	soleil	2026-04-10	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
361	58	56	6	2	2	soleil	2025-11-27	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
362	58	53	10	2	2	soleil	2026-05-06	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
363	58	56	5	2	2	soleil	2026-01-12	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
364	59	56	5	2	2	soleil	2026-03-24	Bétonnage semelles filantes. Contrôle béton effectué par laborantin.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
365	59	56	5	2	2	soleil	2025-08-29	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
366	59	55	5	2	2	soleil	2026-02-04	Levage charpente métallique. Grue mobilisée. Météo favorable.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
367	59	55	10	2	2	nuageux	2025-12-27	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
368	59	54	3	2	2	vent	2026-03-22	Coulage dalle béton niveau R+1. Pose coffrage et armatures réalisée. 8 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
369	59	54	11	2	2	soleil	2026-01-29	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
370	59	57	7	2	2	soleil	2026-04-20	Réception matériaux isolation. Contrôle quantités OK. Stockage en cours.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
371	60	56	12	2	2	pluie	2025-08-27	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
372	60	56	8	2	2	pluie	2026-05-15	Réception matériaux isolation. Contrôle quantités OK. Stockage en cours.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
373	60	56	11	2	2	nuageux	2025-09-02	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
374	60	54	6	2	2	soleil	2026-05-20	Réception matériaux isolation. Contrôle quantités OK. Stockage en cours.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
375	60	55	10	2	2	nuageux	2026-03-12	Bétonnage semelles filantes. Contrôle béton effectué par laborantin.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
376	60	57	8	2	2	soleil	2025-09-09	Pose charpente bois. Livraison madriers retardée de 2h. 5 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
377	60	53	11	2	2	soleil	2025-12-20	Pose charpente bois. Livraison madriers retardée de 2h. 5 ouvriers présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
378	60	55	5	2	2	soleil	2026-04-17	Réception matériaux isolation. Contrôle quantités OK. Stockage en cours.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
379	61	57	7	2	2	soleil	2026-05-12	Bétonnage semelles filantes. Contrôle béton effectué par laborantin.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
380	61	55	8	2	2	soleil	2026-04-14	Levage charpente métallique. Grue mobilisée. Météo favorable.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
381	61	56	5	2	2	pluie	2025-11-07	Installation fenêtres double vitrage rez-de-chaussée. Travaux dans les délais.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
382	61	56	5	2	2	nuageux	2025-11-04	Plomberie salle de bain étage 2. Pose douche et WC. Conforme aux plans.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
383	61	55	11	2	2	soleil	2025-11-08	Peinture intérieure appartements 3A et 3B. 2 peintres. Première couche terminée.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
384	61	53	4	2	2	pluie	2026-01-10	Levage charpente métallique. Grue mobilisée. Météo favorable.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
385	62	55	3	2	2	pluie	2026-04-26	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
386	62	56	12	2	2	soleil	2026-02-14	Bétonnage semelles filantes. Contrôle béton effectué par laborantin.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
387	62	55	9	2	2	vent	2025-12-09	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
388	62	54	10	2	2	soleil	2025-11-21	Réception matériaux isolation. Contrôle quantités OK. Stockage en cours.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
389	62	53	11	2	2	vent	2025-12-08	Pose carrelage séjour et couloir. 3 carreleurs. Matériaux suffisants.	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
390	62	54	11	2	2	soleil	2026-03-16	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	Panne bétonnière 1h. Réparée sur place.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
391	62	54	3	2	2	soleil	2025-09-02	Terrassement parking souterrain niveau -1. Excavatrice en service toute la journée.	Retard livraison matériaux 2h.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
392	62	54	7	2	2	vent	2025-11-22	Électricité gros œuvre, pose gaines et boîtiers. 4 électriciens présents.	Incident léger: coupure légère ouvrier, soins prodigués.	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Data for Name: chantier_tache; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chantier_tache (id, chantier_id, sequence, responsable_id, create_uid, write_uid, name, state, date_debut, date_fin, description, note, create_date, write_date) FROM stdin;
265	43	10	53	2	2	Contrôle qualité	a_faire	2026-02-28	2026-05-21	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
266	43	20	53	2	2	Nettoyage et réception	a_faire	2026-04-03	2026-05-06	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
267	43	30	53	2	2	Peinture intérieure	a_faire	2026-03-05	2026-05-10	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
2	2	10	2	2	2	changer fenetre pvc	a_faire	2026-06-02	2026-06-03	\N	\N	2026-06-01 08:23:47.681378	2026-06-01 08:45:30.333929
3	2	11	5	2	2	decapage mur	a_faire	2026-06-03	2026-06-05	\N	\N	2026-06-01 08:23:47.681378	2026-06-01 08:45:30.333929
268	43	40	53	2	2	Installation chantier et signalisation	a_faire	2026-01-18	2026-05-02	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
269	43	50	53	2	2	Plâtrerie et cloisons	a_faire	2026-04-23	2026-05-07	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
270	43	60	53	2	2	Terrassement et fouilles	fait	2026-01-12	2026-05-11	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
271	44	10	54	2	2	Plâtrerie et cloisons	a_faire	2025-12-22	2026-05-11	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
272	44	20	54	2	2	Électricité phase 1	fait	2026-02-22	2026-05-16	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
273	44	30	54	2	2	Isolation thermique	a_faire	2026-01-18	2026-05-05	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
274	44	40	54	2	2	Menuiseries extérieures	a_faire	2026-01-20	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
275	44	50	54	2	2	Plomberie sanitaire	en_cours	2026-02-11	2026-05-06	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
276	44	60	54	2	2	Maçonnerie gros œuvre	en_cours	2025-12-07	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
277	44	70	54	2	2	Coulage fondations	fait	2025-12-22	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
278	45	10	55	2	2	Charpente et toiture	en_cours	2026-03-16	2026-05-20	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
279	45	20	55	2	2	Aménagements extérieurs	a_faire	2026-02-11	2026-05-25	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
280	45	30	55	2	2	Menuiseries extérieures	a_faire	2025-12-18	2026-05-11	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
281	45	40	55	2	2	Structure béton armé	fait	2026-04-25	2026-05-09	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
282	45	50	55	2	2	Isolation thermique	a_faire	2026-03-26	2026-05-17	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
283	45	60	55	2	2	Maçonnerie gros œuvre	en_cours	2026-01-11	2026-05-22	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
284	46	10	56	2	2	Charpente et toiture	en_cours	2026-04-15	2026-05-07	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
285	46	20	56	2	2	Nettoyage et réception	a_faire	2026-04-04	2026-05-04	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
286	46	30	56	2	2	Menuiseries extérieures	a_faire	2026-03-06	2026-05-05	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
287	46	40	56	2	2	Structure béton armé	fait	2026-04-17	2026-05-07	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
288	46	50	56	2	2	Plomberie sanitaire	en_cours	2025-12-05	2026-05-18	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
289	46	60	56	2	2	Installation chantier et signalisation	a_faire	2026-04-09	2026-05-02	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
290	46	70	56	2	2	Plâtrerie et cloisons	a_faire	2026-01-19	2026-05-04	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
291	47	10	57	2	2	Carrelage et revêtements	a_faire	2025-12-25	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
292	47	20	57	2	2	Plâtrerie et cloisons	a_faire	2025-12-23	2026-05-18	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
293	47	30	57	2	2	Plomberie sanitaire	en_cours	2025-12-28	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
294	47	40	57	2	2	Électricité phase 1	fait	2025-12-09	2026-05-11	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
295	47	50	57	2	2	Peinture intérieure	a_faire	2026-03-31	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
296	47	60	57	2	2	Levée des réserves	a_faire	2025-12-26	2026-05-21	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
297	48	10	53	2	2	Électricité phase 2 finition	a_faire	2026-01-29	2026-05-10	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
298	48	20	53	2	2	Plâtrerie et cloisons	a_faire	2025-12-17	2026-05-03	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
299	48	30	53	2	2	Nettoyage et réception	a_faire	2026-01-20	2026-05-18	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
300	48	40	53	2	2	Structure béton armé	fait	2026-05-01	2026-05-25	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
301	48	50	53	2	2	Coulage fondations	fait	2026-01-13	2026-05-09	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
302	49	10	54	2	2	Charpente et toiture	en_cours	2026-04-17	2026-05-05	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
303	49	20	54	2	2	Nettoyage et réception	a_faire	2026-01-31	2026-05-26	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
304	49	30	54	2	2	Coulage fondations	fait	2025-12-31	2026-05-17	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
305	49	40	54	2	2	Contrôle qualité	a_faire	2026-04-02	2026-05-13	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
306	49	50	54	2	2	Terrassement et fouilles	fait	2026-02-09	2026-05-08	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
307	49	60	54	2	2	Carrelage et revêtements	a_faire	2025-12-06	2026-05-09	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
308	49	70	54	2	2	Levée des réserves	a_faire	2026-03-30	2026-05-12	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
309	49	80	54	2	2	Menuiseries extérieures	a_faire	2026-01-09	2026-05-24	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
310	50	10	55	2	2	Carrelage et revêtements	a_faire	2026-04-06	2026-05-24	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
311	50	20	55	2	2	Structure béton armé	fait	2026-03-15	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
312	50	30	55	2	2	Charpente et toiture	en_cours	2026-04-06	2026-05-24	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
313	50	40	55	2	2	Coulage fondations	fait	2026-03-02	2026-05-13	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
314	50	50	55	2	2	Terrassement et fouilles	fait	2026-01-31	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
315	51	10	56	2	2	Plâtrerie et cloisons	a_faire	2026-04-08	2026-05-27	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
316	51	20	56	2	2	Électricité phase 2 finition	a_faire	2026-04-29	2026-05-12	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
317	51	30	56	2	2	Charpente et toiture	en_cours	2026-01-02	2026-05-13	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
318	51	40	56	2	2	Contrôle qualité	a_faire	2026-02-03	2026-05-25	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
319	51	50	56	2	2	Installation chantier et signalisation	a_faire	2026-04-25	2026-05-11	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
320	51	60	56	2	2	Terrassement et fouilles	fait	2026-05-02	2026-05-23	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
321	51	70	56	2	2	Coulage fondations	fait	2026-04-05	2026-05-02	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
322	51	80	56	2	2	Levée des réserves	a_faire	2026-02-17	2026-05-21	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
323	52	10	57	2	2	Coulage fondations	fait	2025-12-08	2026-05-13	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
324	52	20	57	2	2	Structure béton armé	fait	2026-01-31	2026-05-07	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
325	52	30	57	2	2	Électricité phase 1	fait	2026-01-05	2026-05-24	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
326	52	40	57	2	2	Isolation thermique	a_faire	2026-02-12	2026-05-24	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
327	52	50	57	2	2	Menuiseries extérieures	a_faire	2026-01-26	2026-05-09	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
328	52	60	57	2	2	Plâtrerie et cloisons	a_faire	2025-12-29	2026-05-04	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
329	53	10	53	2	2	Terrassement et fouilles	fait	2026-04-01	2026-05-03	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
330	53	20	53	2	2	Plâtrerie et cloisons	a_faire	2026-01-07	2026-05-06	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
331	53	30	53	2	2	Carrelage et revêtements	a_faire	2025-12-03	2026-05-21	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
332	53	40	53	2	2	Menuiseries extérieures	a_faire	2026-01-28	2026-05-23	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
333	53	50	53	2	2	Aménagements extérieurs	a_faire	2026-03-25	2026-05-26	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
334	53	60	53	2	2	Isolation thermique	a_faire	2025-12-09	2026-05-07	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
335	53	70	53	2	2	Nettoyage et réception	a_faire	2026-04-19	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
336	54	10	54	2	2	Plâtrerie et cloisons	a_faire	2026-03-16	2026-05-10	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
337	54	20	54	2	2	Levée des réserves	a_faire	2026-03-16	2026-05-12	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
338	54	30	54	2	2	Structure béton armé	fait	2026-02-14	2026-05-09	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
339	54	40	54	2	2	Carrelage et revêtements	a_faire	2026-01-30	2026-05-23	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
340	54	50	54	2	2	Menuiseries extérieures	a_faire	2026-02-02	2026-05-15	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
341	54	60	54	2	2	Plomberie sanitaire	en_cours	2025-12-17	2026-05-24	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
342	54	70	54	2	2	Installation chantier et signalisation	a_faire	2025-12-06	2026-05-15	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
343	55	10	55	2	2	Installation chantier et signalisation	a_faire	2026-01-25	2026-05-27	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
344	55	20	55	2	2	Levée des réserves	a_faire	2026-02-10	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
345	55	30	55	2	2	Contrôle qualité	a_faire	2025-12-23	2026-05-03	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
346	55	40	55	2	2	Aménagements extérieurs	a_faire	2026-03-16	2026-05-22	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
347	55	50	55	2	2	Structure béton armé	fait	2026-04-04	2026-05-13	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
348	55	60	55	2	2	Maçonnerie gros œuvre	en_cours	2026-02-13	2026-05-25	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
349	56	10	56	2	2	Aménagements extérieurs	a_faire	2026-02-27	2026-05-23	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
350	56	20	56	2	2	Structure béton armé	fait	2026-04-22	2026-05-27	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
351	56	30	56	2	2	Nettoyage et réception	a_faire	2026-01-16	2026-05-05	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
352	56	40	56	2	2	Peinture intérieure	a_faire	2026-03-08	2026-05-19	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
353	56	50	56	2	2	Électricité phase 1	fait	2026-01-24	2026-05-06	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
354	56	60	56	2	2	Maçonnerie gros œuvre	en_cours	2026-01-10	2026-05-13	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
355	56	70	56	2	2	Coulage fondations	fait	2026-01-30	2026-05-09	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
356	56	80	56	2	2	Isolation thermique	a_faire	2026-01-03	2026-05-20	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
357	57	10	57	2	2	Charpente et toiture	en_cours	2026-02-01	2026-05-12	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
358	57	20	57	2	2	Électricité phase 1	fait	2026-03-21	2026-05-09	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
359	57	30	57	2	2	Contrôle qualité	a_faire	2026-03-24	2026-05-25	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
360	57	40	57	2	2	Installation chantier et signalisation	a_faire	2025-12-15	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
361	57	50	57	2	2	Aménagements extérieurs	a_faire	2026-02-04	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
362	58	10	53	2	2	Plomberie sanitaire	en_cours	2026-01-24	2026-05-20	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
363	58	20	53	2	2	Électricité phase 2 finition	a_faire	2025-12-30	2026-05-25	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
364	58	30	53	2	2	Coulage fondations	fait	2026-02-22	2026-05-07	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
365	58	40	53	2	2	Installation chantier et signalisation	a_faire	2026-04-05	2026-05-09	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
366	58	50	53	2	2	Levée des réserves	a_faire	2026-01-29	2026-05-18	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
367	58	60	53	2	2	Maçonnerie gros œuvre	en_cours	2026-02-25	2026-05-09	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
368	58	70	53	2	2	Menuiseries extérieures	a_faire	2026-04-03	2026-05-04	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
369	58	80	53	2	2	Contrôle qualité	a_faire	2026-04-30	2026-05-15	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
370	59	10	54	2	2	Plomberie sanitaire	en_cours	2025-12-27	2026-05-03	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
371	59	20	54	2	2	Maçonnerie gros œuvre	en_cours	2026-04-09	2026-05-02	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
372	59	30	54	2	2	Aménagements extérieurs	a_faire	2025-12-19	2026-05-06	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
373	59	40	54	2	2	Isolation thermique	a_faire	2026-01-18	2026-05-26	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
374	59	50	54	2	2	Peinture intérieure	a_faire	2026-01-23	2026-05-21	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
375	60	10	55	2	2	Terrassement et fouilles	fait	2025-12-11	2026-05-26	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
376	60	20	55	2	2	Peinture intérieure	a_faire	2026-04-26	2026-05-14	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
377	60	30	55	2	2	Charpente et toiture	en_cours	2026-01-22	2026-05-18	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
378	60	40	55	2	2	Nettoyage et réception	a_faire	2026-03-23	2026-05-10	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
379	60	50	55	2	2	Plomberie sanitaire	en_cours	2026-03-23	2026-05-22	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
380	60	60	55	2	2	Plâtrerie et cloisons	a_faire	2026-04-27	2026-05-02	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
381	60	70	55	2	2	Menuiseries extérieures	a_faire	2026-01-21	2026-05-03	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
382	61	10	56	2	2	Structure béton armé	fait	2026-03-06	2026-05-04	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
383	61	20	56	2	2	Isolation thermique	a_faire	2025-12-16	2026-05-18	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
384	61	30	56	2	2	Carrelage et revêtements	a_faire	2026-01-21	2026-05-04	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
385	61	40	56	2	2	Contrôle qualité	a_faire	2026-04-22	2026-05-12	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
386	61	50	56	2	2	Nettoyage et réception	a_faire	2026-03-18	2026-05-23	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
387	61	60	56	2	2	Aménagements extérieurs	a_faire	2026-03-29	2026-05-12	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
388	61	70	56	2	2	Maçonnerie gros œuvre	en_cours	2026-01-12	2026-05-05	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
389	61	80	56	2	2	Électricité phase 2 finition	a_faire	2026-01-14	2026-05-22	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
390	62	10	57	2	2	Maçonnerie gros œuvre	en_cours	2026-01-15	2026-05-10	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
391	62	20	57	2	2	Plâtrerie et cloisons	a_faire	2026-04-02	2026-05-11	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
392	62	30	57	2	2	Électricité phase 1	fait	2026-01-09	2026-05-03	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
393	62	40	57	2	2	Isolation thermique	a_faire	2026-02-11	2026-05-08	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
394	62	50	57	2	2	Contrôle qualité	a_faire	2026-01-08	2026-05-18	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
395	62	60	57	2	2	Installation chantier et signalisation	a_faire	2025-12-25	2026-05-17	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
396	62	70	57	2	2	Terrassement et fouilles	fait	2026-03-04	2026-05-10	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
397	62	80	57	2	2	Aménagements extérieurs	a_faire	2026-03-24	2026-05-12	\N	\N	2026-06-01 11:24:15.158482	2026-06-01 11:24:15.158482
\.


--
-- Name: chantier_attribution_outil_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_attribution_outil_id_seq', 332, true);


--
-- Name: chantier_avenant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_avenant_id_seq', 113, true);


--
-- Name: chantier_chantier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_chantier_id_seq', 62, true);


--
-- Name: chantier_commande_fournisseur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_commande_fournisseur_id_seq', 66, true);


--
-- Name: chantier_commande_fournisseur_ligne_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_commande_fournisseur_ligne_id_seq', 274, true);


--
-- Name: chantier_demande_materiel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_demande_materiel_id_seq', 374, true);


--
-- Name: chantier_devis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_devis_id_seq', 63, true);


--
-- Name: chantier_devis_ligne_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_devis_ligne_id_seq', 365, true);


--
-- Name: chantier_estimation_materiau_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_estimation_materiau_id_seq', 588, true);


--
-- Name: chantier_estimation_outil_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_estimation_outil_id_seq', 374, true);


--
-- Name: chantier_facture_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_facture_id_seq', 222, true);


--
-- Name: chantier_heure_prestee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_heure_prestee_id_seq', 586, true);


--
-- Name: chantier_materiau_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_materiau_id_seq', 152, true);


--
-- Name: chantier_outil_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_outil_id_seq', 152, true);


--
-- Name: chantier_paiement_fss_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_paiement_fss_id_seq', 114, true);


--
-- Name: chantier_photo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_photo_id_seq', 396, true);


--
-- Name: chantier_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_plan_id_seq', 257, true);


--
-- Name: chantier_rapport_journalier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_rapport_journalier_id_seq', 392, true);


--
-- Name: chantier_tache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chantier_tache_id_seq', 397, true);


--
-- Name: chantier_attribution_outil chantier_attribution_outil_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_attribution_outil
    ADD CONSTRAINT chantier_attribution_outil_pkey PRIMARY KEY (id);


--
-- Name: chantier_avenant chantier_avenant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_avenant
    ADD CONSTRAINT chantier_avenant_pkey PRIMARY KEY (id);


--
-- Name: chantier_chantier chantier_chantier_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_chantier
    ADD CONSTRAINT chantier_chantier_pkey PRIMARY KEY (id);


--
-- Name: chantier_commande_fournisseur_ligne chantier_commande_fournisseur_ligne_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur_ligne
    ADD CONSTRAINT chantier_commande_fournisseur_ligne_pkey PRIMARY KEY (id);


--
-- Name: chantier_commande_fournisseur chantier_commande_fournisseur_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur
    ADD CONSTRAINT chantier_commande_fournisseur_pkey PRIMARY KEY (id);


--
-- Name: chantier_demande_materiel chantier_demande_materiel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_demande_materiel
    ADD CONSTRAINT chantier_demande_materiel_pkey PRIMARY KEY (id);


--
-- Name: chantier_devis_ligne chantier_devis_ligne_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis_ligne
    ADD CONSTRAINT chantier_devis_ligne_pkey PRIMARY KEY (id);


--
-- Name: chantier_devis chantier_devis_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis
    ADD CONSTRAINT chantier_devis_pkey PRIMARY KEY (id);


--
-- Name: chantier_estimation_materiau chantier_estimation_materiau_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_materiau
    ADD CONSTRAINT chantier_estimation_materiau_pkey PRIMARY KEY (id);


--
-- Name: chantier_estimation_outil chantier_estimation_outil_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_outil
    ADD CONSTRAINT chantier_estimation_outil_pkey PRIMARY KEY (id);


--
-- Name: chantier_facture chantier_facture_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_facture
    ADD CONSTRAINT chantier_facture_pkey PRIMARY KEY (id);


--
-- Name: chantier_heure_prestee chantier_heure_prestee_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_heure_prestee
    ADD CONSTRAINT chantier_heure_prestee_pkey PRIMARY KEY (id);


--
-- Name: chantier_materiau chantier_materiau_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_materiau
    ADD CONSTRAINT chantier_materiau_pkey PRIMARY KEY (id);


--
-- Name: chantier_outil chantier_outil_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_outil
    ADD CONSTRAINT chantier_outil_pkey PRIMARY KEY (id);


--
-- Name: chantier_paiement_fss chantier_paiement_fss_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_paiement_fss
    ADD CONSTRAINT chantier_paiement_fss_pkey PRIMARY KEY (id);


--
-- Name: chantier_photo chantier_photo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_photo
    ADD CONSTRAINT chantier_photo_pkey PRIMARY KEY (id);


--
-- Name: chantier_plan chantier_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_plan
    ADD CONSTRAINT chantier_plan_pkey PRIMARY KEY (id);


--
-- Name: chantier_rapport_journalier chantier_rapport_journalier_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_rapport_journalier
    ADD CONSTRAINT chantier_rapport_journalier_pkey PRIMARY KEY (id);


--
-- Name: chantier_tache chantier_tache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_tache
    ADD CONSTRAINT chantier_tache_pkey PRIMARY KEY (id);


--
-- Name: chantier_attribution_outil chantier_attribution_outil_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_attribution_outil
    ADD CONSTRAINT chantier_attribution_outil_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_attribution_outil chantier_attribution_outil_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_attribution_outil
    ADD CONSTRAINT chantier_attribution_outil_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_attribution_outil chantier_attribution_outil_outil_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_attribution_outil
    ADD CONSTRAINT chantier_attribution_outil_outil_id_fkey FOREIGN KEY (outil_id) REFERENCES public.chantier_outil(id) ON DELETE RESTRICT;


--
-- Name: chantier_attribution_outil chantier_attribution_outil_ouvrier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_attribution_outil
    ADD CONSTRAINT chantier_attribution_outil_ouvrier_id_fkey FOREIGN KEY (ouvrier_id) REFERENCES public.res_users(id) ON DELETE RESTRICT;


--
-- Name: chantier_attribution_outil chantier_attribution_outil_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_attribution_outil
    ADD CONSTRAINT chantier_attribution_outil_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_avenant chantier_avenant_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_avenant
    ADD CONSTRAINT chantier_avenant_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_avenant chantier_avenant_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_avenant
    ADD CONSTRAINT chantier_avenant_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.res_currency(id) ON DELETE SET NULL;


--
-- Name: chantier_avenant chantier_avenant_devis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_avenant
    ADD CONSTRAINT chantier_avenant_devis_id_fkey FOREIGN KEY (devis_id) REFERENCES public.chantier_devis(id) ON DELETE CASCADE;


--
-- Name: chantier_avenant chantier_avenant_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_avenant
    ADD CONSTRAINT chantier_avenant_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_chantier chantier_chantier_chef_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_chantier
    ADD CONSTRAINT chantier_chantier_chef_chantier_id_fkey FOREIGN KEY (chef_chantier_id) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_chantier chantier_chantier_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_chantier
    ADD CONSTRAINT chantier_chantier_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.res_partner(id) ON DELETE RESTRICT;


--
-- Name: chantier_chantier chantier_chantier_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_chantier
    ADD CONSTRAINT chantier_chantier_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_chantier chantier_chantier_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_chantier
    ADD CONSTRAINT chantier_chantier_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.res_currency(id) ON DELETE SET NULL;


--
-- Name: chantier_chantier chantier_chantier_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_chantier
    ADD CONSTRAINT chantier_chantier_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_commande_fournisseur chantier_commande_fournisseur_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur
    ADD CONSTRAINT chantier_commande_fournisseur_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_commande_fournisseur chantier_commande_fournisseur_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur
    ADD CONSTRAINT chantier_commande_fournisseur_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_commande_fournisseur chantier_commande_fournisseur_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur
    ADD CONSTRAINT chantier_commande_fournisseur_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.res_currency(id) ON DELETE SET NULL;


--
-- Name: chantier_commande_fournisseur chantier_commande_fournisseur_fournisseur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur
    ADD CONSTRAINT chantier_commande_fournisseur_fournisseur_id_fkey FOREIGN KEY (fournisseur_id) REFERENCES public.res_partner(id) ON DELETE SET NULL;


--
-- Name: chantier_commande_fournisseur_ligne chantier_commande_fournisseur_ligne_commande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur_ligne
    ADD CONSTRAINT chantier_commande_fournisseur_ligne_commande_id_fkey FOREIGN KEY (commande_id) REFERENCES public.chantier_commande_fournisseur(id) ON DELETE CASCADE;


--
-- Name: chantier_commande_fournisseur_ligne chantier_commande_fournisseur_ligne_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur_ligne
    ADD CONSTRAINT chantier_commande_fournisseur_ligne_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_commande_fournisseur_ligne chantier_commande_fournisseur_ligne_materiau_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur_ligne
    ADD CONSTRAINT chantier_commande_fournisseur_ligne_materiau_id_fkey FOREIGN KEY (materiau_id) REFERENCES public.chantier_materiau(id) ON DELETE SET NULL;


--
-- Name: chantier_commande_fournisseur_ligne chantier_commande_fournisseur_ligne_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur_ligne
    ADD CONSTRAINT chantier_commande_fournisseur_ligne_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_commande_fournisseur chantier_commande_fournisseur_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_commande_fournisseur
    ADD CONSTRAINT chantier_commande_fournisseur_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_demande_materiel chantier_demande_materiel_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_demande_materiel
    ADD CONSTRAINT chantier_demande_materiel_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_demande_materiel chantier_demande_materiel_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_demande_materiel
    ADD CONSTRAINT chantier_demande_materiel_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_demande_materiel chantier_demande_materiel_materiau_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_demande_materiel
    ADD CONSTRAINT chantier_demande_materiel_materiau_id_fkey FOREIGN KEY (materiau_id) REFERENCES public.chantier_materiau(id) ON DELETE SET NULL;


--
-- Name: chantier_demande_materiel chantier_demande_materiel_ouvrier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_demande_materiel
    ADD CONSTRAINT chantier_demande_materiel_ouvrier_id_fkey FOREIGN KEY (ouvrier_id) REFERENCES public.res_users(id) ON DELETE RESTRICT;


--
-- Name: chantier_demande_materiel chantier_demande_materiel_validateur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_demande_materiel
    ADD CONSTRAINT chantier_demande_materiel_validateur_id_fkey FOREIGN KEY (validateur_id) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_demande_materiel chantier_demande_materiel_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_demande_materiel
    ADD CONSTRAINT chantier_demande_materiel_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_devis chantier_devis_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis
    ADD CONSTRAINT chantier_devis_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_devis chantier_devis_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis
    ADD CONSTRAINT chantier_devis_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_devis chantier_devis_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis
    ADD CONSTRAINT chantier_devis_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.res_currency(id) ON DELETE SET NULL;


--
-- Name: chantier_devis_ligne chantier_devis_ligne_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis_ligne
    ADD CONSTRAINT chantier_devis_ligne_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_devis_ligne chantier_devis_ligne_devis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis_ligne
    ADD CONSTRAINT chantier_devis_ligne_devis_id_fkey FOREIGN KEY (devis_id) REFERENCES public.chantier_devis(id) ON DELETE CASCADE;


--
-- Name: chantier_devis_ligne chantier_devis_ligne_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis_ligne
    ADD CONSTRAINT chantier_devis_ligne_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_devis chantier_devis_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_devis
    ADD CONSTRAINT chantier_devis_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_estimation_materiau chantier_estimation_materiau_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_materiau
    ADD CONSTRAINT chantier_estimation_materiau_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_estimation_materiau chantier_estimation_materiau_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_materiau
    ADD CONSTRAINT chantier_estimation_materiau_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_estimation_materiau chantier_estimation_materiau_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_materiau
    ADD CONSTRAINT chantier_estimation_materiau_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.res_currency(id) ON DELETE SET NULL;


--
-- Name: chantier_estimation_materiau chantier_estimation_materiau_materiau_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_materiau
    ADD CONSTRAINT chantier_estimation_materiau_materiau_id_fkey FOREIGN KEY (materiau_id) REFERENCES public.chantier_materiau(id) ON DELETE RESTRICT;


--
-- Name: chantier_estimation_materiau chantier_estimation_materiau_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_materiau
    ADD CONSTRAINT chantier_estimation_materiau_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_estimation_outil chantier_estimation_outil_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_outil
    ADD CONSTRAINT chantier_estimation_outil_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_estimation_outil chantier_estimation_outil_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_outil
    ADD CONSTRAINT chantier_estimation_outil_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_estimation_outil chantier_estimation_outil_outil_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_outil
    ADD CONSTRAINT chantier_estimation_outil_outil_id_fkey FOREIGN KEY (outil_id) REFERENCES public.chantier_outil(id) ON DELETE RESTRICT;


--
-- Name: chantier_estimation_outil chantier_estimation_outil_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_estimation_outil
    ADD CONSTRAINT chantier_estimation_outil_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_facture chantier_facture_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_facture
    ADD CONSTRAINT chantier_facture_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_facture chantier_facture_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_facture
    ADD CONSTRAINT chantier_facture_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_facture chantier_facture_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_facture
    ADD CONSTRAINT chantier_facture_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.res_currency(id) ON DELETE SET NULL;


--
-- Name: chantier_facture chantier_facture_devis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_facture
    ADD CONSTRAINT chantier_facture_devis_id_fkey FOREIGN KEY (devis_id) REFERENCES public.chantier_devis(id) ON DELETE SET NULL;


--
-- Name: chantier_facture chantier_facture_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_facture
    ADD CONSTRAINT chantier_facture_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_heure_prestee chantier_heure_prestee_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_heure_prestee
    ADD CONSTRAINT chantier_heure_prestee_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_heure_prestee chantier_heure_prestee_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_heure_prestee
    ADD CONSTRAINT chantier_heure_prestee_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_heure_prestee chantier_heure_prestee_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_heure_prestee
    ADD CONSTRAINT chantier_heure_prestee_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.res_currency(id) ON DELETE SET NULL;


--
-- Name: chantier_heure_prestee chantier_heure_prestee_ouvrier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_heure_prestee
    ADD CONSTRAINT chantier_heure_prestee_ouvrier_id_fkey FOREIGN KEY (ouvrier_id) REFERENCES public.res_users(id) ON DELETE RESTRICT;


--
-- Name: chantier_heure_prestee chantier_heure_prestee_validateur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_heure_prestee
    ADD CONSTRAINT chantier_heure_prestee_validateur_id_fkey FOREIGN KEY (validateur_id) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_heure_prestee chantier_heure_prestee_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_heure_prestee
    ADD CONSTRAINT chantier_heure_prestee_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_materiau chantier_materiau_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_materiau
    ADD CONSTRAINT chantier_materiau_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_materiau chantier_materiau_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_materiau
    ADD CONSTRAINT chantier_materiau_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.res_currency(id) ON DELETE SET NULL;


--
-- Name: chantier_materiau chantier_materiau_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_materiau
    ADD CONSTRAINT chantier_materiau_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_outil chantier_outil_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_outil
    ADD CONSTRAINT chantier_outil_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_outil chantier_outil_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_outil
    ADD CONSTRAINT chantier_outil_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.res_currency(id) ON DELETE SET NULL;


--
-- Name: chantier_outil chantier_outil_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_outil
    ADD CONSTRAINT chantier_outil_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_paiement_fss chantier_paiement_fss_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_paiement_fss
    ADD CONSTRAINT chantier_paiement_fss_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_paiement_fss chantier_paiement_fss_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_paiement_fss
    ADD CONSTRAINT chantier_paiement_fss_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_paiement_fss chantier_paiement_fss_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_paiement_fss
    ADD CONSTRAINT chantier_paiement_fss_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.res_currency(id) ON DELETE SET NULL;


--
-- Name: chantier_paiement_fss chantier_paiement_fss_ouvrier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_paiement_fss
    ADD CONSTRAINT chantier_paiement_fss_ouvrier_id_fkey FOREIGN KEY (ouvrier_id) REFERENCES public.res_users(id) ON DELETE RESTRICT;


--
-- Name: chantier_paiement_fss chantier_paiement_fss_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_paiement_fss
    ADD CONSTRAINT chantier_paiement_fss_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_photo chantier_photo_auteur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_photo
    ADD CONSTRAINT chantier_photo_auteur_id_fkey FOREIGN KEY (auteur_id) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_photo chantier_photo_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_photo
    ADD CONSTRAINT chantier_photo_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_photo chantier_photo_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_photo
    ADD CONSTRAINT chantier_photo_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_photo chantier_photo_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_photo
    ADD CONSTRAINT chantier_photo_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_plan chantier_plan_auteur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_plan
    ADD CONSTRAINT chantier_plan_auteur_id_fkey FOREIGN KEY (auteur_id) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_plan chantier_plan_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_plan
    ADD CONSTRAINT chantier_plan_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_plan chantier_plan_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_plan
    ADD CONSTRAINT chantier_plan_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_plan chantier_plan_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_plan
    ADD CONSTRAINT chantier_plan_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_rapport_journalier chantier_rapport_journalier_auteur_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_rapport_journalier
    ADD CONSTRAINT chantier_rapport_journalier_auteur_id_fkey FOREIGN KEY (auteur_id) REFERENCES public.res_users(id) ON DELETE RESTRICT;


--
-- Name: chantier_rapport_journalier chantier_rapport_journalier_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_rapport_journalier
    ADD CONSTRAINT chantier_rapport_journalier_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_rapport_journalier chantier_rapport_journalier_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_rapport_journalier
    ADD CONSTRAINT chantier_rapport_journalier_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_rapport_journalier chantier_rapport_journalier_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_rapport_journalier
    ADD CONSTRAINT chantier_rapport_journalier_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_tache chantier_tache_chantier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_tache
    ADD CONSTRAINT chantier_tache_chantier_id_fkey FOREIGN KEY (chantier_id) REFERENCES public.chantier_chantier(id) ON DELETE CASCADE;


--
-- Name: chantier_tache chantier_tache_create_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_tache
    ADD CONSTRAINT chantier_tache_create_uid_fkey FOREIGN KEY (create_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_tache chantier_tache_responsable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_tache
    ADD CONSTRAINT chantier_tache_responsable_id_fkey FOREIGN KEY (responsable_id) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- Name: chantier_tache chantier_tache_write_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chantier_tache
    ADD CONSTRAINT chantier_tache_write_uid_fkey FOREIGN KEY (write_uid) REFERENCES public.res_users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict 7vrRrdqyJEO4JTe0ZKzE2jIRgOJFYKx47Mz3f37WyemFfC1bchE4kenbncBS8ap

