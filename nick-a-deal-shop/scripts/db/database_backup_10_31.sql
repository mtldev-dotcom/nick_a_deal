--
-- PostgreSQL database dump
--

\restrict SjT4Oh5CarfYHDEXESw6oStkAm4IKnQlAQuU0aw8148zQetfhlfcJ8c9PmEb3ee

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


ALTER TYPE public.claim_reason_enum OWNER TO postgres;

--
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


ALTER TYPE public.order_claim_type_enum OWNER TO postgres;

--
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


ALTER TYPE public.order_status_enum OWNER TO postgres;

--
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


ALTER TYPE public.return_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_holder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_holder (
    id text NOT NULL,
    provider_id text NOT NULL,
    external_id text NOT NULL,
    email text,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.account_holder OWNER TO postgres;

--
-- Name: api_key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT api_key_type_check CHECK ((type = ANY (ARRAY['publishable'::text, 'secret'::text])))
);


ALTER TABLE public.api_key OWNER TO postgres;

--
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_buy_rules OWNER TO postgres;

--
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_target_rules OWNER TO postgres;

--
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_identity OWNER TO postgres;

--
-- Name: capture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);


ALTER TABLE public.capture OWNER TO postgres;

--
-- Name: cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone
);


ALTER TABLE public.cart OWNER TO postgres;

--
-- Name: cart_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_address OWNER TO postgres;

--
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    product_type_id text,
    is_custom_price boolean DEFAULT false NOT NULL,
    is_giftcard boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.cart_line_item OWNER TO postgres;

--
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_line_item_adjustment OWNER TO postgres;

--
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text
);


ALTER TABLE public.cart_line_item_tax_line OWNER TO postgres;

--
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_payment_collection OWNER TO postgres;

--
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_promotion OWNER TO postgres;

--
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_shipping_method OWNER TO postgres;

--
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_adjustment OWNER TO postgres;

--
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_tax_line OWNER TO postgres;

--
-- Name: credit_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_line (
    id text NOT NULL,
    cart_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.credit_line OWNER TO postgres;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    decimal_digits integer DEFAULT 0 NOT NULL,
    rounding numeric DEFAULT 0 NOT NULL,
    raw_rounding jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.currency OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_account_holder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_account_holder (
    customer_id character varying(255) NOT NULL,
    account_holder_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_account_holder OWNER TO postgres;

--
-- Name: customer_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_address OWNER TO postgres;

--
-- Name: customer_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_group (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group OWNER TO postgres;

--
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group_customer OWNER TO postgres;

--
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    marked_shipped_by text,
    created_by text,
    requires_shipping boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment OWNER TO postgres;

--
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_address (
    id text NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_address OWNER TO postgres;

--
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_item OWNER TO postgres;

--
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_label OWNER TO postgres;

--
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_provider OWNER TO postgres;

--
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_set OWNER TO postgres;

--
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country'::text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text])))
);


ALTER TABLE public.geo_zone OWNER TO postgres;

--
-- Name: image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    rank integer DEFAULT 0 NOT NULL,
    product_id text NOT NULL
);


ALTER TABLE public.image OWNER TO postgres;

--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);


ALTER TABLE public.inventory_item OWNER TO postgres;

--
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity numeric DEFAULT 0 NOT NULL,
    reserved_quantity numeric DEFAULT 0 NOT NULL,
    incoming_quantity numeric DEFAULT 0 NOT NULL,
    metadata jsonb,
    raw_stocked_quantity jsonb,
    raw_reserved_quantity jsonb,
    raw_incoming_quantity jsonb
);


ALTER TABLE public.inventory_level OWNER TO postgres;

--
-- Name: invite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.invite OWNER TO postgres;

--
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.link_module_migrations OWNER TO postgres;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.link_module_migrations_id_seq OWNER TO postgres;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_provider OWNER TO postgres;

--
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_set OWNER TO postgres;

--
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO postgres;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNER TO postgres;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    id text NOT NULL,
    "to" text NOT NULL,
    channel text NOT NULL,
    template text NOT NULL,
    data jsonb,
    trigger_type text,
    resource_id text,
    resource_type text,
    receiver_id text,
    original_notification_id text,
    idempotency_key text,
    external_id text,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text])))
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_provider (
    id text NOT NULL,
    handle text NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    channels text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.notification_provider OWNER TO postgres;

--
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    id text NOT NULL,
    region_id text,
    display_id integer,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status public.order_status_enum DEFAULT 'pending'::public.order_status_enum NOT NULL,
    is_draft_order boolean DEFAULT false NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- Name: order_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_address OWNER TO postgres;

--
-- Name: order_cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_cart OWNER TO postgres;

--
-- Name: order_change; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    internal_note text,
    created_by text,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    change_type text,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text,
    CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text])))
);


ALTER TABLE public.order_change OWNER TO postgres;

--
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_change_action OWNER TO postgres;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_change_action_ordering_seq OWNER TO postgres;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- Name: order_claim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    type public.order_claim_type_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_claim OWNER TO postgres;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_claim_display_id_seq OWNER TO postgres;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim_item (
    id text NOT NULL,
    claim_id text NOT NULL,
    item_id text NOT NULL,
    is_additional_item boolean DEFAULT false NOT NULL,
    reason public.claim_reason_enum,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item OWNER TO postgres;

--
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim_item_image (
    id text NOT NULL,
    claim_item_id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item_image OWNER TO postgres;

--
-- Name: order_credit_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_credit_line (
    id text NOT NULL,
    order_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    version integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.order_credit_line OWNER TO postgres;

--
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_display_id_seq OWNER TO postgres;

--
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_exchange (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    no_notification boolean,
    allow_backorder boolean DEFAULT false NOT NULL,
    difference_due numeric,
    raw_difference_due jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_exchange OWNER TO postgres;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_exchange_display_id_seq OWNER TO postgres;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_exchange_item (
    id text NOT NULL,
    exchange_id text NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_exchange_item OWNER TO postgres;

--
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_fulfillment OWNER TO postgres;

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    delivered_quantity numeric DEFAULT 0 NOT NULL,
    raw_delivered_quantity jsonb NOT NULL,
    unit_price numeric,
    raw_unit_price jsonb,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_price boolean DEFAULT false NOT NULL,
    product_type_id text,
    is_giftcard boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item OWNER TO postgres;

--
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone,
    is_tax_inclusive boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item_adjustment OWNER TO postgres;

--
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_tax_line OWNER TO postgres;

--
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_payment_collection OWNER TO postgres;

--
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_promotion OWNER TO postgres;

--
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    shipping_method_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_shipping OWNER TO postgres;

--
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method (
    id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_amount boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_shipping_method OWNER TO postgres;

--
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_adjustment OWNER TO postgres;

--
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_tax_line OWNER TO postgres;

--
-- Name: order_summary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_summary (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    totals jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_summary OWNER TO postgres;

--
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_transaction OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text CONSTRAINT payment_provider_id_not_null1 NOT NULL,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    authorized_amount numeric,
    raw_authorized_amount jsonb,
    captured_amount numeric,
    raw_captured_amount jsonb,
    refunded_amount numeric,
    raw_refunded_amount jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid'::text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text, 'failed'::text, 'partially_captured'::text, 'completed'::text])))
);


ALTER TABLE public.payment_collection OWNER TO postgres;

--
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text CONSTRAINT payment_collection_payment_provi_payment_collection_id_not_null NOT NULL,
    payment_provider_id text CONSTRAINT payment_collection_payment_provide_payment_provider_id_not_null NOT NULL
);


ALTER TABLE public.payment_collection_payment_providers OWNER TO postgres;

--
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.payment_provider OWNER TO postgres;

--
-- Name: payment_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text])))
);


ALTER TABLE public.payment_session OWNER TO postgres;

--
-- Name: price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text CONSTRAINT price_money_amount_id_not_null NOT NULL,
    raw_amount jsonb NOT NULL,
    rules_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity integer,
    max_quantity integer
);


ALTER TABLE public.price OWNER TO postgres;

--
-- Name: price_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_list (
    id text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
    CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);


ALTER TABLE public.price_list OWNER TO postgres;

--
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_list_rule (
    id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    value jsonb,
    attribute text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.price_list_rule OWNER TO postgres;

--
-- Name: price_preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_preference (
    id text NOT NULL,
    attribute text NOT NULL,
    value text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_preference OWNER TO postgres;

--
-- Name: price_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_rule (
    id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    attribute text DEFAULT ''::text NOT NULL,
    operator text DEFAULT 'eq'::text NOT NULL,
    CONSTRAINT price_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text])))
);


ALTER TABLE public.price_rule OWNER TO postgres;

--
-- Name: price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_set OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    thumbnail text,
    weight text,
    length text,
    height text,
    width text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text])))
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb
);


ALTER TABLE public.product_category OWNER TO postgres;

--
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


ALTER TABLE public.product_category_product OWNER TO postgres;

--
-- Name: product_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_collection OWNER TO postgres;

--
-- Name: product_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_option (
    id text NOT NULL,
    title text NOT NULL,
    product_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option OWNER TO postgres;

--
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option_value OWNER TO postgres;

--
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_sales_channel OWNER TO postgres;

--
-- Name: product_shipping_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_shipping_profile (
    product_id character varying(255) NOT NULL,
    shipping_profile_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_shipping_profile OWNER TO postgres;

--
-- Name: product_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_tag OWNER TO postgres;

--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


ALTER TABLE public.product_tags OWNER TO postgres;

--
-- Name: product_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_type OWNER TO postgres;

--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    metadata jsonb,
    variant_rank integer DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant OWNER TO postgres;

--
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_inventory_item (
    variant_id character varying(255) NOT NULL,
    inventory_item_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    required_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_inventory_item OWNER TO postgres;

--
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


ALTER TABLE public.product_variant_option OWNER TO postgres;

--
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_price_set OWNER TO postgres;

--
-- Name: promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'draft'::text NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT promotion_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'inactive'::text]))),
    CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text])))
);


ALTER TABLE public.promotion OWNER TO postgres;

--
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb,
    max_quantity integer,
    apply_to_quantity integer,
    buy_rules_min_quantity integer,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text, 'once'::text]))),
    CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
    CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text])))
);


ALTER TABLE public.promotion_application_method OWNER TO postgres;

--
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign OWNER TO postgres;

--
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric DEFAULT 0 NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    attribute text,
    CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text, 'use_by_attribute'::text, 'spend_by_attribute'::text])))
);


ALTER TABLE public.promotion_campaign_budget OWNER TO postgres;

--
-- Name: promotion_campaign_budget_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign_budget_usage (
    id text NOT NULL,
    attribute_value text NOT NULL,
    used numeric DEFAULT 0 NOT NULL,
    budget_id text NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign_budget_usage OWNER TO postgres;

--
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.promotion_promotion_rule OWNER TO postgres;

--
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text])))
);


ALTER TABLE public.promotion_rule OWNER TO postgres;

--
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_rule_value OWNER TO postgres;

--
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provider_identity (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    auth_identity_id text NOT NULL,
    user_metadata jsonb,
    provider_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.provider_identity OWNER TO postgres;

--
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.publishable_api_key_sales_channel OWNER TO postgres;

--
-- Name: refund; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb,
    refund_reason_id text,
    note text
);


ALTER TABLE public.refund OWNER TO postgres;

--
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund_reason (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    code text NOT NULL
);


ALTER TABLE public.refund_reason OWNER TO postgres;

--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);


ALTER TABLE public.region OWNER TO postgres;

--
-- Name: region_country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_country OWNER TO postgres;

--
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_payment_provider OWNER TO postgres;

--
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity numeric NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL,
    allow_backorder boolean DEFAULT false,
    raw_quantity jsonb
);


ALTER TABLE public.reservation_item OWNER TO postgres;

--
-- Name: return; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return (
    id text NOT NULL,
    order_id text NOT NULL,
    claim_id text,
    exchange_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    status public.return_status_enum DEFAULT 'open'::public.return_status_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    received_at timestamp with time zone,
    canceled_at timestamp with time zone,
    location_id text,
    requested_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.return OWNER TO postgres;

--
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.return_display_id_seq OWNER TO postgres;

--
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_fulfillment OWNER TO postgres;

--
-- Name: return_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_item (
    id text NOT NULL,
    return_id text NOT NULL,
    reason_id text,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    received_quantity numeric DEFAULT 0 NOT NULL,
    raw_received_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    damaged_quantity numeric DEFAULT 0 NOT NULL,
    raw_damaged_quantity jsonb NOT NULL
);


ALTER TABLE public.return_item OWNER TO postgres;

--
-- Name: return_reason; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_reason (
    id character varying NOT NULL,
    value character varying NOT NULL,
    label character varying NOT NULL,
    description character varying,
    metadata jsonb,
    parent_return_reason_id character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_reason OWNER TO postgres;

--
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel OWNER TO postgres;

--
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel_stock_location OWNER TO postgres;

--
-- Name: script_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.script_migrations (
    id integer NOT NULL,
    script_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    finished_at timestamp with time zone
);


ALTER TABLE public.script_migrations OWNER TO postgres;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.script_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.script_migrations_id_seq OWNER TO postgres;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.script_migrations_id_seq OWNED BY public.script_migrations.id;


--
-- Name: service_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.service_zone OWNER TO postgres;

--
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat'::text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text])))
);


ALTER TABLE public.shipping_option OWNER TO postgres;

--
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_price_set OWNER TO postgres;

--
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text])))
);


ALTER TABLE public.shipping_option_rule OWNER TO postgres;

--
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_type OWNER TO postgres;

--
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_profile OWNER TO postgres;

--
-- Name: stock_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);


ALTER TABLE public.stock_location OWNER TO postgres;

--
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);


ALTER TABLE public.stock_location_address OWNER TO postgres;

--
-- Name: store; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store'::text NOT NULL,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store OWNER TO postgres;

--
-- Name: store_currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_currency (
    id text NOT NULL,
    currency_code text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store_currency OWNER TO postgres;

--
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_provider OWNER TO postgres;

--
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_rate (
    id text NOT NULL,
    rate real,
    code text NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate OWNER TO postgres;

--
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate_rule OWNER TO postgres;

--
-- Name: tax_region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL)))
);


ALTER TABLE public.tax_region OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_preference (
    id text NOT NULL,
    user_id text NOT NULL,
    key text NOT NULL,
    value jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.user_preference OWNER TO postgres;

--
-- Name: view_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_configuration (
    id text NOT NULL,
    entity text NOT NULL,
    name text,
    user_id text,
    is_system_default boolean DEFAULT false NOT NULL,
    configuration jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.view_configuration OWNER TO postgres;

--
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_execution (
    id character varying NOT NULL,
    workflow_id character varying NOT NULL,
    transaction_id character varying NOT NULL,
    execution jsonb,
    context jsonb,
    state character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    retention_time integer,
    run_id text DEFAULT '01K8RWJPDXCK52C4F67ZHEWQM0'::text NOT NULL
);


ALTER TABLE public.workflow_execution OWNER TO postgres;

--
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- Name: script_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.script_migrations ALTER COLUMN id SET DEFAULT nextval('public.script_migrations_id_seq'::regclass);


--
-- Data for Name: account_holder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_holder (id, provider_id, external_id, email, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at, deleted_at) FROM stdin;
apk_01K8RWK91WHHQ9RCH6DGCNNYYQ	pk_24c0a71452b673f7f2b12bfc448c46b00a275d9d6f73c664ecf6f222686de595		pk_24c***595	Webshop	publishable	\N		2025-10-29 17:04:49.724-04	\N	\N	2025-10-29 17:04:49.724-04	\N
\.


--
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at, deleted_at) FROM stdin;
authid_01K8RWNHX23G9HJ6CF71WW7WC1	{"user_id": "user_01K8RWNHYRDPC1T3FZ2KKPK7MM"}	2025-10-29 17:06:04.323-04	2025-10-29 17:06:04.4-04	\N
authid_01K8S9QEKEPQBT9FFYHSCNRYVZ	{"customer_id": "cus_01K8S9QEMGH6G87E0MBZ490GDE"}	2025-10-29 20:54:17.966-04	2025-10-29 20:54:18.009-04	\N
\.


--
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at) FROM stdin;
cart_01K8S0X34JT7SAJHSFNEHB351N	reg_01K8RWV2KZJZTEJ4K57MTBT8W8	cus_01K8S9FBF3R8RS3AMN86DY8BDD	sc_01K8RWK37J6CCAMVBZZ92TWT9W	nickdevmtl@gmail.com	cad	caaddr_01K8S9MBJR7D023DWAJBB8CB7J	caaddr_01K8S9MBJR3D6YFGG4DHG5B775	\N	2025-10-29 18:20:05.652-04	2025-10-29 20:52:53.396-04	\N	2025-10-29 20:52:53.366-04
cart_01K8SBJMS7XSKDZZM485TP0GC7	reg_01K8RWV2KZJZTEJ4K57MTBT8W8	cus_01K8S9QEMGH6G87E0MBZ490GDE	sc_01K8RWK37J6CCAMVBZZ92TWT9W	nickybcotroni@gmail.com	cad	\N	\N	\N	2025-10-29 21:26:37.607-04	2025-10-29 21:26:37.607-04	\N	\N
cart_01K8SH1PE63Q601VHNQZA62NG1	reg_01K8RWV2KZJZTEJ4K57MTBT8W8	\N	sc_01K8RWK37J6CCAMVBZZ92TWT9W	\N	cad	\N	\N	\N	2025-10-29 23:02:13.703-04	2025-10-29 23:02:13.703-04	\N	\N
cart_01K8W836W7FXR90W843S0KMT8D	reg_01K8RWV2KZJZTEJ4K57MTBT8W8	\N	sc_01K8RWK37J6CCAMVBZZ92TWT9W	\N	cad	\N	\N	\N	2025-10-31 00:23:29.418-04	2025-10-31 00:23:29.418-04	\N	\N
cart_01K8WKVCTWYY8KTF5N3YMAFYNN	reg_01K8RWV2KZJZTEJ4K57MTBT8W8	\N	sc_01K8RWK37J6CCAMVBZZ92TWT9W	\N	cad	caaddr_01K8WKVCTYGESE0X77929V750W	\N	\N	2025-10-31 03:48:56.287-04	2025-10-31 03:48:56.287-04	\N	\N
\.


--
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
caaddr_01K8S9FBFYBTD0J7QZCA1ZXS2S	\N		Nicky	Cotroni	212 Rue du Curé Lamothe		Terrebonne	ca	QC	J6W 5Y2		\N	2025-10-29 20:49:52.639-04	2025-10-29 20:49:52.639-04	\N
caaddr_01K8S9FBFYWTBCCBK5K4A1DPJJ	\N		Nicky	Cotroni	212 Rue du Curé Lamothe		Terrebonne	ca	QC	J6W 5Y2		\N	2025-10-29 20:49:52.639-04	2025-10-29 20:49:52.639-04	\N
caaddr_01K8S9MBJR3D6YFGG4DHG5B775	\N		Nicky	Cotroni	212 Rue du Curé Lamothe		Terrebonne	ca	QC	J6W 5Y2		\N	2025-10-29 20:52:36.568-04	2025-10-29 20:52:36.568-04	\N
caaddr_01K8S9MBJR7D023DWAJBB8CB7J	\N		Nicky	Cotroni	212 Rue du Curé Lamothe		Terrebonne	ca	QC	J6W 5Y2		\N	2025-10-29 20:52:36.568-04	2025-10-29 20:52:36.568-04	\N
caaddr_01K8WKVCTYGESE0X77929V750W	\N	\N	\N	\N	\N	\N	\N	ca	\N	\N	\N	\N	2025-10-31 03:48:56.287-04	2025-10-31 03:48:56.287-04	\N
\.


--
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, product_type_id, is_custom_price, is_giftcard) FROM stdin;
cali_01K8S0X3DGSM8JGHXYB3YNZY28	cart_01K8S0X34JT7SAJHSFNEHB351N	Medusa Shorts	M	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	1	variant_01K8RWK964XY0C8NYQJ48GA3P2	prod_01K8RWK93AZMVKX54EYJ9CY432	Medusa Shorts	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	\N	\N	\N	shorts	SHORTS-M	\N	M	\N	t	t	f	\N	\N	21	{"value": "21", "precision": 20}	{}	2025-10-29 18:20:05.937-04	2025-10-29 18:20:05.937-04	\N	\N	f	f
cali_01K8SBJN6X5SW3XYC5V4D2PVE3	cart_01K8SBJMS7XSKDZZM485TP0GC7	Medusa Sweatshirt	L	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	1	variant_01K8RWK963JJW66GZGZXM80AZ2	prod_01K8RWK93AARXJAGWJEB0XNZWQ	Medusa Sweatshirt	Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.	\N	\N	\N	sweatshirt	SWEATSHIRT-L	\N	L	\N	t	t	f	\N	\N	21	{"value": "21", "precision": 20}	{}	2025-10-29 21:26:38.045-04	2025-10-29 21:26:38.045-04	\N	\N	f	f
cali_01K8SH1PN8ZH794NSTHDB8GAMR	cart_01K8SH1PE63Q601VHNQZA62NG1	Medusa T-Shirt	M / Black	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	1	variant_01K8RWK962VBQ34NY0Y12S99VQ	prod_01K8RWK93AZFKK1971XQMTWAF9	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-M-BLACK	\N	M / Black	\N	t	t	f	\N	\N	21	{"value": "21", "precision": 20}	{}	2025-10-29 23:02:13.928-04	2025-10-29 23:02:13.929-04	\N	\N	f	f
cali_01K8W8376YKH8H1XJVWA02SVRR	cart_01K8W836W7FXR90W843S0KMT8D	Wi‑Fi Home Security Camera	Wi‑Fi Home Security Camera	http://localhost:9000/static/1761884595203-Wi-Fi-home-security-camera.png	1	variant_01K8W065270C1CM6A1PY23ZX2Q	prod_01K8W064XY5QK4C8TY2RWZAHS6	Wi‑Fi Home Security Camera	Indoor smart camera with motion alerts and two‑way audio via mobile app.	1080p night vision	\N	\N	wi-fi-home-security-camera	WI_FI_HOME_SECURITY_CAMERA	\N	Wi‑Fi Home Security Camera	\N	t	t	f	\N	\N	91	{"value": "91", "precision": 20}	{}	2025-10-31 00:23:29.759-04	2025-10-31 03:47:06.073-04	2025-10-31 03:47:06.07-04	\N	f	f
cali_01K8WKVD4NACB5XF7EHZ4FR0WK	cart_01K8WKVCTWYY8KTF5N3YMAFYNN	DIY Gel Nail Kit (Lamp)	DIY Gel Nail Kit (Lamp)	http://localhost:9000/static/1761882649607-nail-diy.png	1	variant_01K8W0652A5TFY2NEV9YDGDER4	prod_01K8W064XYATTAJY28DVHM06J2	DIY Gel Nail Kit (Lamp)	UV lamp, gels, and tools for long‑lasting manicures without the salon visit.	Salon nails at home	\N	Features	diy-gel-nail-kit-lamp	DIY_GEL_NAIL_KIT_LAMP	\N	DIY Gel Nail Kit (Lamp)	\N	t	t	f	\N	\N	119	{"value": "119", "precision": 20}	{}	2025-10-31 03:48:56.597-04	2025-10-31 03:48:56.597-04	\N	\N	f	f
\.


--
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
cart_01K8S0X34JT7SAJHSFNEHB351N	pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z	capaycol_01K8S9FSDE6MX6ZDR45DPHWFTP	2025-10-29 20:50:06.893925-04	2025-10-29 20:50:06.893925-04	\N
\.


--
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
casm_01K8S9FH87NAGQC6ATJ2PAHVY8	cart_01K8S0X34JT7SAJHSFNEHB351N	Express shipping America	\N	16	{"value": "16", "precision": 20}	f	so_01K8RX80M7TAWH26X3WFB4G73C	{}	\N	2025-10-29 20:49:58.535-04	2025-10-29 20:49:58.535-04	\N
\.


--
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: credit_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_line (id, cart_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2025-10-29 17:04:36.47-04	2025-10-29 17:04:36.47-04	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2025-10-29 17:04:36.472-04	2025-10-29 17:04:36.472-04	\N
eur	€	€	2	0	{"value": "0", "precision": 20}	Euro	2025-10-29 17:04:36.472-04	2025-10-29 17:04:36.472-04	\N
aed	AED	د.إ.‏	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2025-10-29 17:04:36.472-04	2025-10-29 17:04:36.472-04	\N
afn	Af	؋	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2025-10-29 17:04:36.472-04	2025-10-29 17:04:36.472-04	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2025-10-29 17:04:36.472-04	2025-10-29 17:04:36.472-04	\N
amd	AMD	դր.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2025-10-29 17:04:36.473-04	2025-10-29 17:04:36.473-04	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2025-10-29 17:04:36.473-04	2025-10-29 17:04:36.473-04	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2025-10-29 17:04:36.473-04	2025-10-29 17:04:36.473-04	\N
azn	man.	ман.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2025-10-29 17:04:36.473-04	2025-10-29 17:04:36.473-04	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
bdt	Tk	৳	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
bgn	BGN	лв.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
bhd	BD	د.ب.‏	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
byn	Br	руб.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
cny	CN¥	CN¥	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
crc	₡	₡	0	0	{"value": "0", "precision": 20}	Costa Rican Colón	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
czk	Kč	Kč	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
dzd	DA	د.ج.‏	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2025-10-29 17:04:36.474-04	2025-10-29 17:04:36.474-04	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
egp	EGP	ج.م.‏	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
gbp	£	£	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
ghs	GH₵	GH₵	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
ils	₪	₪	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
inr	Rs	₹	2	0	{"value": "0", "precision": 20}	Indian Rupee	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
iqd	IQD	د.ع.‏	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
irr	IRR	﷼	0	0	{"value": "0", "precision": 20}	Iranian Rial	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Króna	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
jod	JD	د.أ.‏	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
jpy	¥	￥	0	0	{"value": "0", "precision": 20}	Japanese Yen	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2025-10-29 17:04:36.475-04	2025-10-29 17:04:36.475-04	\N
khr	KHR	៛	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
krw	₩	₩	0	0	{"value": "0", "precision": 20}	South Korean Won	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
kwd	KD	د.ك.‏	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
kzt	KZT	тңг.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
lbp	LB£	ل.ل.‏	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
lyd	LD	د.ل.‏	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mad	MAD	د.م.‏	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mnt	MNT	₮	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mwk	K	K	2	0	{"value": "0", "precision": 20}	Malawian Kwacha	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
ngn	₦	₦	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan Córdoba	2025-10-29 17:04:36.476-04	2025-10-29 17:04:36.476-04	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
npr	NPRs	नेरू	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
omr	OMR	ر.ع.‏	3	0	{"value": "0", "precision": 20}	Omani Rial	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
php	₱	₱	2	0	{"value": "0", "precision": 20}	Philippine Peso	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
pkr	PKRs	₨	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
pln	zł	zł	2	0	{"value": "0", "precision": 20}	Polish Zloty	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
pyg	₲	₲	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
qar	QR	ر.ق.‏	2	0	{"value": "0", "precision": 20}	Qatari Rial	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
rsd	din.	дин.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
rub	RUB	₽.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
sar	SR	ر.س.‏	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
syp	SY£	ل.س.‏	0	0	{"value": "0", "precision": 20}	Syrian Pound	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
thb	฿	฿	2	0	{"value": "0", "precision": 20}	Thai Baht	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
tnd	DT	د.ت.‏	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Paʻanga	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
tjs	TJS	с.	2	0	{"value": "0", "precision": 20}	Tajikistani Somoni	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
try	₺	₺	2	0	{"value": "0", "precision": 20}	Turkish Lira	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2025-10-29 17:04:36.477-04	2025-10-29 17:04:36.477-04	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
uah	₴	₴	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bolívar	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
vnd	₫	₫	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
xpf	₣	₣	0	0	{"value": "0", "precision": 20}	CFP Franc	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
yer	YR	ر.ي.‏	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2025-10-29 17:04:36.478-04	2025-10-29 17:04:36.478-04	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
cus_01K8S9FBF3R8RS3AMN86DY8BDD	\N	\N	\N	nickdevmtl@gmail.com	\N	f	\N	2025-10-29 20:49:52.612-04	2025-10-29 20:49:52.612-04	\N	\N
cus_01K8S9QEMGH6G87E0MBZ490GDE	\N	Nicky	Cotroni	nickybcotroni@gmail.com		t	\N	2025-10-29 20:54:18-04	2025-10-29 20:54:18-04	\N	\N
\.


--
-- Data for Name: customer_account_holder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_account_holder (customer_id, account_holder_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
\.


--
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
manual_manual	t	2025-10-29 17:04:36.567-04	2025-10-29 17:04:36.567-04	\N
\.


--
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuset_01K8RWK8XDKXQ7J4CP8K15DSYY	European Warehouse delivery	shipping	\N	2025-10-29 17:04:49.582-04	2025-10-29 17:04:49.582-04	\N
\.


--
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.geo_zone (id, type, country_code, province_code, city, service_zone_id, postal_expression, metadata, created_at, updated_at, deleted_at) FROM stdin;
fgz_01K8RWZFKE5KYDQG66PPF21XF4	country	ca	\N	\N	serzo_01K8RWZFKEB2M08DT311ZFNANA	\N	\N	2025-10-29 17:11:29.646-04	2025-10-29 17:11:47.037-04	2025-10-29 17:11:47.024-04
fgz_01K8RWZFKEGES4TZZN91WV9VJ1	country	us	\N	\N	serzo_01K8RWZFKEB2M08DT311ZFNANA	\N	\N	2025-10-29 17:11:29.647-04	2025-10-29 17:11:47.037-04	2025-10-29 17:11:47.024-04
fgz_01K8RWZFKETCN191C9ANJKQKB2	country	mx	\N	\N	serzo_01K8RWZFKEB2M08DT311ZFNANA	\N	\N	2025-10-29 17:11:29.647-04	2025-10-29 17:11:47.037-04	2025-10-29 17:11:47.024-04
fgz_01K8RX1SXVVPRWAE0FFZYX8T3Z	country	ca	\N	\N	serzo_01K8RX1SXW3QDZBFH91WKWW4AH	\N	\N	2025-10-29 17:12:45.756-04	2025-10-29 17:12:45.756-04	\N
fgz_01K8RX1SXV340TS0Q21QRREC9D	country	us	\N	\N	serzo_01K8RX1SXW3QDZBFH91WKWW4AH	\N	\N	2025-10-29 17:12:45.756-04	2025-10-29 17:12:45.756-04	\N
fgz_01K8RWK8XC8VWATPA90RAGHBWZ	country	gb	\N	\N	serzo_01K8RWK8XD76QB7CXSEQJKJ43F	\N	\N	2025-10-29 17:04:49.582-04	2025-10-29 17:16:20.799-04	2025-10-29 17:16:20.79-04
fgz_01K8RWK8XDEX0Y6BQW44QRAP3W	country	de	\N	\N	serzo_01K8RWK8XD76QB7CXSEQJKJ43F	\N	\N	2025-10-29 17:04:49.582-04	2025-10-29 17:16:20.799-04	2025-10-29 17:16:20.79-04
fgz_01K8RWK8XD9J73GBAM6AKVW032	country	dk	\N	\N	serzo_01K8RWK8XD76QB7CXSEQJKJ43F	\N	\N	2025-10-29 17:04:49.582-04	2025-10-29 17:16:20.799-04	2025-10-29 17:16:20.79-04
fgz_01K8RWK8XDYAJBMKGYPJBRYNF1	country	se	\N	\N	serzo_01K8RWK8XD76QB7CXSEQJKJ43F	\N	\N	2025-10-29 17:04:49.582-04	2025-10-29 17:16:20.799-04	2025-10-29 17:16:20.79-04
fgz_01K8RWK8XDNQH8WZ109468X6VQ	country	fr	\N	\N	serzo_01K8RWK8XD76QB7CXSEQJKJ43F	\N	\N	2025-10-29 17:04:49.582-04	2025-10-29 17:16:20.799-04	2025-10-29 17:16:20.79-04
fgz_01K8RWK8XDSMFTDM64J6YXP9ZW	country	es	\N	\N	serzo_01K8RWK8XD76QB7CXSEQJKJ43F	\N	\N	2025-10-29 17:04:49.582-04	2025-10-29 17:16:20.799-04	2025-10-29 17:16:20.79-04
fgz_01K8RWK8XD6H01RC6CGG4SEV8Z	country	it	\N	\N	serzo_01K8RWK8XD76QB7CXSEQJKJ43F	\N	\N	2025-10-29 17:04:49.582-04	2025-10-29 17:16:20.799-04	2025-10-29 17:16:20.79-04
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.image (id, url, metadata, created_at, updated_at, deleted_at, rank, product_id) FROM stdin;
img_01K8RWK93F8WFF6DY3GT16V11H	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:04.583-04	2025-10-30 20:03:04.555-04	0	prod_01K8RWK93AARXJAGWJEB0XNZWQ
img_01K8RWK93F1KTT7QVE51606QP7	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-back.png	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:04.583-04	2025-10-30 20:03:04.555-04	1	prod_01K8RWK93AARXJAGWJEB0XNZWQ
img_01K8RWK93F6364Y8MPEXKNHMEJ	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:08.813-04	2025-10-30 20:03:08.795-04	0	prod_01K8RWK93AHB0YPPHFVCYB8BG7
img_01K8RWK93GPQQFVXNEC18756Y1	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-back.png	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:08.813-04	2025-10-30 20:03:08.795-04	1	prod_01K8RWK93AHB0YPPHFVCYB8BG7
img_01K8RWK93DTGESV5W7C0P63WBC	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.012-04	2025-10-30 20:03:12.988-04	0	prod_01K8RWK93AZFKK1971XQMTWAF9
img_01K8RWK93DDHKF2Y7305V8ZKQF	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-back.png	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.012-04	2025-10-30 20:03:12.988-04	1	prod_01K8RWK93AZFKK1971XQMTWAF9
img_01K8RWK93DXNR8TP605R4MJQHV	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-front.png	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.012-04	2025-10-30 20:03:12.988-04	2	prod_01K8RWK93AZFKK1971XQMTWAF9
img_01K8RWK93DFESH6E2XYBHZF3RX	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-back.png	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.012-04	2025-10-30 20:03:12.988-04	3	prod_01K8RWK93AZFKK1971XQMTWAF9
img_01K8RWK93G84SNE9366KGTXT94	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	\N	2025-10-29 17:04:49.779-04	2025-10-30 20:03:47.634-04	2025-10-30 20:03:47.624-04	0	prod_01K8RWK93AZMVKX54EYJ9CY432
img_01K8RWK93GYJCPNNA6BRYQATPQ	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-back.png	\N	2025-10-29 17:04:49.779-04	2025-10-30 20:03:47.634-04	2025-10-30 20:03:47.624-04	1	prod_01K8RWK93AZMVKX54EYJ9CY432
img_01K8VWV21TMG6WYV2M0KMTB25R	http://localhost:9000/static/1761872807970-photo-realistic_studio_shot_of_a_compact_white_portable.png	\N	2025-10-30 21:06:47.997-04	2025-10-30 21:06:47.997-04	\N	0	prod_01K8VWV21PMMKRCFKR5G6DQNQ0
img_01K8W064YEW2QW8KJCXHMY0Y1H	https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/photo-realistic_product_shot_of_an_electric_toothbrush_set.png	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N	0	prod_01K8W064XYPMJMK6X9V38D9K87
gosdzl	http://localhost:9000/static/1761881688752-photo-realistic_close-up_of_a_luxury_smartwatch_displaying_health.png	\N	2025-10-30 23:34:48.84-04	2025-10-30 23:34:48.84-04	\N	0	prod_01K8W064XYKNHD79C16Q47QB2A
4bkxb	http://localhost:9000/static/1761882066284-photo-realistic_close-up_of_a_rose-gold_automatic_cordless_hair.png	\N	2025-10-30 23:41:06.436-04	2025-10-30 23:41:06.436-04	\N	0	prod_01K8W064XY05GEZ6GGT5X5ASZK
vhyal1g	http://localhost:9000/static/1761882251313-Hot-mechanical%20keyboard-coders.png	\N	2025-10-30 23:44:11.42-04	2025-10-30 23:44:11.42-04	\N	0	prod_01K8W064XY30JJ3Q0DDR8THW7B
nuq1fn	http://localhost:9000/static/1761882322732-minimal_close-up_of_matte-white_wireless_earbuds_inside_open.png	\N	2025-10-30 23:45:22.776-04	2025-10-30 23:45:22.776-04	\N	0	prod_01K8W064XY6HG1PMB3JJ0PYKW5
xtkb6	http://localhost:9000/static/1761882649607-nail-diy.png	\N	2025-10-30 23:50:49.705-04	2025-10-30 23:50:49.705-04	\N	0	prod_01K8W064XYATTAJY28DVHM06J2
2vcy75	http://localhost:9000/static/1761882845498-robot-vacuum.png	\N	2025-10-30 23:54:05.549-04	2025-10-30 23:54:05.549-04	\N	0	prod_01K8W064XYGJZFVFVD6J3GTDC3
gi2exl	http://localhost:9000/static/1761883025608-headed-lunch-box.png	\N	2025-10-30 23:57:05.677-04	2025-10-30 23:57:05.677-04	\N	0	prod_01K8W064XYH7NDY4T5VCTV0NG5
hxeock	http://localhost:9000/static/1761883059943-studio_photo_of_a_black_percussion_massage_gun.png	\N	2025-10-30 23:57:40.002-04	2025-10-30 23:57:40.002-04	\N	0	prod_01K8W064XYHP34NB35S1BGY95X
cptsse	http://localhost:9000/static/1761883101112-transparent_portable_blender_bottle_filled_with_fruit_smoothie.png	\N	2025-10-30 23:58:21.172-04	2025-10-30 23:58:21.172-04	\N	0	prod_01K8W064XYRCYB06MGJ8VJ3X58
1tx8g	http://localhost:9000/static/1761883286789-led-mask.png	\N	2025-10-31 00:01:26.859-04	2025-10-31 00:01:26.859-04	\N	0	prod_01K8W064XYRKS2CDE7CJB1PWH7
tu4ap9	http://localhost:9000/static/1761883455822-pet-feeder.png	\N	2025-10-31 00:04:15.863-04	2025-10-31 00:04:15.864-04	\N	0	prod_01K8W064XYW7EXGT5DFC190M4B
dsqy4r	http://localhost:9000/static/1761883489790-full_product_photo_of_a_modern_height-adjustable_standing.png	\N	2025-10-31 00:04:49.842-04	2025-10-31 00:04:49.842-04	\N	0	prod_01K8W064XZ1MJ6K0GS6WWNHYTH
o7y5k	http://localhost:9000/static/1761883690315-heated-vest.png	\N	2025-10-31 00:08:10.371-04	2025-10-31 00:08:10.371-04	\N	0	prod_01K8W064XZ1QSPS8Y2FCFPN0RA
8bv9ui	http://localhost:9000/static/1761883865072-tech-backpack.png	\N	2025-10-31 00:11:05.149-04	2025-10-31 00:11:05.149-04	\N	0	prod_01K8W064XZBWW4VJSZCQH3W53Z
7qw6la	http://localhost:9000/static/1761884045435-ultrasonic-essential-oil-diffuser.png	\N	2025-10-31 00:14:05.48-04	2025-10-31 00:14:05.48-04	\N	0	prod_01K8W064XZDPX75E31RCV9BAAB
iow7cp	http://localhost:9000/static/1761884329891-Air-Purifier.png	\N	2025-10-31 00:18:49.963-04	2025-10-31 00:18:49.963-04	\N	0	prod_01K8W064XY6642XQKKF20ESTRN
vf2bnf	http://localhost:9000/static/1761884354686-Weighted-Blanket.png	\N	2025-10-31 00:19:14.75-04	2025-10-31 00:19:14.75-04	\N	0	prod_01K8W064XZG6F5JRWPZJW5EDRG
x43acq	http://localhost:9000/static/1761884595203-Wi-Fi-home-security-camera.png	\N	2025-10-31 00:23:15.287-04	2025-10-31 00:23:15.287-04	\N	0	prod_01K8W064XY5QK4C8TY2RWZAHS6
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
iitem_01K8RWK96YPKT6G65HSVTTFZXH	2025-10-29 17:04:49.887-04	2025-10-30 20:03:04.506-04	2025-10-30 20:03:04.504-04	SWEATSHIRT-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K8RWK96YXTHX73E378ZAFX47	2025-10-29 17:04:49.887-04	2025-10-30 20:03:04.517-04	2025-10-30 20:03:04.504-04	SWEATSHIRT-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K8RWK96X5EZP8B67TA1FW8B1	2025-10-29 17:04:49.887-04	2025-10-30 20:03:04.522-04	2025-10-30 20:03:04.504-04	SWEATSHIRT-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K8RWK96YCE9VA8JS16NXN1H5	2025-10-29 17:04:49.887-04	2025-10-30 20:03:04.527-04	2025-10-30 20:03:04.504-04	SWEATSHIRT-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K8RWK96Y82CAQDYNYGM35KBZ	2025-10-29 17:04:49.888-04	2025-10-30 20:03:08.75-04	2025-10-30 20:03:08.749-04	SWEATPANTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K8RWK96YFPC6VBW97AF5VN1M	2025-10-29 17:04:49.888-04	2025-10-30 20:03:08.758-04	2025-10-30 20:03:08.749-04	SWEATPANTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K8RWK96YM6Z0JG0GKFYB6E4J	2025-10-29 17:04:49.888-04	2025-10-30 20:03:08.764-04	2025-10-30 20:03:08.749-04	SWEATPANTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K8RWK96YESSXEVHHPH7JG2JA	2025-10-29 17:04:49.888-04	2025-10-30 20:03:08.769-04	2025-10-30 20:03:08.749-04	SWEATPANTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K8RWK96XC1P5YEPMCK19XJC0	2025-10-29 17:04:49.887-04	2025-10-30 20:03:12.926-04	2025-10-30 20:03:12.926-04	SHIRT-L-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	L / Black	L / Black	\N	\N
iitem_01K8RWK96X48CXNPVVFWXJ91B8	2025-10-29 17:04:49.887-04	2025-10-30 20:03:12.933-04	2025-10-30 20:03:12.926-04	SHIRT-L-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	L / White	L / White	\N	\N
iitem_01K8RWK96XWZZFSSVF8E02HS5S	2025-10-29 17:04:49.887-04	2025-10-30 20:03:12.939-04	2025-10-30 20:03:12.926-04	SHIRT-M-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	M / Black	M / Black	\N	\N
iitem_01K8RWK96XZ67G7ES5HCD57YZW	2025-10-29 17:04:49.887-04	2025-10-30 20:03:12.943-04	2025-10-30 20:03:12.926-04	SHIRT-M-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	M / White	M / White	\N	\N
iitem_01K8RWK96WA4XH1X8ARFAFQWRT	2025-10-29 17:04:49.887-04	2025-10-30 20:03:12.947-04	2025-10-30 20:03:12.926-04	SHIRT-S-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	S / Black	S / Black	\N	\N
iitem_01K8RWK96X7WW5K2SN9E0BN516	2025-10-29 17:04:49.887-04	2025-10-30 20:03:12.954-04	2025-10-30 20:03:12.926-04	SHIRT-S-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	S / White	S / White	\N	\N
iitem_01K8RWK96X5HXW33WA962J44C4	2025-10-29 17:04:49.887-04	2025-10-30 20:03:12.959-04	2025-10-30 20:03:12.926-04	SHIRT-XL-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / Black	XL / Black	\N	\N
iitem_01K8RWK96X1XV708Z6815FW03A	2025-10-29 17:04:49.887-04	2025-10-30 20:03:12.964-04	2025-10-30 20:03:12.926-04	SHIRT-XL-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / White	XL / White	\N	\N
iitem_01K8RWK96ZB0YWN3P3T01TFS8S	2025-10-29 17:04:49.888-04	2025-10-30 20:03:47.59-04	2025-10-30 20:03:47.59-04	SHORTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K8RWK96YY04FDCW2WRSNW05E	2025-10-29 17:04:49.888-04	2025-10-30 20:03:47.594-04	2025-10-30 20:03:47.59-04	SHORTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K8RWK96YF4MX3EWDKSBSY92P	2025-10-29 17:04:49.888-04	2025-10-30 20:03:47.6-04	2025-10-30 20:03:47.59-04	SHORTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K8RWK96Z403SDGGJ4DCVSC29	2025-10-29 17:04:49.888-04	2025-10-30 20:03:47.606-04	2025-10-30 20:03:47.59-04	SHORTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K8VWV25TFKASPCCCAKMQRBQA	2025-10-30 21:06:48.122-04	2025-10-30 21:08:23.894-04	\N	NICK-PORTABLE-MINI-PROJ-003	\N	\N	\N	\N	600	14	6	10	t	Default variant	Default variant	\N	\N
iitem_01K8W06537GGS8YJF6AZBWXQV0	2025-10-30 22:05:17.29-04	2025-10-30 22:05:17.29-04	\N	SMARTWATCH_BUDGET_FRIENDLY	\N	\N	\N	\N	180	10	5	10	t	Smartwatch (Budget-Friendly)	Smartwatch (Budget-Friendly)	\N	\N
iitem_01K8W06537Q0K8XJY9AND8BQ48	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	WIRELESS_EARBUDS_NOISE_CANCELLING	\N	\N	\N	\N	60	7	4	5	t	Wireless Earbuds (Noise-Cancelling)	Wireless Earbuds (Noise-Cancelling)	\N	\N
iitem_01K8W065377JGA2KFRYSRZRTB0	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	RGB_MECHANICAL_KEYBOARD	\N	\N	\N	\N	900	45	4	15	t	RGB Mechanical Keyboard	RGB Mechanical Keyboard	\N	\N
iitem_01K8W06537BBZNNX63DH83ZS6C	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	WI_FI_HOME_SECURITY_CAMERA	\N	\N	\N	\N	200	7	11	7	t	Wi‑Fi Home Security Camera	Wi‑Fi Home Security Camera	\N	\N
iitem_01K8W06537YSQ0XD0A98ARK5M2	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	ROBOT_VACUUM_CLEANER	\N	\N	\N	\N	3800	35	9	35	t	Robot Vacuum Cleaner	Robot Vacuum Cleaner	\N	\N
iitem_01K8W06538H48FKKJ5T6KJM4Z1	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	AIR_PURIFIER	\N	\N	\N	\N	2700	22	35	22	t	Air Purifier	Air Purifier	\N	\N
iitem_01K8W06538JA376QA9KKBD9FZW	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	AUTOMATIC_PET_FEEDER	\N	\N	\N	\N	2200	20	32	20	t	Automatic Pet Feeder	Automatic Pet Feeder	\N	\N
iitem_01K8W06538M4R3ZRZP8FJ1NZEY	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	PORTABLE_BLENDER_USB	\N	\N	\N	\N	650	8	24	8	t	Portable Blender (USB)	Portable Blender (USB)	\N	\N
iitem_01K8W06538JZJMZK8PZJE05NZ3	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	ELECTRIC_HEATED_LUNCH_BOX	\N	\N	\N	\N	1200	24	12	17	t	Electric Heated Lunch Box	Electric Heated Lunch Box	\N	\N
iitem_01K8W065395KS7F3AK0D6F1B0S	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	LED_LIGHT_THERAPY_FACIAL_MASK	\N	\N	\N	\N	700	21	11	17	t	LED Light Therapy Facial Mask	LED Light Therapy Facial Mask	\N	\N
iitem_01K8W06539FC4WPB5H20QF8V72	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	PERCUSSION_MASSAGE_GUN	\N	\N	\N	\N	1200	25	10	20	t	Percussion Massage Gun	Percussion Massage Gun	\N	\N
iitem_01K8W06539DCHFVTNSQVN8PFAK	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	WATER_FLOSSER_ORAL_IRRIGATOR	\N	\N	\N	\N	400	7	28	7	t	Water Flosser (Oral Irrigator)	Water Flosser (Oral Irrigator)	\N	\N
iitem_01K8W0653947DY1QTD1AJRWKCG	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	HAIR_STRAIGHTENER_BRUSH	\N	\N	\N	\N	520	28	5	6	t	Hair Straightener Brush	Hair Straightener Brush	\N	\N
iitem_01K8W06539D3QQNN63FBNYVRC1	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	DIY_GEL_NAIL_KIT_LAMP	\N	\N	\N	\N	1500	26	9	22	t	DIY Gel Nail Kit (Lamp)	DIY Gel Nail Kit (Lamp)	\N	\N
iitem_01K8W06539RP0T582E2RAMS5VJ	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	WEIGHTED_BLANKET_15_20_LB	\N	\N	\N	\N	8000	40	25	30	t	Weighted Blanket (15–20 lb)	Weighted Blanket (15–20 lb)	\N	\N
iitem_01K8W0653A6F4BB0YXX31E64AD	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	STANDING_DESK_CONVERTER	\N	\N	\N	\N	12000	80	15	40	t	Standing Desk Converter	Standing Desk Converter	\N	\N
iitem_01K8W0653ADR9CWTC8X4V8PG81	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	TECH_FRIENDLY_LAPTOP_BACKPACK	\N	\N	\N	\N	900	46	15	30	t	Tech‑Friendly Laptop Backpack	Tech‑Friendly Laptop Backpack	\N	\N
iitem_01K8W0653AMPMGR1NN70G9D3DM	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	HEATED_VEST_USB	\N	\N	\N	\N	700	35	5	28	t	Heated Vest (USB)	Heated Vest (USB)	\N	\N
iitem_01K8W0653AQX1D0Z4PQBXDZPCW	2025-10-30 22:05:17.291-04	2025-10-30 22:05:17.291-04	\N	ESSENTIAL_OIL_DIFFUSER_HUMIDIFIER	\N	\N	\N	\N	700	17	20	17	t	Essential Oil Diffuser & Humidifier	Essential Oil Diffuser & Humidifier	\N	\N
\.


--
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
ilev_01K8RWK9AF8VXTHVGBW2VNN2M8	2025-10-29 17:04:50-04	2025-10-30 20:03:04.516-04	2025-10-30 20:03:04.504-04	iitem_01K8RWK96YPKT6G65HSVTTFZXH	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AFQJ1VFXBR5GJEDZ8R	2025-10-29 17:04:50-04	2025-10-30 20:03:04.522-04	2025-10-30 20:03:04.504-04	iitem_01K8RWK96YXTHX73E378ZAFX47	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9ADPHJD4X0ZTFBEHWDH	2025-10-29 17:04:50-04	2025-10-30 20:03:04.527-04	2025-10-30 20:03:04.504-04	iitem_01K8RWK96X5EZP8B67TA1FW8B1	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AENBGX6Q7M9AVA6J6Q	2025-10-29 17:04:50-04	2025-10-30 20:03:04.532-04	2025-10-30 20:03:04.504-04	iitem_01K8RWK96YCE9VA8JS16NXN1H5	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AEXES80NPK8PZ6V42Y	2025-10-29 17:04:50-04	2025-10-30 20:03:08.758-04	2025-10-30 20:03:08.749-04	iitem_01K8RWK96Y82CAQDYNYGM35KBZ	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AEBEMG5C4D4789CDRS	2025-10-29 17:04:50-04	2025-10-30 20:03:08.764-04	2025-10-30 20:03:08.749-04	iitem_01K8RWK96YFPC6VBW97AF5VN1M	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AEJJKZZCZJ2ZW7XPA4	2025-10-29 17:04:50-04	2025-10-30 20:03:08.769-04	2025-10-30 20:03:08.749-04	iitem_01K8RWK96YM6Z0JG0GKFYB6E4J	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AEBG3H4NNJGFEG4PF7	2025-10-29 17:04:50-04	2025-10-30 20:03:08.774-04	2025-10-30 20:03:08.749-04	iitem_01K8RWK96YESSXEVHHPH7JG2JA	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AE0QEQPWMHBRAXMCJF	2025-10-29 17:04:50-04	2025-10-30 20:03:12.933-04	2025-10-30 20:03:12.926-04	iitem_01K8RWK96XC1P5YEPMCK19XJC0	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AD7M6Z8V8SQ3WJG42G	2025-10-29 17:04:49.999-04	2025-10-30 20:03:12.939-04	2025-10-30 20:03:12.926-04	iitem_01K8RWK96X48CXNPVVFWXJ91B8	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AERMQ7S26K1H8NSW62	2025-10-29 17:04:50-04	2025-10-30 20:03:12.943-04	2025-10-30 20:03:12.926-04	iitem_01K8RWK96XWZZFSSVF8E02HS5S	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AE4ZVT9D5H25FCNAQ2	2025-10-29 17:04:50-04	2025-10-30 20:03:12.947-04	2025-10-30 20:03:12.926-04	iitem_01K8RWK96XZ67G7ES5HCD57YZW	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9ADXAZFE2RH442C5QP8	2025-10-29 17:04:49.999-04	2025-10-30 20:03:12.953-04	2025-10-30 20:03:12.926-04	iitem_01K8RWK96WA4XH1X8ARFAFQWRT	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AD8RF8YFVVX1GGHGK9	2025-10-29 17:04:50-04	2025-10-30 20:03:12.958-04	2025-10-30 20:03:12.926-04	iitem_01K8RWK96X7WW5K2SN9E0BN516	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AFTPD5BYDCT2D4XJFV	2025-10-29 17:04:50-04	2025-10-30 20:03:47.594-04	2025-10-30 20:03:47.59-04	iitem_01K8RWK96ZB0YWN3P3T01TFS8S	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AFMRB8TGTCW8QP83BJ	2025-10-29 17:04:50-04	2025-10-30 20:03:47.6-04	2025-10-30 20:03:47.59-04	iitem_01K8RWK96YY04FDCW2WRSNW05E	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AER9PZ1GTJYGS8SDB9	2025-10-29 17:04:50-04	2025-10-30 20:03:47.606-04	2025-10-30 20:03:47.59-04	iitem_01K8RWK96YF4MX3EWDKSBSY92P	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AF473RYSW0FKAPEJ08	2025-10-29 17:04:50-04	2025-10-30 20:03:47.61-04	2025-10-30 20:03:47.59-04	iitem_01K8RWK96Z403SDGGJ4DCVSC29	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9AD14JZE72252BJ9Q11	2025-10-29 17:04:50-04	2025-10-30 20:03:12.964-04	2025-10-30 20:03:12.926-04	iitem_01K8RWK96X5HXW33WA962J44C4	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8RWK9ADR3HN2NPNRZSD37RQ	2025-10-29 17:04:49.999-04	2025-10-30 20:03:12.97-04	2025-10-30 20:03:12.926-04	iitem_01K8RWK96X1XV708Z6815FW03A	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8VWVT0ZJMJFT3EV28WECAHE	2025-10-30 21:07:12.543-04	2025-10-30 21:07:25.366-04	\N	iitem_01K8VWV25TFKASPCCCAKMQRBQA	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0Q951J0G36VAHERP5SJWR	2025-10-30 22:14:38.498-04	2025-10-30 22:14:51.959-04	\N	iitem_01K8W0653947DY1QTD1AJRWKCG	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB5EQ0347XE4YJR7XEJ	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W065377JGA2KFRYSRZRTB0	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB8473BQ513AZ8SKM4Y	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06537BBZNNX63DH83ZS6C	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB81SA0TP1JGWXBB895	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06537GGS8YJF6AZBWXQV0	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB9CCYE201TDCBCTTJS	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06537Q0K8XJY9AND8BQ48	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB9WYJ2NNE7TJX9W4JP	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06537YSQ0XD0A98ARK5M2	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB99X51WZJ10KKFYXY1	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06538H48FKKJ5T6KJM4Z1	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB9AFJEM3AX4FVAKX8G	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06538JA376QA9KKBD9FZW	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB9TK4V99JYKTHXTJ8Q	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06538JZJMZK8PZJE05NZ3	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB958NYNRS5TN6TJNYG	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06538M4R3ZRZP8FJ1NZEY	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB9GGN6YPC54NY4GX6D	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W065395KS7F3AK0D6F1B0S	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB9XTX5JC1XK4QWYJM0	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06539D3QQNN63FBNYVRC1	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYB901D8Q6178WFPAF99	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06539DCHFVTNSQVN8PFAK	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYBAM7Q5JMTD3WD1TTSV	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06539FC4WPB5H20QF8V72	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYBA98BQA319S8NZ63E2	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W06539RP0T582E2RAMS5VJ	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYBAKBSKD5W795281PJ8	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W0653A6F4BB0YXX31E64AD	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYBADJY87PHJRMJ0GH48	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W0653ADR9CWTC8X4V8PG81	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYBAFDMDYNW1K4CXK6EJ	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W0653AMPMGR1NN70G9D3DM	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K8W0RYBA6BR4KZT4YCX4VN8H	2025-10-30 22:15:32.971-04	2025-10-30 22:15:32.971-04	\N	iitem_01K8W0653AQX1D0Z4PQBXDZPCW	sloc_01K8RWK8WE14BXV69T1XPA5YSK	100	0	0	\N	{"value": "100", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
\.


--
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
invite_01K8RWK392BWF2F9S6E0EFAC9E	admin@medusa-test.com	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Imludml0ZV8wMUs4UldLMzkyQldGMkY5UzZFMEVGQUM5RSIsImVtYWlsIjoiYWRtaW5AbWVkdXNhLXRlc3QuY29tIiwiaWF0IjoxNzYxNzcxODgzLCJleHAiOjE3NjE4NTgyODMsImp0aSI6ImQ3NzE0ZjliLTgxMmItNDhlYi05OGIwLWY0OTdmZDJiMzAxZCJ9.2wsT3hhJXCZDZsfQjE3YKjGXkm1Xe2ICOYzsdce5mAY	2025-10-30 17:04:43.81-04	\N	2025-10-29 17:04:43.814-04	2025-10-29 17:06:04.405-04	2025-10-29 17:06:04.404-04
\.


--
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_module_migrations (id, table_name, link_descriptor, created_at) FROM stdin;
1	cart_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "cart", "fromModule": "cart"}	2025-10-29 17:04:32.444735
2	location_fulfillment_provider	{"toModel": "fulfillment_provider", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-10-29 17:04:32.461118
3	location_fulfillment_set	{"toModel": "fulfillment_set", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-10-29 17:04:32.462299
4	order_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "order", "fromModule": "order"}	2025-10-29 17:04:32.475992
5	order_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "order", "fromModule": "order"}	2025-10-29 17:04:32.47952
6	order_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "order", "fromModule": "order"}	2025-10-29 17:04:32.479055
7	order_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "order", "fromModule": "order"}	2025-10-29 17:04:32.488929
8	return_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "return", "fromModule": "order"}	2025-10-29 17:04:32.491846
9	product_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "product", "fromModule": "product"}	2025-10-29 17:04:32.494743
10	product_variant_inventory_item	{"toModel": "inventory", "toModule": "inventory", "fromModel": "variant", "fromModule": "product"}	2025-10-29 17:04:32.496678
11	product_variant_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "variant", "fromModule": "product"}	2025-10-29 17:04:32.502881
13	region_payment_provider	{"toModel": "payment_provider", "toModule": "payment", "fromModel": "region", "fromModule": "region"}	2025-10-29 17:04:32.506955
12	publishable_api_key_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "api_key", "fromModule": "api_key"}	2025-10-29 17:04:32.505635
14	sales_channel_stock_location	{"toModel": "location", "toModule": "stock_location", "fromModel": "sales_channel", "fromModule": "sales_channel"}	2025-10-29 17:04:32.50953
15	shipping_option_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "shipping_option", "fromModule": "fulfillment"}	2025-10-29 17:04:32.510557
16	product_shipping_profile	{"toModel": "shipping_profile", "toModule": "fulfillment", "fromModel": "product", "fromModule": "product"}	2025-10-29 17:04:32.518245
17	customer_account_holder	{"toModel": "account_holder", "toModule": "payment", "fromModel": "customer", "fromModule": "customer"}	2025-10-29 17:04:32.5209
18	cart_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "cart", "fromModule": "cart"}	2025-10-29 17:04:32.524652
\.


--
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K8RWK8WE14BXV69T1XPA5YSK	manual_manual	locfp_01K8RWK8X08J1KEQ764KMQV0VZ	2025-10-29 17:04:49.568001-04	2025-10-29 17:04:49.568001-04	\N
\.


--
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K8RWK8WE14BXV69T1XPA5YSK	fuset_01K8RWK8XDKXQ7J4CP8K15DSYY	locfs_01K8RWK8Y2A7XBEEVCZXR1SET6	2025-10-29 17:04:49.60224-04	2025-10-29 17:04:49.60224-04	\N
\.


--
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20240307161216	2025-10-29 17:04:26.232009-04
2	Migration20241210073813	2025-10-29 17:04:26.232009-04
3	Migration20250106142624	2025-10-29 17:04:26.232009-04
4	Migration20250120110820	2025-10-29 17:04:26.232009-04
5	Migration20240307132720	2025-10-29 17:04:26.358609-04
6	Migration20240719123015	2025-10-29 17:04:26.358609-04
7	Migration20241213063611	2025-10-29 17:04:26.358609-04
8	Migration20251010131115	2025-10-29 17:04:26.358609-04
9	InitialSetup20240401153642	2025-10-29 17:04:26.538487-04
10	Migration20240601111544	2025-10-29 17:04:26.538487-04
11	Migration202408271511	2025-10-29 17:04:26.538487-04
12	Migration20241122120331	2025-10-29 17:04:26.538487-04
13	Migration20241125090957	2025-10-29 17:04:26.538487-04
14	Migration20250411073236	2025-10-29 17:04:26.538487-04
15	Migration20250516081326	2025-10-29 17:04:26.538487-04
16	Migration20250910154539	2025-10-29 17:04:26.538487-04
17	Migration20250911092221	2025-10-29 17:04:26.538487-04
18	Migration20251011090511	2025-10-29 17:04:26.538487-04
19	Migration20230929122253	2025-10-29 17:04:26.857385-04
20	Migration20240322094407	2025-10-29 17:04:26.857385-04
21	Migration20240322113359	2025-10-29 17:04:26.857385-04
22	Migration20240322120125	2025-10-29 17:04:26.857385-04
23	Migration20240626133555	2025-10-29 17:04:26.857385-04
24	Migration20240704094505	2025-10-29 17:04:26.857385-04
25	Migration20241127114534	2025-10-29 17:04:26.857385-04
26	Migration20241127223829	2025-10-29 17:04:26.857385-04
27	Migration20241128055359	2025-10-29 17:04:26.857385-04
28	Migration20241212190401	2025-10-29 17:04:26.857385-04
29	Migration20250408145122	2025-10-29 17:04:26.857385-04
30	Migration20250409122219	2025-10-29 17:04:26.857385-04
31	Migration20251009110625	2025-10-29 17:04:26.857385-04
32	Migration20240227120221	2025-10-29 17:04:27.163753-04
33	Migration20240617102917	2025-10-29 17:04:27.163753-04
34	Migration20240624153824	2025-10-29 17:04:27.163753-04
35	Migration20241211061114	2025-10-29 17:04:27.163753-04
36	Migration20250113094144	2025-10-29 17:04:27.163753-04
37	Migration20250120110700	2025-10-29 17:04:27.163753-04
38	Migration20250226130616	2025-10-29 17:04:27.163753-04
39	Migration20250508081510	2025-10-29 17:04:27.163753-04
40	Migration20250828075407	2025-10-29 17:04:27.163753-04
41	Migration20250909083125	2025-10-29 17:04:27.163753-04
42	Migration20250916120552	2025-10-29 17:04:27.163753-04
43	Migration20250917143818	2025-10-29 17:04:27.163753-04
44	Migration20250919122137	2025-10-29 17:04:27.163753-04
45	Migration20251006000000	2025-10-29 17:04:27.163753-04
46	Migration20240124154000	2025-10-29 17:04:27.455092-04
47	Migration20240524123112	2025-10-29 17:04:27.455092-04
48	Migration20240602110946	2025-10-29 17:04:27.455092-04
49	Migration20241211074630	2025-10-29 17:04:27.455092-04
50	Migration20251010130829	2025-10-29 17:04:27.455092-04
51	Migration20240115152146	2025-10-29 17:04:27.594436-04
52	Migration20240222170223	2025-10-29 17:04:27.675341-04
53	Migration20240831125857	2025-10-29 17:04:27.675341-04
54	Migration20241106085918	2025-10-29 17:04:27.675341-04
55	Migration20241205095237	2025-10-29 17:04:27.675341-04
56	Migration20241216183049	2025-10-29 17:04:27.675341-04
57	Migration20241218091938	2025-10-29 17:04:27.675341-04
58	Migration20250120115059	2025-10-29 17:04:27.675341-04
59	Migration20250212131240	2025-10-29 17:04:27.675341-04
60	Migration20250326151602	2025-10-29 17:04:27.675341-04
61	Migration20250508081553	2025-10-29 17:04:27.675341-04
62	Migration20251017153909	2025-10-29 17:04:27.675341-04
63	Migration20240205173216	2025-10-29 17:04:27.906735-04
64	Migration20240624200006	2025-10-29 17:04:27.906735-04
65	Migration20250120110744	2025-10-29 17:04:27.906735-04
66	InitialSetup20240221144943	2025-10-29 17:04:28.023029-04
67	Migration20240604080145	2025-10-29 17:04:28.023029-04
68	Migration20241205122700	2025-10-29 17:04:28.023029-04
69	Migration20251015123842	2025-10-29 17:04:28.023029-04
70	InitialSetup20240227075933	2025-10-29 17:04:28.11594-04
71	Migration20240621145944	2025-10-29 17:04:28.11594-04
72	Migration20241206083313	2025-10-29 17:04:28.11594-04
73	Migration20240227090331	2025-10-29 17:04:28.212172-04
74	Migration20240710135844	2025-10-29 17:04:28.212172-04
75	Migration20240924114005	2025-10-29 17:04:28.212172-04
76	Migration20241212052837	2025-10-29 17:04:28.212172-04
77	InitialSetup20240228133303	2025-10-29 17:04:28.365584-04
78	Migration20240624082354	2025-10-29 17:04:28.365584-04
79	Migration20240225134525	2025-10-29 17:04:28.445929-04
80	Migration20240806072619	2025-10-29 17:04:28.445929-04
81	Migration20241211151053	2025-10-29 17:04:28.445929-04
82	Migration20250115160517	2025-10-29 17:04:28.445929-04
83	Migration20250120110552	2025-10-29 17:04:28.445929-04
84	Migration20250123122334	2025-10-29 17:04:28.445929-04
85	Migration20250206105639	2025-10-29 17:04:28.445929-04
86	Migration20250207132723	2025-10-29 17:04:28.445929-04
87	Migration20250625084134	2025-10-29 17:04:28.445929-04
88	Migration20250924135437	2025-10-29 17:04:28.445929-04
89	Migration20250929124701	2025-10-29 17:04:28.445929-04
90	Migration20240219102530	2025-10-29 17:04:28.650856-04
91	Migration20240604100512	2025-10-29 17:04:28.650856-04
92	Migration20240715102100	2025-10-29 17:04:28.650856-04
93	Migration20240715174100	2025-10-29 17:04:28.650856-04
94	Migration20240716081800	2025-10-29 17:04:28.650856-04
95	Migration20240801085921	2025-10-29 17:04:28.650856-04
96	Migration20240821164505	2025-10-29 17:04:28.650856-04
97	Migration20240821170920	2025-10-29 17:04:28.650856-04
98	Migration20240827133639	2025-10-29 17:04:28.650856-04
99	Migration20240902195921	2025-10-29 17:04:28.650856-04
100	Migration20240913092514	2025-10-29 17:04:28.650856-04
101	Migration20240930122627	2025-10-29 17:04:28.650856-04
102	Migration20241014142943	2025-10-29 17:04:28.650856-04
103	Migration20241106085223	2025-10-29 17:04:28.650856-04
104	Migration20241129124827	2025-10-29 17:04:28.650856-04
105	Migration20241217162224	2025-10-29 17:04:28.650856-04
106	Migration20250326151554	2025-10-29 17:04:28.650856-04
107	Migration20250522181137	2025-10-29 17:04:28.650856-04
108	Migration20250702095353	2025-10-29 17:04:28.650856-04
109	Migration20250704120229	2025-10-29 17:04:28.650856-04
110	Migration20250910130000	2025-10-29 17:04:28.650856-04
111	Migration20251016182939	2025-10-29 17:04:28.650856-04
112	Migration20251017155709	2025-10-29 17:04:28.650856-04
113	Migration20250717162007	2025-10-29 17:04:29.188191-04
114	Migration20240205025928	2025-10-29 17:04:29.28083-04
115	Migration20240529080336	2025-10-29 17:04:29.28083-04
116	Migration20241202100304	2025-10-29 17:04:29.28083-04
117	Migration20240214033943	2025-10-29 17:04:29.53478-04
118	Migration20240703095850	2025-10-29 17:04:29.53478-04
119	Migration20241202103352	2025-10-29 17:04:29.53478-04
120	Migration20240311145700_InitialSetupMigration	2025-10-29 17:04:29.657627-04
121	Migration20240821170957	2025-10-29 17:04:29.657627-04
122	Migration20240917161003	2025-10-29 17:04:29.657627-04
123	Migration20241217110416	2025-10-29 17:04:29.657627-04
124	Migration20250113122235	2025-10-29 17:04:29.657627-04
125	Migration20250120115002	2025-10-29 17:04:29.657627-04
126	Migration20250822130931	2025-10-29 17:04:29.657627-04
127	Migration20250825132614	2025-10-29 17:04:29.657627-04
128	Migration20240509083918_InitialSetupMigration	2025-10-29 17:04:30.146277-04
129	Migration20240628075401	2025-10-29 17:04:30.146277-04
130	Migration20240830094712	2025-10-29 17:04:30.146277-04
131	Migration20250120110514	2025-10-29 17:04:30.146277-04
132	Migration20231228143900	2025-10-29 17:04:30.615809-04
133	Migration20241206101446	2025-10-29 17:04:30.615809-04
134	Migration20250128174331	2025-10-29 17:04:30.615809-04
135	Migration20250505092459	2025-10-29 17:04:30.615809-04
136	Migration20250819104213	2025-10-29 17:04:30.615809-04
137	Migration20250819110924	2025-10-29 17:04:30.615809-04
138	Migration20250908080305	2025-10-29 17:04:30.615809-04
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status) FROM stdin;
noti_01K8VTRQWNZJ3Q1H7TQ7QHHYR4		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file products_medusa_ready_drop_variant_id.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-30 20:30:34.902-04	2025-10-30 20:30:34.911-04	\N	success
noti_01K8VVC21VQ7836FX3F1DBK7MP		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file products_medusa_ready_drop_variant_id.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-30 20:41:07.9-04	2025-10-30 20:41:07.91-04	\N	success
noti_01K8VVJMK72G0H6R8HN7XDQX1P		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file products_medusa_ready_drop_variant_id.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-30 20:44:43.495-04	2025-10-30 20:44:43.505-04	\N	success
noti_01K8VWYDMP4MHJZ5ZSF7VGBHVP		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1761872918138-1761872918138-product-exports.csv", "filename": "1761872918138-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-30 21:08:38.167-04	2025-10-30 21:08:38.177-04	\N	success
noti_01K8VX6QVW6067G7PBHEAW6YJA		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file products_medusa_ready_drop_variant_id.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-30 21:13:10.781-04	2025-10-30 21:13:10.791-04	\N	success
noti_01K8VZEDS61JY423ZAZ74GNN7Z		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file medusa_products_csv-new.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2025-10-30 21:52:19.751-04	2025-10-30 21:52:19.773-04	\N	success
\.


--
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2025-10-29 17:04:36.576-04	2025-10-29 17:04:36.576-04	\N
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at) FROM stdin;
order_01K8S9MVWM4KDN1M9RZHTZJHYW	reg_01K8RWV2KZJZTEJ4K57MTBT8W8	1	cus_01K8S9FBF3R8RS3AMN86DY8BDD	2	sc_01K8RWK37J6CCAMVBZZ92TWT9W	canceled	f	nickdevmtl@gmail.com	cad	ordaddr_01K8S9MVWC9R11GFW2500X6ZD7	ordaddr_01K8S9MVWC2H6HE5EWK8YWRPPK	f	\N	2025-10-29 20:52:53.273-04	2025-10-30 20:03:28.896-04	\N	2025-10-30 20:03:28.893-04
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
ordaddr_01K8S9MVWC2H6HE5EWK8YWRPPK	\N		Nicky	Cotroni	212 Rue du Curé Lamothe		Terrebonne	ca	QC	J6W 5Y2		\N	2025-10-29 20:52:36.568-04	2025-10-29 20:52:36.568-04	\N
ordaddr_01K8S9MVWC9R11GFW2500X6ZD7	\N		Nicky	Cotroni	212 Rue du Curé Lamothe		Terrebonne	ca	QC	J6W 5Y2		\N	2025-10-29 20:52:36.568-04	2025-10-29 20:52:36.568-04	\N
\.


--
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01K8S9MVWM4KDN1M9RZHTZJHYW	cart_01K8S0X34JT7SAJHSFNEHB351N	ordercart_01K8S9MW0DTQM4FKYAFXQ312VC	2025-10-29 20:52:53.389796-04	2025-10-29 20:52:53.389796-04	\N
\.


--
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordch_01K8VS73VR44VMW9P31S3VC361	order_01K8S9MVWM4KDN1M9RZHTZJHYW	2	\N	confirmed	\N	\N	\N	\N	\N	2025-10-30 20:03:28.826-04	\N	\N	\N	\N	\N	\N	2025-10-30 20:03:28.761-04	2025-10-30 20:03:28.859-04	credit_line	\N	\N	\N	\N
\.


--
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordchact_01K8VS73WZ0BDB03KB6E96010T	order_01K8S9MVWM4KDN1M9RZHTZJHYW	2	1	ordch_01K8VS73VR44VMW9P31S3VC361	payment_collection	pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z	CREDIT_LINE_ADD	{}	37	{"value": "37", "precision": 20}	\N	t	2025-10-30 20:03:28.8-04	2025-10-30 20:03:28.876-04	\N	\N	\N	\N
\.


--
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_credit_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_credit_line (id, order_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at, version) FROM stdin;
ordcl_01K8VS73YVFW5TKBJFNJK6RXMW	order_01K8S9MVWM4KDN1M9RZHTZJHYW	payment_collection	pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z	37	{"value": "37", "precision": 20}	\N	2025-10-30 20:03:28.86-04	2025-10-30 20:03:28.86-04	\N	2
\.


--
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
orditem_01K8S9MVWQ8023ZSNAPB63HYB2	order_01K8S9MVWM4KDN1M9RZHTZJHYW	1	ordli_01K8S9MVWPTNGCR7BC4K9G7P7H	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-10-29 20:52:53.273-04	2025-10-29 20:52:53.273-04	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K8VS73YSKKH24DCED40EVCXA	order_01K8S9MVWM4KDN1M9RZHTZJHYW	2	ordli_01K8S9MVWPTNGCR7BC4K9G7P7H	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-10-30 20:03:28.859-04	2025-10-30 20:03:28.859-04	\N	0	{"value": "0", "precision": 20}	21	{"value": "21", "precision": 20}	\N	\N
\.


--
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price, product_type_id, is_giftcard) FROM stdin;
ordli_01K8S9MVWPTNGCR7BC4K9G7P7H	\N	Medusa Shorts	M	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	variant_01K8RWK964XY0C8NYQJ48GA3P2	prod_01K8RWK93AZMVKX54EYJ9CY432	Medusa Shorts	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	\N	\N	\N	shorts	SHORTS-M	\N	M	\N	t	t	f	\N	\N	21	{"value": "21", "precision": 20}	{}	2025-10-29 20:52:53.273-04	2025-10-29 20:52:53.273-04	\N	f	\N	f
\.


--
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01K8S9MVWM4KDN1M9RZHTZJHYW	pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z	ordpay_01K8S9MW0NNEB1H8P04Q28ZDJ1	2025-10-29 20:52:53.389901-04	2025-10-29 20:52:53.389901-04	\N
\.


--
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordspmv_01K8S9MVWKXP9PVYX96SBHZAZW	order_01K8S9MVWM4KDN1M9RZHTZJHYW	1	ordsm_01K8S9MVWKE9P4RKX3GVWHTRE2	2025-10-29 20:52:53.274-04	2025-10-29 20:52:53.274-04	\N	\N	\N	\N
ordspmv_01K8VS73YT3E25H0NZ50EQA23E	order_01K8S9MVWM4KDN1M9RZHTZJHYW	2	ordsm_01K8S9MVWKE9P4RKX3GVWHTRE2	2025-10-29 20:52:53.274-04	2025-10-29 20:52:53.274-04	\N	\N	\N	\N
\.


--
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
ordsm_01K8S9MVWKE9P4RKX3GVWHTRE2	Express shipping America	\N	16	{"value": "16", "precision": 20}	f	so_01K8RX80M7TAWH26X3WFB4G73C	{}	\N	2025-10-29 20:52:53.274-04	2025-10-29 20:52:53.274-04	\N	f
\.


--
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_summary (id, order_id, version, totals, created_at, updated_at, deleted_at) FROM stdin;
ordsum_01K8S9MVWH5NYRM6713KTHSYWE	order_01K8S9MVWM4KDN1M9RZHTZJHYW	1	{"paid_total": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "accounting_total": 37, "credit_line_total": 0, "transaction_total": 0, "pending_difference": 37, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 37, "original_order_total": 37, "raw_accounting_total": {"value": "37", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "37", "precision": 20}, "raw_current_order_total": {"value": "37", "precision": 20}, "raw_original_order_total": {"value": "37", "precision": 20}}	2025-10-29 20:52:53.273-04	2025-10-29 20:52:53.273-04	\N
ordsum_01K8VS73YT0BZ06QVHXR3NJMRD	order_01K8S9MVWM4KDN1M9RZHTZJHYW	2	{"paid_total": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "accounting_total": 0, "credit_line_total": 37, "transaction_total": 0, "pending_difference": 0, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 0, "original_order_total": 37, "raw_accounting_total": {"value": "0", "precision": 20}, "raw_credit_line_total": {"value": "37", "precision": 20}, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "0", "precision": 20}, "raw_current_order_total": {"value": "0", "precision": 20}, "raw_original_order_total": {"value": "37", "precision": 20}}	2025-10-30 20:03:28.86-04	2025-10-30 20:03:28.86-04	\N
\.


--
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
pay_01K8S9MW1V1Y9CF6Q3RZFYP0RH	37	{"value": "37", "precision": 20}	cad	pp_system_default	{}	2025-10-29 20:52:53.435-04	2025-10-30 20:03:28.713-04	\N	\N	2025-10-30 20:03:28.694-04	pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z	payses_01K8S9FSEWAZ08S1VXM0VVCX2J	\N
\.


--
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z	cad	37	{"value": "37", "precision": 20}	37	{"value": "37", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	2025-10-29 20:50:06.88-04	2025-10-30 20:03:28.886-04	\N	\N	canceled	\N
\.


--
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
pp_system_default	t	2025-10-29 17:04:36.571-04	2025-10-29 17:04:36.571-04	\N
\.


--
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
payses_01K8S9FSEWAZ08S1VXM0VVCX2J	cad	37	{"value": "37", "precision": 20}	pp_system_default	{}	{}	authorized	2025-10-29 20:52:53.429-04	pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z	{}	2025-10-29 20:50:06.94-04	2025-10-29 20:52:53.435-04	\N
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price (id, title, price_set_id, currency_code, raw_amount, rules_count, created_at, updated_at, deleted_at, price_list_id, amount, min_quantity, max_quantity) FROM stdin;
price_01K8RWK905M9KYCFGWR5X10DBE	\N	pset_01K8RWK906SXWNTXQ7WTDFAZ9D	usd	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.672-04	2025-10-29 17:04:49.672-04	\N	\N	10	\N	\N
price_01K8RWK905G90B723XKT5WN11A	\N	pset_01K8RWK906SXWNTXQ7WTDFAZ9D	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.672-04	2025-10-29 17:04:49.672-04	\N	\N	10	\N	\N
price_01K8RWK9060X496GPRN9GNEM4K	\N	pset_01K8RWK906SXWNTXQ7WTDFAZ9D	eur	{"value": "10", "precision": 20}	1	2025-10-29 17:04:49.672-04	2025-10-29 17:04:49.672-04	\N	\N	10	\N	\N
price_01K8RWK907BM63KX4RZGT5DYYJ	\N	pset_01K8RWK907DSRA8QSDRCTQPMS7	usd	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.672-04	2025-10-29 17:04:49.672-04	\N	\N	10	\N	\N
price_01K8RWK907TD61SBBY7EN1NFQP	\N	pset_01K8RWK907DSRA8QSDRCTQPMS7	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.672-04	2025-10-29 17:04:49.672-04	\N	\N	10	\N	\N
price_01K8RWK9074VBCTS38T5P1DKPC	\N	pset_01K8RWK907DSRA8QSDRCTQPMS7	eur	{"value": "10", "precision": 20}	1	2025-10-29 17:04:49.672-04	2025-10-29 17:04:49.672-04	\N	\N	10	\N	\N
price_01K8W1NJTE0C3M5EDGJA6B2Y84	\N	pset_01K8W0654EXEVHRYCZA017WP3X	cad	{"value": "137", "precision": 20}	0	2025-10-30 22:31:11.447-04	2025-10-30 22:31:11.447-04	\N	\N	137	\N	\N
price_01K8W1NJTE4Y9BT2ZWG40N80AP	\N	pset_01K8W0654EXEVHRYCZA017WP3X	usd	{"value": "149", "precision": 20}	0	2025-10-30 22:31:11.447-04	2025-10-30 22:31:11.447-04	\N	\N	149	\N	\N
price_01K8W1NJWXAAPYFPHYAGQ6DEZY	\N	pset_01K8W0654E3T02TFE7KXJC7V7R	cad	{"value": "109", "precision": 20}	0	2025-10-30 22:31:11.522-04	2025-10-30 22:31:11.522-04	\N	\N	109	\N	\N
price_01K8W1NJWX82M86ANQKWY6E889	\N	pset_01K8W0654E3T02TFE7KXJC7V7R	usd	{"value": "119", "precision": 20}	0	2025-10-30 22:31:11.522-04	2025-10-30 22:31:11.522-04	\N	\N	119	\N	\N
price_01K8W1NJYXPBEXZ710BQHJG27C	\N	pset_01K8VWV26SXSQGK5BPG5BPNRQJ	cad	{"value": "229", "precision": 20}	0	2025-10-30 22:31:11.586-04	2025-10-30 22:31:11.586-04	\N	\N	229	\N	\N
price_01K8W1NJYX1C0EEYCHHQHX49K5	\N	pset_01K8VWV26SXSQGK5BPG5BPNRQJ	usd	{"value": "249", "precision": 20}	0	2025-10-30 22:31:11.586-04	2025-10-30 22:31:11.586-04	\N	\N	249	\N	\N
price_01K8W1NK0X2RB50MXWXF47Y8M3	\N	pset_01K8W0654F23SCEAGVZD9ZGDSJ	cad	{"value": "128", "precision": 20}	0	2025-10-30 22:31:11.65-04	2025-10-30 22:31:11.65-04	\N	\N	128	\N	\N
price_01K8W1NK0X7S373EE9JDN4Y2HH	\N	pset_01K8W0654F23SCEAGVZD9ZGDSJ	usd	{"value": "139", "precision": 20}	0	2025-10-30 22:31:11.65-04	2025-10-30 22:31:11.65-04	\N	\N	139	\N	\N
price_01K8W1NK2VSWEGVKJP6HN313PJ	\N	pset_01K8W0654FD9G8TSC1H30P2G7Q	cad	{"value": "91", "precision": 20}	0	2025-10-30 22:31:11.713-04	2025-10-30 22:31:11.713-04	\N	\N	91	\N	\N
price_01K8W1NK2W5H5BY99Q3Q8WCE0W	\N	pset_01K8W0654FD9G8TSC1H30P2G7Q	usd	{"value": "99", "precision": 20}	0	2025-10-30 22:31:11.713-04	2025-10-30 22:31:11.713-04	\N	\N	99	\N	\N
price_01K8W1NK4S1NMWMVKR2JWTTSWD	\N	pset_01K8W0654FTGH0MJ3FJZKD464G	cad	{"value": "321", "precision": 20}	0	2025-10-30 22:31:11.773-04	2025-10-30 22:31:11.773-04	\N	\N	321	\N	\N
price_01K8W1NK4SD85877YSTQ2AYX4R	\N	pset_01K8W0654FTGH0MJ3FJZKD464G	usd	{"value": "349", "precision": 20}	0	2025-10-30 22:31:11.774-04	2025-10-30 22:31:11.774-04	\N	\N	349	\N	\N
price_01K8W1NK6N6F97JT1SK1M6734S	\N	pset_01K8W0654GYXV4JW0PF12BMHPR	cad	{"value": "146", "precision": 20}	0	2025-10-30 22:31:11.833-04	2025-10-30 22:31:11.833-04	\N	\N	146	\N	\N
price_01K8W1NK6NX4DZ8TDGW1SBSQXF	\N	pset_01K8W0654GYXV4JW0PF12BMHPR	usd	{"value": "159", "precision": 20}	0	2025-10-30 22:31:11.833-04	2025-10-30 22:31:11.833-04	\N	\N	159	\N	\N
price_01K8W1NK8G2WP0HW9KH01MKEZ7	\N	pset_01K8W0654GEWZQ6RPAPTMGBRJV	cad	{"value": "137", "precision": 20}	0	2025-10-30 22:31:11.894-04	2025-10-30 22:31:11.894-04	\N	\N	137	\N	\N
price_01K8RWK984NGTBCBYFXBVM5KPZ	\N	pset_01K8RWK984M5GPQCJMAAZYH35T	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:08.82-04	2025-10-30 20:03:08.809-04	\N	10	\N	\N
price_01K8RWK9848R6XXY6TP6R0VVKZ	\N	pset_01K8RWK984M5GPQCJMAAZYH35T	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:08.82-04	2025-10-30 20:03:08.809-04	\N	15	\N	\N
price_01K8RWK9859G4PJP6YJ28ZXKMN	\N	pset_01K8RWK985JG9TKXHQP5ZF0WWZ	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:08.834-04	2025-10-30 20:03:08.809-04	\N	10	\N	\N
price_01K8RWK985Y5N7DQ1KHWB7V98H	\N	pset_01K8RWK985JG9TKXHQP5ZF0WWZ	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:08.834-04	2025-10-30 20:03:08.809-04	\N	15	\N	\N
price_01K8RWK985SBX0V3BSM0MDJFXW	\N	pset_01K8RWK98508SFQ80Q1NPF62PM	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:08.844-04	2025-10-30 20:03:08.809-04	\N	10	\N	\N
price_01K8RWK9856433RQYNA3M2GBND	\N	pset_01K8RWK98508SFQ80Q1NPF62PM	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:08.844-04	2025-10-30 20:03:08.809-04	\N	15	\N	\N
price_01K8RWK9851FVE4D5YA2TJACF3	\N	pset_01K8RWK985Y2WP6X7WRXDCDX5C	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:08.853-04	2025-10-30 20:03:08.809-04	\N	10	\N	\N
price_01K8RWK980H6XN11SHAP9GP7DX	\N	pset_01K8RWK9817J0196P1DDTK73KR	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.013-04	2025-10-30 20:03:12.999-04	\N	10	\N	\N
price_01K8RWK9809FB59GQ3QV6VSJCK	\N	pset_01K8RWK9817J0196P1DDTK73KR	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.013-04	2025-10-30 20:03:12.999-04	\N	15	\N	\N
price_01K8RWK9811QC5HA18M79FJ6X6	\N	pset_01K8RWK981V27RVV0GRCRANPJC	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.033-04	2025-10-30 20:03:12.999-04	\N	10	\N	\N
price_01K8RWK9813JYGJKK9SRCP2CWT	\N	pset_01K8RWK981V27RVV0GRCRANPJC	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.034-04	2025-10-30 20:03:12.999-04	\N	15	\N	\N
price_01K8RWK981YSJMHW1H4NAHE24Z	\N	pset_01K8RWK981S6XY7Q76R1CBGGW2	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.049-04	2025-10-30 20:03:12.999-04	\N	10	\N	\N
price_01K8RWK981CBKDBPWWAZDD3V15	\N	pset_01K8RWK981S6XY7Q76R1CBGGW2	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.049-04	2025-10-30 20:03:12.999-04	\N	15	\N	\N
price_01K8RWK982G5Q1ZM46MFNHPX5Z	\N	pset_01K8RWK982PM59PM2DJVVPWRCJ	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.062-04	2025-10-30 20:03:12.999-04	\N	10	\N	\N
price_01K8RWK982RFFB2G7ST33W550Q	\N	pset_01K8RWK982PM59PM2DJVVPWRCJ	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.062-04	2025-10-30 20:03:12.999-04	\N	15	\N	\N
price_01K8RWK98596D4XN00P9848G3F	\N	pset_01K8RWK985MWNQ3KJNJQXWM72S	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:47.65-04	2025-10-30 20:03:47.642-04	\N	10	\N	\N
price_01K8RWK98589ZFPT637B7C5CET	\N	pset_01K8RWK985MWNQ3KJNJQXWM72S	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:47.65-04	2025-10-30 20:03:47.642-04	\N	15	\N	\N
price_01K8RWK9868ABMH16DNS9FRTYM	\N	pset_01K8RWK986C3N31J7VS4XV6AXW	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:47.664-04	2025-10-30 20:03:47.642-04	\N	10	\N	\N
price_01K8RWK986K649A56WV6KK7906	\N	pset_01K8RWK986C3N31J7VS4XV6AXW	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:47.664-04	2025-10-30 20:03:47.642-04	\N	15	\N	\N
price_01K8RWK9860J4Q66N48T5HP3ER	\N	pset_01K8RWK986D93TDRPFNJWXE2NB	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:47.673-04	2025-10-30 20:03:47.642-04	\N	10	\N	\N
price_01K8RWK986264TPPA5E44N55NM	\N	pset_01K8RWK986D93TDRPFNJWXE2NB	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:47.673-04	2025-10-30 20:03:47.642-04	\N	15	\N	\N
price_01K8RWK986HNKH7CX48DNFM7RS	\N	pset_01K8RWK986RVHNVR149MFCWVMV	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:47.681-04	2025-10-30 20:03:47.642-04	\N	10	\N	\N
price_01K8RX49B9JJ0WJWTVK9E0EMWF	\N	pset_01K8RX49BAQ0SXGDD3KWS74YV7	cad	{"value": "12", "precision": 20}	0	2025-10-29 17:14:07.082-04	2025-10-29 17:14:07.082-04	\N	\N	12	\N	\N
price_01K8RX49B9WG70QZ6FZHNT3RHM	\N	pset_01K8RX49BAQ0SXGDD3KWS74YV7	usd	{"value": "9", "precision": 20}	0	2025-10-29 17:14:07.082-04	2025-10-29 17:14:07.082-04	\N	\N	9	\N	\N
price_01K8RX6A84SWY3RAYB64EGXMTM	\N	pset_01K8RX6A850BT8AWJ0RDE8HW2N	cad	{"value": "16", "precision": 20}	0	2025-10-29 17:15:13.541-04	2025-10-29 17:15:41.411-04	2025-10-29 17:15:41.404-04	\N	16	\N	\N
price_01K8RX6A85FJ9N7CPQGDSKWT95	\N	pset_01K8RX6A850BT8AWJ0RDE8HW2N	usd	{"value": "12.5", "precision": 20}	0	2025-10-29 17:15:13.541-04	2025-10-29 17:15:41.411-04	2025-10-29 17:15:41.404-04	\N	12.5	\N	\N
price_01K8RX80MPEJY9YW45V76Z2H1D	\N	pset_01K8RX80MPR7YQRP37JDM1VT56	cad	{"value": "16", "precision": 20}	0	2025-10-29 17:16:09.238-04	2025-10-29 17:16:09.238-04	\N	\N	16	\N	\N
price_01K8RX80MPHCGHZ64Q8HEKNRVE	\N	pset_01K8RX80MPR7YQRP37JDM1VT56	usd	{"value": "12.5", "precision": 20}	0	2025-10-29 17:16:09.238-04	2025-10-29 17:16:09.238-04	\N	\N	12.5	\N	\N
price_01K8RWK9830069N5HMK5VJ4BNB	\N	pset_01K8RWK98371PFPKNGJBRDGAMK	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.593-04	2025-10-30 20:03:04.575-04	\N	10	\N	\N
price_01K8RWK983RXYZT0SN32D2FTES	\N	pset_01K8RWK98371PFPKNGJBRDGAMK	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.594-04	2025-10-30 20:03:04.575-04	\N	15	\N	\N
price_01K8RXBQFSKAVRD0S7D9EPQKBW	\N	pset_01K8RWK98371PFPKNGJBRDGAMK	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:18:10.941-04	2025-10-30 20:03:04.594-04	2025-10-30 20:03:04.575-04	\N	21	\N	\N
price_01K8RWK983BYATREX9C0D7FDVP	\N	pset_01K8RWK984MGKX1HQ6WDAFGWJ8	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.615-04	2025-10-30 20:03:04.575-04	\N	10	\N	\N
price_01K8RWK984W3EE1ZCCFPXJM5FT	\N	pset_01K8RWK984MGKX1HQ6WDAFGWJ8	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.615-04	2025-10-30 20:03:04.575-04	\N	15	\N	\N
price_01K8RXBQFTVKNJDT52ZZHY8D1P	\N	pset_01K8RWK984MGKX1HQ6WDAFGWJ8	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:18:10.941-04	2025-10-30 20:03:04.615-04	2025-10-30 20:03:04.575-04	\N	21	\N	\N
price_01K8RWK984C4Z524ASDH56FAMV	\N	pset_01K8RWK984RGHQ9F8JPSA8QYYC	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.626-04	2025-10-30 20:03:04.575-04	\N	10	\N	\N
price_01K8RWK984SRD59HHWN52DVPF3	\N	pset_01K8RWK984RGHQ9F8JPSA8QYYC	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.626-04	2025-10-30 20:03:04.575-04	\N	15	\N	\N
price_01K8RXBQFTGHK6NRA27PTFP62P	\N	pset_01K8RWK984RGHQ9F8JPSA8QYYC	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:18:10.941-04	2025-10-30 20:03:04.626-04	2025-10-30 20:03:04.575-04	\N	21	\N	\N
price_01K8RWK984Q6YS29APD83TVNYG	\N	pset_01K8RWK984KJ26SW7GQ17K0MFS	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.636-04	2025-10-30 20:03:04.575-04	\N	10	\N	\N
price_01K8RWK984J3RJ8JHHEC78QVFB	\N	pset_01K8RWK984KJ26SW7GQ17K0MFS	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.636-04	2025-10-30 20:03:04.575-04	\N	15	\N	\N
price_01K8RXBQFR6FCNNB951J0EYJAK	\N	pset_01K8RWK984KJ26SW7GQ17K0MFS	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:18:10.941-04	2025-10-30 20:03:04.636-04	2025-10-30 20:03:04.575-04	\N	21	\N	\N
price_01K8RXCTMB638KX273Y890879F	\N	pset_01K8RWK984M5GPQCJMAAZYH35T	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:18:46.924-04	2025-10-30 20:03:08.82-04	2025-10-30 20:03:08.809-04	\N	21	\N	\N
price_01K8RXCTMCR6Q4CA84DTYGB9AP	\N	pset_01K8RWK985JG9TKXHQP5ZF0WWZ	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:18:46.924-04	2025-10-30 20:03:08.834-04	2025-10-30 20:03:08.809-04	\N	21	\N	\N
price_01K8RXCTMCEZAPMT8GDXN0G1H7	\N	pset_01K8RWK98508SFQ80Q1NPF62PM	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:18:46.925-04	2025-10-30 20:03:08.844-04	2025-10-30 20:03:08.809-04	\N	21	\N	\N
price_01K8RWK985TT2QR4PBSCKD6CPG	\N	pset_01K8RWK985Y2WP6X7WRXDCDX5C	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:08.853-04	2025-10-30 20:03:08.809-04	\N	15	\N	\N
price_01K8RXCTMCKTW0WFM7B2XM3CG9	\N	pset_01K8RWK985Y2WP6X7WRXDCDX5C	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:18:46.925-04	2025-10-30 20:03:08.853-04	2025-10-30 20:03:08.809-04	\N	21	\N	\N
price_01K8RXDPFTB1Q02FBJJV9RYZ5Q	\N	pset_01K8RWK9817J0196P1DDTK73KR	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:15.451-04	2025-10-30 20:03:13.013-04	2025-10-30 20:03:12.999-04	\N	21	\N	\N
price_01K8RXDPFT4M66PYWM2QPF1EFP	\N	pset_01K8RWK981V27RVV0GRCRANPJC	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:15.451-04	2025-10-30 20:03:13.034-04	2025-10-30 20:03:12.999-04	\N	21	\N	\N
price_01K8RXDPFVT0HF68EPAXNTEA6B	\N	pset_01K8RWK981S6XY7Q76R1CBGGW2	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:15.452-04	2025-10-30 20:03:13.049-04	2025-10-30 20:03:12.999-04	\N	21	\N	\N
price_01K8RXDPFTFGS7J7AJYF99XYF1	\N	pset_01K8RWK982PM59PM2DJVVPWRCJ	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:15.452-04	2025-10-30 20:03:13.062-04	2025-10-30 20:03:12.999-04	\N	21	\N	\N
price_01K8RWK982APQNT1KST0X8GJ67	\N	pset_01K8RWK98263FD26M7KGKZ0CJX	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.084-04	2025-10-30 20:03:12.999-04	\N	10	\N	\N
price_01K8RWK982BJJGFRH7A5TAS9V1	\N	pset_01K8RWK98263FD26M7KGKZ0CJX	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.084-04	2025-10-30 20:03:12.999-04	\N	15	\N	\N
price_01K8RXDPFTG9DH8HYSYZQEC2XM	\N	pset_01K8RWK98263FD26M7KGKZ0CJX	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:15.452-04	2025-10-30 20:03:13.084-04	2025-10-30 20:03:12.999-04	\N	21	\N	\N
price_01K8RXEAPPXXWCFJMR4EG366GA	\N	pset_01K8RWK985MWNQ3KJNJQXWM72S	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:36.151-04	2025-10-30 20:03:47.652-04	2025-10-30 20:03:47.642-04	\N	21	\N	\N
price_01K8RXEAPQRZKQTZ8BBPQYQG6J	\N	pset_01K8RWK986C3N31J7VS4XV6AXW	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:36.151-04	2025-10-30 20:03:47.664-04	2025-10-30 20:03:47.642-04	\N	21	\N	\N
price_01K8RXEAPQF8GCCH35J5RHTJSQ	\N	pset_01K8RWK986D93TDRPFNJWXE2NB	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:36.151-04	2025-10-30 20:03:47.673-04	2025-10-30 20:03:47.642-04	\N	21	\N	\N
price_01K8RWK986M0DBS90SP8Q2RQGP	\N	pset_01K8RWK986RVHNVR149MFCWVMV	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.928-04	2025-10-30 20:03:47.681-04	2025-10-30 20:03:47.642-04	\N	15	\N	\N
price_01K8RXEAPPRT56VYK889QDK4NF	\N	pset_01K8RWK986RVHNVR149MFCWVMV	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:36.151-04	2025-10-30 20:03:47.682-04	2025-10-30 20:03:47.642-04	\N	21	\N	\N
price_01K8RWK982ZY8VYVFQEWG369D1	\N	pset_01K8RWK98206JF2TQGYZMTH8PS	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.096-04	2025-10-30 20:03:12.999-04	\N	10	\N	\N
price_01K8RWK982TGJB1AKVMA2W9649	\N	pset_01K8RWK98206JF2TQGYZMTH8PS	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.096-04	2025-10-30 20:03:12.999-04	\N	15	\N	\N
price_01K8RXDPFV5RDPZDGECD3Z919W	\N	pset_01K8RWK98206JF2TQGYZMTH8PS	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:15.452-04	2025-10-30 20:03:13.096-04	2025-10-30 20:03:12.999-04	\N	21	\N	\N
price_01K8RWK9832AA3RVYE1WY25BB2	\N	pset_01K8RWK983JSC3BSA7T6RJYVE6	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.107-04	2025-10-30 20:03:12.999-04	\N	10	\N	\N
price_01K8RWK983SMYN5YYPPZF818JP	\N	pset_01K8RWK983JSC3BSA7T6RJYVE6	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.107-04	2025-10-30 20:03:12.999-04	\N	15	\N	\N
price_01K8RXDPFVPF62EFQNR5RD7ZNF	\N	pset_01K8RWK983JSC3BSA7T6RJYVE6	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:15.452-04	2025-10-30 20:03:13.107-04	2025-10-30 20:03:12.999-04	\N	21	\N	\N
price_01K8RWK983X8BXFEJNMGERVA1D	\N	pset_01K8RWK983BNC2QWBG84MMT1ZF	eur	{"value": "10", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.117-04	2025-10-30 20:03:12.999-04	\N	10	\N	\N
price_01K8RWK9839D30WS2940RE9ZBF	\N	pset_01K8RWK983BNC2QWBG84MMT1ZF	usd	{"value": "15", "precision": 20}	0	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.117-04	2025-10-30 20:03:12.999-04	\N	15	\N	\N
price_01K8RXDPFTCWEC5HNRB72GVKGB	\N	pset_01K8RWK983BNC2QWBG84MMT1ZF	cad	{"value": "21", "precision": 20}	0	2025-10-29 17:19:15.451-04	2025-10-30 20:03:13.117-04	2025-10-30 20:03:12.999-04	\N	21	\N	\N
price_01K8W1NK8GQSE6JJ19PQA6BWAW	\N	pset_01K8W0654GEWZQ6RPAPTMGBRJV	usd	{"value": "149", "precision": 20}	0	2025-10-30 22:31:11.894-04	2025-10-30 22:31:11.894-04	\N	\N	149	\N	\N
price_01K8W1NKAV19QT4RR7GKZ20GHJ	\N	pset_01K8W0654GTMTKKESJ0P6FACWY	cad	{"value": "91", "precision": 20}	0	2025-10-30 22:31:11.971-04	2025-10-30 22:31:11.971-04	\N	\N	91	\N	\N
price_01K8W1NKAVVYZPK85PNPTW4GEB	\N	pset_01K8W0654GTMTKKESJ0P6FACWY	usd	{"value": "99", "precision": 20}	0	2025-10-30 22:31:11.971-04	2025-10-30 22:31:11.971-04	\N	\N	99	\N	\N
price_01K8W1NKD425RPSW0YMBEE3HV9	\N	pset_01K8W0654H096T6X2BA6HW0MXM	cad	{"value": "100", "precision": 20}	0	2025-10-30 22:31:12.041-04	2025-10-30 22:31:12.041-04	\N	\N	100	\N	\N
price_01K8W1NKD4XP7CA442P9G2FYB9	\N	pset_01K8W0654H096T6X2BA6HW0MXM	usd	{"value": "109", "precision": 20}	0	2025-10-30 22:31:12.041-04	2025-10-30 22:31:12.041-04	\N	\N	109	\N	\N
price_01K8W1NKFHAXJF666XDCHBG7PN	\N	pset_01K8W0654JCFQXN5V6F1NJYHQK	cad	{"value": "183", "precision": 20}	0	2025-10-30 22:31:12.121-04	2025-10-30 22:31:12.121-04	\N	\N	183	\N	\N
price_01K8W1NKFH3J1V2PM5730DB5FW	\N	pset_01K8W0654JCFQXN5V6F1NJYHQK	usd	{"value": "199", "precision": 20}	0	2025-10-30 22:31:12.121-04	2025-10-30 22:31:12.121-04	\N	\N	199	\N	\N
price_01K8W1NKJB0ZE7BSNA9RACGV54	\N	pset_01K8W0654JK89ZQMJW7XAFRTDB	cad	{"value": "211", "precision": 20}	0	2025-10-30 22:31:12.21-04	2025-10-30 22:31:12.21-04	\N	\N	211	\N	\N
price_01K8W1NKJBZGFPZC12REE0JC6B	\N	pset_01K8W0654JK89ZQMJW7XAFRTDB	usd	{"value": "229", "precision": 20}	0	2025-10-30 22:31:12.21-04	2025-10-30 22:31:12.21-04	\N	\N	229	\N	\N
price_01K8W1NKMQ67RJK5YD7DSAHV5M	\N	pset_01K8W0654KWBJHZDY56CMY4DFG	cad	{"value": "109", "precision": 20}	0	2025-10-30 22:31:12.283-04	2025-10-30 22:31:12.283-04	\N	\N	109	\N	\N
price_01K8W1NKMQN278ZHA0WJAE6YCD	\N	pset_01K8W0654KWBJHZDY56CMY4DFG	usd	{"value": "119", "precision": 20}	0	2025-10-30 22:31:12.283-04	2025-10-30 22:31:12.283-04	\N	\N	119	\N	\N
price_01K8W1NKPPDCY2670BZX0NP4BN	\N	pset_01K8W0654K418VNRCE3B109X8F	cad	{"value": "119", "precision": 20}	0	2025-10-30 22:31:12.347-04	2025-10-30 22:31:12.347-04	\N	\N	119	\N	\N
price_01K8W1NKPPEQQGYB27PA21NY2X	\N	pset_01K8W0654K418VNRCE3B109X8F	usd	{"value": "129", "precision": 20}	0	2025-10-30 22:31:12.347-04	2025-10-30 22:31:12.347-04	\N	\N	129	\N	\N
price_01K8W1NKRQ78TVP1XG50R7F124	\N	pset_01K8W0654KX698B7THEQZKHDP8	cad	{"value": "119", "precision": 20}	0	2025-10-30 22:31:12.412-04	2025-10-30 22:31:12.412-04	\N	\N	119	\N	\N
price_01K8W1NKRQZ6XPMDX4W89NAJTM	\N	pset_01K8W0654KX698B7THEQZKHDP8	usd	{"value": "129", "precision": 20}	0	2025-10-30 22:31:12.412-04	2025-10-30 22:31:12.412-04	\N	\N	129	\N	\N
price_01K8W1NKTH9KTX475BADGNWFFD	\N	pset_01K8W0654M6FGSJCJGBY314874	cad	{"value": "183", "precision": 20}	0	2025-10-30 22:31:12.47-04	2025-10-30 22:31:12.47-04	\N	\N	183	\N	\N
price_01K8W1NKTH782GJN6EZE8TGPW7	\N	pset_01K8W0654M6FGSJCJGBY314874	usd	{"value": "199", "precision": 20}	0	2025-10-30 22:31:12.47-04	2025-10-30 22:31:12.47-04	\N	\N	199	\N	\N
price_01K8W1NKW7T4SR7NRWGS0W7E6A	\N	pset_01K8W0654MKGSAGVN6KRA35RP4	cad	{"value": "257", "precision": 20}	0	2025-10-30 22:31:12.523-04	2025-10-30 22:31:12.523-04	\N	\N	257	\N	\N
price_01K8W1NKW7JQF283KASXECK9Q1	\N	pset_01K8W0654MKGSAGVN6KRA35RP4	usd	{"value": "279", "precision": 20}	0	2025-10-30 22:31:12.523-04	2025-10-30 22:31:12.523-04	\N	\N	279	\N	\N
price_01K8W1NKXTSVR2X5DB75QDGWWA	\N	pset_01K8W0654MYPN3P54Q6MFHWQBV	cad	{"value": "119", "precision": 20}	0	2025-10-30 22:31:12.574-04	2025-10-30 22:31:12.574-04	\N	\N	119	\N	\N
price_01K8W1NKXTTSTBBA8K0RRTTH8Z	\N	pset_01K8W0654MYPN3P54Q6MFHWQBV	usd	{"value": "129", "precision": 20}	0	2025-10-30 22:31:12.574-04	2025-10-30 22:31:12.574-04	\N	\N	129	\N	\N
price_01K8W1NKZKMA4VWSK07HDHZY4F	\N	pset_01K8W0654M0FX8YD9FHRPA5CF2	cad	{"value": "155", "precision": 20}	0	2025-10-30 22:31:12.631-04	2025-10-30 22:31:12.631-04	\N	\N	155	\N	\N
price_01K8W1NKZKHR1SZR2QQPX070TW	\N	pset_01K8W0654M0FX8YD9FHRPA5CF2	usd	{"value": "169", "precision": 20}	0	2025-10-30 22:31:12.631-04	2025-10-30 22:31:12.631-04	\N	\N	169	\N	\N
price_01K8W1NM19ECB2H15264BJ0JKW	\N	pset_01K8W0654NJKJN2P2P73BACZA3	cad	{"value": "82", "precision": 20}	0	2025-10-30 22:31:12.686-04	2025-10-30 22:31:12.686-04	\N	\N	82	\N	\N
price_01K8W1NM1ABRYQ8YPTQ04SWBSB	\N	pset_01K8W0654NJKJN2P2P73BACZA3	usd	{"value": "89", "precision": 20}	0	2025-10-30 22:31:12.686-04	2025-10-30 22:31:12.686-04	\N	\N	89	\N	\N
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01K8RWK38PQKSBVC83ZXEPDYHC	currency_code	eur	f	2025-10-29 17:04:43.798-04	2025-10-29 17:04:43.798-04	\N
prpref_01K8RWK8VGTRY0FE13FPFFMDDS	region_id	reg_01K8RWK8TDVR8KP6R1PS4N5H7W	f	2025-10-29 17:04:49.52-04	2025-10-29 17:04:49.52-04	\N
prpref_01K8RWQ0A7BAKK0VPFVF9F3080	currency_code	usd	f	2025-10-29 17:06:51.848-04	2025-10-29 17:06:51.848-04	\N
prpref_01K8RWQJ92DW9VJXQZDG1489DF	currency_code	cad	f	2025-10-29 17:07:10.243-04	2025-10-29 17:07:10.243-04	\N
prpref_01K8RWV2MTTB5AWV06MVHG7MYP	region_id	reg_01K8RWV2KZJZTEJ4K57MTBT8W8	f	2025-10-29 17:09:05.306-04	2025-10-29 17:09:05.307-04	\N
prpref_01K8W9KYBBRQZWQAC3J6AJADBY	region_id	reg_01K8W9KYA1QHSTYD2G2ETMKBSC	f	2025-10-31 00:50:06.315-04	2025-10-31 00:50:06.315-04	\N
\.


--
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute, operator) FROM stdin;
prule_01K8RWK906SMS9ZH3QXP2ZKDJZ	reg_01K8RWK8TDVR8KP6R1PS4N5H7W	0	price_01K8RWK9060X496GPRN9GNEM4K	2025-10-29 17:04:49.672-04	2025-10-29 17:04:49.672-04	\N	region_id	eq
prule_01K8RWK9076HHDDN29HFYAP439	reg_01K8RWK8TDVR8KP6R1PS4N5H7W	0	price_01K8RWK9074VBCTS38T5P1DKPC	2025-10-29 17:04:49.672-04	2025-10-29 17:04:49.672-04	\N	region_id	eq
\.


--
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01K8RWK906SXWNTXQ7WTDFAZ9D	2025-10-29 17:04:49.672-04	2025-10-29 17:04:49.672-04	\N
pset_01K8RWK907DSRA8QSDRCTQPMS7	2025-10-29 17:04:49.672-04	2025-10-29 17:04:49.672-04	\N
pset_01K8RX49BAQ0SXGDD3KWS74YV7	2025-10-29 17:14:07.082-04	2025-10-29 17:14:07.082-04	\N
pset_01K8RX6A850BT8AWJ0RDE8HW2N	2025-10-29 17:15:13.541-04	2025-10-29 17:15:41.404-04	2025-10-29 17:15:41.404-04
pset_01K8RX80MPR7YQRP37JDM1VT56	2025-10-29 17:16:09.238-04	2025-10-29 17:16:09.238-04	\N
pset_01K8RWK98371PFPKNGJBRDGAMK	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.575-04	2025-10-30 20:03:04.575-04
pset_01K8RWK984MGKX1HQ6WDAFGWJ8	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.611-04	2025-10-30 20:03:04.575-04
pset_01K8RWK984RGHQ9F8JPSA8QYYC	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.622-04	2025-10-30 20:03:04.575-04
pset_01K8RWK984KJ26SW7GQ17K0MFS	2025-10-29 17:04:49.927-04	2025-10-30 20:03:04.632-04	2025-10-30 20:03:04.575-04
pset_01K8RWK984M5GPQCJMAAZYH35T	2025-10-29 17:04:49.927-04	2025-10-30 20:03:08.809-04	2025-10-30 20:03:08.809-04
pset_01K8RWK985JG9TKXHQP5ZF0WWZ	2025-10-29 17:04:49.927-04	2025-10-30 20:03:08.83-04	2025-10-30 20:03:08.809-04
pset_01K8RWK98508SFQ80Q1NPF62PM	2025-10-29 17:04:49.927-04	2025-10-30 20:03:08.84-04	2025-10-30 20:03:08.809-04
pset_01K8RWK985Y2WP6X7WRXDCDX5C	2025-10-29 17:04:49.927-04	2025-10-30 20:03:08.85-04	2025-10-30 20:03:08.809-04
pset_01K8RWK9817J0196P1DDTK73KR	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13-04	2025-10-30 20:03:12.999-04
pset_01K8RWK981V27RVV0GRCRANPJC	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.026-04	2025-10-30 20:03:12.999-04
pset_01K8RWK981S6XY7Q76R1CBGGW2	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.045-04	2025-10-30 20:03:12.999-04
pset_01K8RWK982PM59PM2DJVVPWRCJ	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.057-04	2025-10-30 20:03:12.999-04
pset_01K8RWK98263FD26M7KGKZ0CJX	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.071-04	2025-10-30 20:03:12.999-04
pset_01K8RWK98206JF2TQGYZMTH8PS	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.092-04	2025-10-30 20:03:12.999-04
pset_01K8RWK983JSC3BSA7T6RJYVE6	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.103-04	2025-10-30 20:03:12.999-04
pset_01K8RWK983BNC2QWBG84MMT1ZF	2025-10-29 17:04:49.927-04	2025-10-30 20:03:13.113-04	2025-10-30 20:03:12.999-04
pset_01K8RWK985MWNQ3KJNJQXWM72S	2025-10-29 17:04:49.927-04	2025-10-30 20:03:47.642-04	2025-10-30 20:03:47.642-04
pset_01K8RWK986C3N31J7VS4XV6AXW	2025-10-29 17:04:49.927-04	2025-10-30 20:03:47.661-04	2025-10-30 20:03:47.642-04
pset_01K8RWK986D93TDRPFNJWXE2NB	2025-10-29 17:04:49.927-04	2025-10-30 20:03:47.67-04	2025-10-30 20:03:47.642-04
pset_01K8RWK986RVHNVR149MFCWVMV	2025-10-29 17:04:49.927-04	2025-10-30 20:03:47.678-04	2025-10-30 20:03:47.642-04
pset_01K8VWV26SXSQGK5BPG5BPNRQJ	2025-10-30 21:06:48.154-04	2025-10-30 21:06:48.154-04	\N
pset_01K8W0654EXEVHRYCZA017WP3X	2025-10-30 22:05:17.333-04	2025-10-30 22:05:17.333-04	\N
pset_01K8W0654E3T02TFE7KXJC7V7R	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654F23SCEAGVZD9ZGDSJ	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654FD9G8TSC1H30P2G7Q	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654FTGH0MJ3FJZKD464G	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654GYXV4JW0PF12BMHPR	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654GEWZQ6RPAPTMGBRJV	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654GTMTKKESJ0P6FACWY	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654H096T6X2BA6HW0MXM	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654JCFQXN5V6F1NJYHQK	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654JK89ZQMJW7XAFRTDB	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654KWBJHZDY56CMY4DFG	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654K418VNRCE3B109X8F	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654KX698B7THEQZKHDP8	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654M6FGSJCJGBY314874	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654MKGSAGVN6KRA35RP4	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654MYPN3P54Q6MFHWQBV	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654M0FX8YD9FHRPA5CF2	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
pset_01K8W0654NJKJN2P2P73BACZA3	2025-10-30 22:05:17.334-04	2025-10-30 22:05:17.334-04	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01K8RWK93AARXJAGWJEB0XNZWQ	Medusa Sweatshirt	sweatshirt	\N	Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-29 17:04:49.777-04	2025-10-30 20:03:04.556-04	2025-10-30 20:03:04.555-04	\N
prod_01K8RWK93AHB0YPPHFVCYB8BG7	Medusa Sweatpants	sweatpants	\N	Reimagine the feeling of classic sweatpants. With our cotton sweatpants, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-29 17:04:49.777-04	2025-10-30 20:03:08.795-04	2025-10-30 20:03:08.795-04	\N
prod_01K8RWK93AZFKK1971XQMTWAF9	Medusa T-Shirt	t-shirt	\N	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-29 17:04:49.777-04	2025-10-30 20:03:12.989-04	2025-10-30 20:03:12.988-04	\N
prod_01K8RWK93AZMVKX54EYJ9CY432	Medusa Shorts	shorts	\N	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:47.625-04	2025-10-30 20:03:47.624-04	\N
prod_01K8VWV21PMMKRCFKR5G6DQNQ0	Portable Mini Projector	portable-mini-projector	Cinema anywhere	Palm-sized projector for movies/presentations. 1080p support with HDMI/USB.	f	published	http://localhost:9000/static/1761872807970-photo-realistic_studio_shot_of_a_compact_white_portable.png	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-30 21:06:47.996-04	2025-10-30 21:06:47.996-04	\N	\N
prod_01K8W064XYGJZFVFVD6J3GTDC3	Robot Vacuum Cleaner	robot-vacuum-cleaner	Auto clean + mop	Self‑charging robot vacuum with mapping and mop attachment for hard floors.	f	published	http://localhost:9000/static/1761882845498-robot-vacuum.png	3800	35	9	35	\N	\N	\N	\N	pcol_01K8WBAHE13ZEQEC1ZRV2MQT5X	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-31 01:20:10.864-04	\N	\N
prod_01K8W064XYHP34NB35S1BGY95X	Percussion Massage Gun	percussion-massage-gun	Deep tissue relief	Powerful quiet motor with multiple heads for post‑workout or desk tension relief.	f	published	http://localhost:9000/static/1761883059943-studio_photo_of_a_black_percussion_massage_gun.png	1200	25	10	20	\N	\N	\N	\N	pcol_01K8WBAHE13ZEQEC1ZRV2MQT5X	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-31 01:20:10.865-04	\N	\N
prod_01K8W064XYKNHD79C16Q47QB2A	Smartwatch (Budget-Friendly)	smartwatch-budget-friendly	Fitness tracking & calls	Feature-packed smartwatch with heart-rate, sleep, and notifications. Great battery life for daily use.	f	published	http://localhost:9000/static/1761881688752-photo-realistic_close-up_of_a_luxury_smartwatch_displaying_health.png	180	10	5	10	\N	\N	\N	\N	pcol_01K8WBBYW7JPKGS9RSRBSNKBCY	\N	t	\N	2025-10-30 22:05:17.141-04	2025-10-31 01:21:07.907-04	\N	\N
prod_01K8W064XYH7NDY4T5VCTV0NG5	Electric Heated Lunch Box	electric-heated-lunch-box	Hot meals anywhere	12V/110V heating for meals at desk, car, or job site. Leak‑resistant design.	f	published	http://localhost:9000/static/1761883025608-headed-lunch-box.png	1200	24	12	17	\N	\N	\N	\N	\N	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-30 23:57:05.678-04	\N	\N
prod_01K8W064XYRKS2CDE7CJB1PWH7	LED Light Therapy Facial Mask	led-light-therapy-facial-mask	Red/blue light skincare	At‑home LED therapy to improve skin tone and appearance—spa results at home.	f	published	http://localhost:9000/static/1761883286789-led-mask.png	700	21	11	17	\N	\N	\N	\N	\N	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-31 00:01:26.859-04	\N	\N
prod_01K8W064XYW7EXGT5DFC190M4B	Automatic Pet Feeder	automatic-pet-feeder	Wi‑Fi scheduled feeding	Timed feeding with app control and portion settings—peace of mind for pet owners.	f	published	http://localhost:9000/static/1761883455822-pet-feeder.png	2200	20	32	20	\N	\N	\N	\N	\N	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-31 00:04:15.864-04	\N	\N
prod_01K8W064XYPMJMK6X9V38D9K87	Water Flosser (Oral Irrigator)	water-flosser-oral-irrigator	Cleaner teeth in seconds	Cordless jet flosser with multiple pressure modes and travel case.	f	published	https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/photo-realistic_product_shot_of_an_electric_toothbrush_set.png	400	7	28	7	\N	\N	\N	\N	pcol_01K8WBBYW7JPKGS9RSRBSNKBCY	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-31 01:21:07.907-04	\N	\N
prod_01K8W064XYRCYB06MGJ8VJ3X58	Portable Blender (USB)	portable-blender-usb	Smoothies on the go	Rechargeable blender bottle for fresh shakes at work, gym, or travel.	f	published	http://localhost:9000/static/1761883101112-transparent_portable_blender_bottle_filled_with_fruit_smoothie.png	650	8	24	8	\N	\N	\N	\N	pcol_01K8WBBYW7JPKGS9RSRBSNKBCY	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-31 01:21:07.907-04	\N	\N
prod_01K8W064XY30JJ3Q0DDR8THW7B	RGB Mechanical Keyboard	rgb-mechanical-keyboard	Tactile & customizable	Hot-swappable mechanical keyboard with RGB backlight for gamers and coders.	f	published	http://localhost:9000/static/1761882251313-Hot-mechanical%20keyboard-coders.png	900	45	4	15	\N	\N	\N	\N	pcol_01K8WB9CD57AZ2YEDQRA86V7W0	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-31 01:19:42.62-04	\N	\N
prod_01K8W064XY6642XQKKF20ESTRN	Air Purifier	air-purifier	HEPA fresh air	Quiet HEPA filtration removes dust and allergens for healthier indoor air.	f	published	http://localhost:9000/static/1761884329891-Air-Purifier.png	2700	22	35	22	\N	\N	\N	\N	pcol_01K8WB9CD57AZ2YEDQRA86V7W0	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-31 01:19:42.62-04	\N	\N
prod_01K8W064XZ1MJ6K0GS6WWNHYTH	Standing Desk Converter	standing-desk-converter	Sit‑stand upgrade	Desktop riser converts any desk to standing—improve posture and focus.	f	published	http://localhost:9000/static/1761883489790-full_product_photo_of_a_modern_height-adjustable_standing.png	12000	80	15	40	\N	\N	\N	\N	\N	\N	t	\N	2025-10-30 22:05:17.144-04	2025-10-31 00:04:49.842-04	\N	\N
prod_01K8W064XZ1QSPS8Y2FCFPN0RA	Heated Vest (USB)	heated-vest-usb	Stay warm outdoors	Lightweight vest with carbon fiber heating elements—powered by USB power bank.	f	published	http://localhost:9000/static/1761883690315-heated-vest.png	700	35	5	28	\N	\N	\N	\N	\N	\N	t	\N	2025-10-30 22:05:17.144-04	2025-10-31 00:08:10.371-04	\N	\N
prod_01K8W064XZBWW4VJSZCQH3W53Z	Tech‑Friendly Laptop Backpack	tech-friendly-laptop-backpack	Commuter ready	Water‑resistant backpack with laptop sleeve, USB port, and anti‑theft pockets.	f	published	http://localhost:9000/static/1761883865072-tech-backpack.png	900	46	15	30	\N	\N	\N	\N	\N	\N	t	\N	2025-10-30 22:05:17.144-04	2025-10-31 00:11:05.15-04	\N	\N
prod_01K8W064XZG6F5JRWPZJW5EDRG	Weighted Blanket (15–20 lb)	weighted-blanket-15-20-lb	Calming deep pressure	Breathable weighted blanket for better sleep and stress relief.	f	published	http://localhost:9000/static/1761884354686-Weighted-Blanket.png	8000	40	25	30	\N	\N	\N	\N	\N	\N	t	\N	2025-10-30 22:05:17.144-04	2025-10-31 00:19:14.75-04	\N	\N
prod_01K8W064XY5QK4C8TY2RWZAHS6	Wi‑Fi Home Security Camera	wi-fi-home-security-camera	1080p night vision	Indoor smart camera with motion alerts and two‑way audio via mobile app.	f	published	http://localhost:9000/static/1761884595203-Wi-Fi-home-security-camera.png	200	7	11	7	\N	\N	\N	\N	pcol_01K8WB9CD57AZ2YEDQRA86V7W0	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-31 01:19:42.62-04	\N	\N
prod_01K8W064XY05GEZ6GGT5X5ASZK	Hair Straightener Brush	hair-straightener-brush	Fast morning styling	Ionic heated brush smooths hair quickly with less damage than flat irons.	f	published	http://localhost:9000/static/1761882066284-photo-realistic_close-up_of_a_rose-gold_automatic_cordless_hair.png	520	28	5	6	\N	\N	\N	\N	pcol_01K8WB9CD57AZ2YEDQRA86V7W0	\N	t	\N	2025-10-30 22:05:17.143-04	2025-10-31 01:19:42.62-04	\N	\N
prod_01K8W064XY6HG1PMB3JJ0PYKW5	Wireless Earbuds (Noise-Cancelling)	wireless-earbuds-noise-cancelling	Clear calls, deep bass	Bluetooth earbuds with noise reduction and long battery for commutes and workouts.	f	published	http://localhost:9000/static/1761882322732-minimal_close-up_of_matte-white_wireless_earbuds_inside_open.png	60	7	4	5	\N	\N	\N	\N	pcol_01K8WBBYW7JPKGS9RSRBSNKBCY	\N	t	\N	2025-10-30 22:05:17.142-04	2025-10-31 01:21:07.907-04	\N	\N
prod_01K8W064XYATTAJY28DVHM06J2	DIY Gel Nail Kit (Lamp)	diy-gel-nail-kit-lamp	Salon nails at home	UV lamp, gels, and tools for long‑lasting manicures without the salon visit.	f	published	http://localhost:9000/static/1761882649607-nail-diy.png	1500	26	9	22	\N	\N	\N	\N	pcol_01K8WBBYW7JPKGS9RSRBSNKBCY	\N	t	\N	2025-10-30 22:05:17.144-04	2025-10-31 01:21:07.907-04	\N	\N
prod_01K8W064XZDPX75E31RCV9BAAB	Essential Oil Diffuser & Humidifier	essential-oil-diffuser-humidifier	Calm, scented spaces	Ultrasonic aroma diffuser adds moisture with ambient lighting for relaxation.	f	published	http://localhost:9000/static/1761884045435-ultrasonic-essential-oil-diffuser.png	700	17	20	17	\N	\N	\N	\N	pcol_01K8WBBYW7JPKGS9RSRBSNKBCY	\N	t	\N	2025-10-30 22:05:17.144-04	2025-10-31 01:21:07.907-04	\N	\N
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
pcat_01K8VRVTNDWG8R7Z05G4BQ5SN8	Tech & Gadgets	Discover trending smartwatches, mini projectors, and innovative tech gadgets designed to simplify your lifestyle.	tech-gadgets		t	f	0	\N	2025-10-30 19:57:18.893-04	2025-10-30 20:04:15.802-04	2025-10-30 20:04:15.802-04	\N
pcat_01K8VRXAEPVREAYJSWSA0BAS88	Home & Living	Explore trending home tech — robot vacuums, air purifiers, heated lunch boxes — that make life easier and cleaner.	home-&-living		t	f	1	\N	2025-10-30 19:58:07.831-04	2025-10-30 20:05:20.324-04	\N	\N
pcat_01K8VRZKJ4JRPCC5R6FCPDS98X	Lifestyle & Office	From standing desks to smart backpacks — discover tools that make work and daily life easier, smarter, and healthier.	lifestyle-&-office		t	f	3	\N	2025-10-30 19:59:22.692-04	2025-10-30 20:05:20.325-04	\N	\N
pcat_01K8VS2JVASSQAC8AP27MEK67R	Pet & Smart Home	Connect with your pets and simplify your life with Wi-Fi pet feeders and smart home tools that keep you in control.	pet-&-smart-home		t	f	5	\N	2025-10-30 20:01:00.267-04	2025-10-30 20:05:20.325-04	\N	\N
pcat_01K8VS10C9HQKFWHE9X4T4DT73	Outdoor & Wearables	Stay active and comfortable with our outdoor tech — heated vests, travel bags, and wearables built for all seasons.	outdoor-&-wearables		t	f	4	\N	2025-10-30 20:00:08.585-04	2025-10-30 20:05:20.325-04	\N	\N
pcat_01K8VRYS3W7WGZ0KA3EJXJ2YST	Wellness & Beauty	Transform your self-care with LED masks, massage guns, and smart beauty tools that bring spa-quality care home.	wellness-&-beauty		t	f	2	\N	2025-10-30 19:58:55.612-04	2025-10-30 20:05:20.325-04	\N	\N
pcat_01K8VSA729CWQ77DFMYBV4TW0G	Tech & Gadgets	Discover trending smartwatches, mini projectors, and innovative tech gadgets designed to simplify your lifestyle.	tech-&-gadgets		t	f	0	\N	2025-10-30 20:05:10.345-04	2025-10-30 20:05:20.331-04	\N	\N
pcat_01K8RWK92T16AYH12YAYNQEHER	Shirts		shirts	pcat_01K8RWK92T16AYH12YAYNQEHER	t	f	6	\N	2025-10-29 17:04:49.756-04	2025-10-30 20:03:56.055-04	2025-10-30 20:03:56.054-04	\N
pcat_01K8RWK92VHZ0Q5PX0QGWCMN9F	Sweatshirts		sweatshirts	pcat_01K8RWK92VHZ0Q5PX0QGWCMN9F	t	f	6	\N	2025-10-29 17:04:49.756-04	2025-10-30 20:04:01.583-04	2025-10-30 20:04:01.583-04	\N
pcat_01K8RWK92VM07DK5AAVE607P53	Merch		merch		t	f	8	\N	2025-10-29 17:04:49.756-04	2025-10-30 20:04:06.519-04	2025-10-30 20:04:06.519-04	\N
pcat_01K8RWK92VW5C16XJZQ6FMACK8	Pants		pants	pcat_01K8RWK92VW5C16XJZQ6FMACK8	t	f	6	\N	2025-10-29 17:04:49.756-04	2025-10-30 20:04:11.271-04	2025-10-30 20:04:11.271-04	\N
\.


--
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01K8RWK93AZFKK1971XQMTWAF9	pcat_01K8RWK92T16AYH12YAYNQEHER
prod_01K8RWK93AARXJAGWJEB0XNZWQ	pcat_01K8RWK92VHZ0Q5PX0QGWCMN9F
prod_01K8RWK93AHB0YPPHFVCYB8BG7	pcat_01K8RWK92VW5C16XJZQ6FMACK8
prod_01K8RWK93AZMVKX54EYJ9CY432	pcat_01K8RWK92VM07DK5AAVE607P53
prod_01K8VWV21PMMKRCFKR5G6DQNQ0	pcat_01K8VSA729CWQ77DFMYBV4TW0G
prod_01K8W064XY6642XQKKF20ESTRN	pcat_01K8VRXAEPVREAYJSWSA0BAS88
prod_01K8W064XYGJZFVFVD6J3GTDC3	pcat_01K8VRXAEPVREAYJSWSA0BAS88
prod_01K8W064XYH7NDY4T5VCTV0NG5	pcat_01K8VRXAEPVREAYJSWSA0BAS88
prod_01K8W064XYRCYB06MGJ8VJ3X58	pcat_01K8VRXAEPVREAYJSWSA0BAS88
prod_01K8W064XZDPX75E31RCV9BAAB	pcat_01K8VRXAEPVREAYJSWSA0BAS88
prod_01K8W064XY05GEZ6GGT5X5ASZK	pcat_01K8VRYS3W7WGZ0KA3EJXJ2YST
prod_01K8W064XYATTAJY28DVHM06J2	pcat_01K8VRYS3W7WGZ0KA3EJXJ2YST
prod_01K8W064XYHP34NB35S1BGY95X	pcat_01K8VRYS3W7WGZ0KA3EJXJ2YST
prod_01K8W064XYPMJMK6X9V38D9K87	pcat_01K8VRYS3W7WGZ0KA3EJXJ2YST
prod_01K8W064XYRKS2CDE7CJB1PWH7	pcat_01K8VRYS3W7WGZ0KA3EJXJ2YST
prod_01K8W064XZ1MJ6K0GS6WWNHYTH	pcat_01K8VRZKJ4JRPCC5R6FCPDS98X
prod_01K8W064XZBWW4VJSZCQH3W53Z	pcat_01K8VRZKJ4JRPCC5R6FCPDS98X
prod_01K8W064XZG6F5JRWPZJW5EDRG	pcat_01K8VRZKJ4JRPCC5R6FCPDS98X
prod_01K8W064XZ1QSPS8Y2FCFPN0RA	pcat_01K8VS10C9HQKFWHE9X4T4DT73
prod_01K8W064XY5QK4C8TY2RWZAHS6	pcat_01K8VSA729CWQ77DFMYBV4TW0G
prod_01K8W064XY6HG1PMB3JJ0PYKW5	pcat_01K8VSA729CWQ77DFMYBV4TW0G
prod_01K8W064XYKNHD79C16Q47QB2A	pcat_01K8VSA729CWQ77DFMYBV4TW0G
prod_01K8W064XYW7EXGT5DFC190M4B	pcat_01K8VS2JVASSQAC8AP27MEK67R
\.


--
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at) FROM stdin;
pcol_01K8WB9CD57AZ2YEDQRA86V7W0	Approved by Nick	approved-by-nick	\N	2025-10-31 01:19:17.408678-04	2025-10-31 01:19:17.408678-04	\N
pcol_01K8WBAHE13ZEQEC1ZRV2MQT5X	Deals	deals	\N	2025-10-31 01:19:55.329056-04	2025-10-31 01:19:55.329056-04	\N
pcol_01K8WBBYW7JPKGS9RSRBSNKBCY	Features	features	\N	2025-10-31 01:20:41.862525-04	2025-10-31 01:20:41.862525-04	\N
\.


--
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_option (id, title, product_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
opt_01K8RWK93FQJBKBWNMT7N3S9JC	Size	prod_01K8RWK93AARXJAGWJEB0XNZWQ	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:04.583-04	2025-10-30 20:03:04.555-04
opt_01K8RWK93F6MPHYS7E738Q3YX2	Size	prod_01K8RWK93AHB0YPPHFVCYB8BG7	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:08.813-04	2025-10-30 20:03:08.795-04
opt_01K8RWK93CEVJ7YEEDG6Y8A793	Size	prod_01K8RWK93AZFKK1971XQMTWAF9	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.012-04	2025-10-30 20:03:12.988-04
opt_01K8RWK93DG95FTQ3FMEW3P8MJ	Color	prod_01K8RWK93AZFKK1971XQMTWAF9	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.012-04	2025-10-30 20:03:12.988-04
opt_01K8RWK93GWGQ3G75WFGC49174	Size	prod_01K8RWK93AZMVKX54EYJ9CY432	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:47.634-04	2025-10-30 20:03:47.624-04
opt_01K8VWV21SNF0EDX4DYCMB659C	Default option	prod_01K8VWV21PMMKRCFKR5G6DQNQ0	\N	2025-10-30 21:06:47.997-04	2025-10-30 21:06:47.997-04	\N
opt_01K8W064Y13S83ARYFTX4WZZ8A	Default	prod_01K8W064XYKNHD79C16Q47QB2A	\N	2025-10-30 22:05:17.144-04	2025-10-30 22:05:17.144-04	\N
opt_01K8W064Y2ENY6M419TYVCGA8Z	Default	prod_01K8W064XY6HG1PMB3JJ0PYKW5	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
opt_01K8W064Y3P27MGD9TGY703785	Default	prod_01K8W064XY30JJ3Q0DDR8THW7B	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
opt_01K8W064Y4Z8AMTTKRJNFFN7JQ	Default	prod_01K8W064XY5QK4C8TY2RWZAHS6	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
opt_01K8W064Y4KTDDN7R0XPNHDNGN	Default	prod_01K8W064XYGJZFVFVD6J3GTDC3	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
opt_01K8W064Y55ZC70DJYJRSJ3EBM	Default	prod_01K8W064XY6642XQKKF20ESTRN	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
opt_01K8W064Y618EEB1HASV0PK0DT	Default	prod_01K8W064XYW7EXGT5DFC190M4B	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
opt_01K8W064Y7A3RQZ9VDB41WAFB9	Default	prod_01K8W064XYRCYB06MGJ8VJ3X58	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
opt_01K8W064Y99T8Z750E50R27CER	Default	prod_01K8W064XYH7NDY4T5VCTV0NG5	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
opt_01K8W064YA4XK3P7PDRWNSNHJ0	Default	prod_01K8W064XYRKS2CDE7CJB1PWH7	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
opt_01K8W064YB694NKQSJ33EBBVMH	Default	prod_01K8W064XYHP34NB35S1BGY95X	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
opt_01K8W064YDZ1CPPEJZ058TTAQY	Default	prod_01K8W064XYPMJMK6X9V38D9K87	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
opt_01K8W064YETPD7M4CKPEC4RRTN	Default	prod_01K8W064XY05GEZ6GGT5X5ASZK	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
opt_01K8W064YE6CK3PNTSZP4PNJ28	Default	prod_01K8W064XYATTAJY28DVHM06J2	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
opt_01K8W064YGWC7B4XR64ZGRMHR7	Default	prod_01K8W064XZG6F5JRWPZJW5EDRG	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
opt_01K8W064YG04ABHD1R0JK4D73Z	Default	prod_01K8W064XZ1MJ6K0GS6WWNHYTH	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
opt_01K8W064YHTXDADSMZ8Z0XCXKA	Default	prod_01K8W064XZBWW4VJSZCQH3W53Z	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
opt_01K8W064YJ7RMXCDKKFY41699T	Default	prod_01K8W064XZ1QSPS8Y2FCFPN0RA	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
opt_01K8W064YJRFJ9D9WDVHQTKDAZ	Default	prod_01K8W064XZDPX75E31RCV9BAAB	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
\.


--
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
optval_01K8RWK93E4MFAS0B5ZE64E4JN	S	opt_01K8RWK93FQJBKBWNMT7N3S9JC	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:04.597-04	2025-10-30 20:03:04.555-04
optval_01K8RWK93E68FST22ABT42ZTGY	M	opt_01K8RWK93FQJBKBWNMT7N3S9JC	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:04.598-04	2025-10-30 20:03:04.555-04
optval_01K8RWK93EER2RNYYT569XEAFG	L	opt_01K8RWK93FQJBKBWNMT7N3S9JC	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:04.598-04	2025-10-30 20:03:04.555-04
optval_01K8RWK93F56DD6A4PMMHKH2HH	XL	opt_01K8RWK93FQJBKBWNMT7N3S9JC	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:04.598-04	2025-10-30 20:03:04.555-04
optval_01K8RWK93FRANXTQ0ZTAMN9QEC	S	opt_01K8RWK93F6MPHYS7E738Q3YX2	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:08.825-04	2025-10-30 20:03:08.795-04
optval_01K8RWK93FQSBXBTZZN95DG9N5	M	opt_01K8RWK93F6MPHYS7E738Q3YX2	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:08.826-04	2025-10-30 20:03:08.795-04
optval_01K8RWK93F0XDHN75NBHN26217	L	opt_01K8RWK93F6MPHYS7E738Q3YX2	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:08.826-04	2025-10-30 20:03:08.795-04
optval_01K8RWK93FS84QCFVTXZT6CC0S	XL	opt_01K8RWK93F6MPHYS7E738Q3YX2	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:08.826-04	2025-10-30 20:03:08.795-04
optval_01K8RWK93CPMSG2SY7ZGS00TNZ	S	opt_01K8RWK93CEVJ7YEEDG6Y8A793	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.037-04	2025-10-30 20:03:12.988-04
optval_01K8RWK93CGJTAS23AVR4PFPJ0	M	opt_01K8RWK93CEVJ7YEEDG6Y8A793	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.038-04	2025-10-30 20:03:12.988-04
optval_01K8RWK93CXSPEFM0VGSBMGRDM	L	opt_01K8RWK93CEVJ7YEEDG6Y8A793	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.038-04	2025-10-30 20:03:12.988-04
optval_01K8RWK93CY2ZCKQD400Q5ATCK	XL	opt_01K8RWK93CEVJ7YEEDG6Y8A793	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.038-04	2025-10-30 20:03:12.988-04
optval_01K8RWK93CGWF94WCF9TACAM65	Black	opt_01K8RWK93DG95FTQ3FMEW3P8MJ	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.037-04	2025-10-30 20:03:12.988-04
optval_01K8RWK93D1N4D4BA3HRDNTN7B	White	opt_01K8RWK93DG95FTQ3FMEW3P8MJ	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:13.037-04	2025-10-30 20:03:12.988-04
optval_01K8RWK93G7K4WBM131JE2J1MT	S	opt_01K8RWK93GWGQ3G75WFGC49174	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:47.644-04	2025-10-30 20:03:47.624-04
optval_01K8RWK93GQTTWA40XQQ8YGXCV	M	opt_01K8RWK93GWGQ3G75WFGC49174	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:47.644-04	2025-10-30 20:03:47.624-04
optval_01K8RWK93G5A7KM2C5QPPZ4HE7	L	opt_01K8RWK93GWGQ3G75WFGC49174	\N	2025-10-29 17:04:49.778-04	2025-10-30 20:03:47.644-04	2025-10-30 20:03:47.624-04
optval_01K8RWK93GBZTYARG7V7QGK3TS	XL	opt_01K8RWK93GWGQ3G75WFGC49174	\N	2025-10-29 17:04:49.779-04	2025-10-30 20:03:47.644-04	2025-10-30 20:03:47.624-04
optval_01K8VWV21S3Q5D9DMWSV44HT28	Default option value	opt_01K8VWV21SNF0EDX4DYCMB659C	\N	2025-10-30 21:06:47.997-04	2025-10-30 21:06:47.997-04	\N
optval_01K8W064Y0C1SHBKTC491DEK2J	Standard	opt_01K8W064Y13S83ARYFTX4WZZ8A	\N	2025-10-30 22:05:17.144-04	2025-10-30 22:05:17.144-04	\N
optval_01K8W064Y258HJPT9CGVP1TP8D	Standard	opt_01K8W064Y2ENY6M419TYVCGA8Z	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
optval_01K8W064Y386K7CTGFN0BB5ETW	Standard	opt_01K8W064Y3P27MGD9TGY703785	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
optval_01K8W064Y3PT1MBH13K6EGZP3G	Standard	opt_01K8W064Y4Z8AMTTKRJNFFN7JQ	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
optval_01K8W064Y4GMAA4B2105DC3QBF	Standard	opt_01K8W064Y4KTDDN7R0XPNHDNGN	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
optval_01K8W064Y50Z02NTTYGKD4AHZ0	Standard	opt_01K8W064Y55ZC70DJYJRSJ3EBM	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
optval_01K8W064Y6AMVJVQTBQTQR6K5C	Standard	opt_01K8W064Y618EEB1HASV0PK0DT	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
optval_01K8W064Y75S5MDF8RS40XGR87	Standard	opt_01K8W064Y7A3RQZ9VDB41WAFB9	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
optval_01K8W064Y8RRXGTXP4MBT3S0QZ	Standard	opt_01K8W064Y99T8Z750E50R27CER	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
optval_01K8W064YADSASY3220G53W1PV	Standard	opt_01K8W064YA4XK3P7PDRWNSNHJ0	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
optval_01K8W064YB8AC4F2AXGE2N4T1F	Standard	opt_01K8W064YB694NKQSJ33EBBVMH	\N	2025-10-30 22:05:17.145-04	2025-10-30 22:05:17.145-04	\N
optval_01K8W064YCB4CGRX22FZY7AC53	Standard	opt_01K8W064YDZ1CPPEJZ058TTAQY	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
optval_01K8W064YE1MMGHB28FQHZMT5C	Standard	opt_01K8W064YETPD7M4CKPEC4RRTN	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
optval_01K8W064YE9XRNCSRAJ2PYX99F	Standard	opt_01K8W064YE6CK3PNTSZP4PNJ28	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
optval_01K8W064YFFSNJ1MRTV3VWEEP1	Standard	opt_01K8W064YGWC7B4XR64ZGRMHR7	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
optval_01K8W064YG38K57K9K6ANQ3R6R	Standard	opt_01K8W064YG04ABHD1R0JK4D73Z	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
optval_01K8W064YHE61NWFQGWYB0XAVK	Standard	opt_01K8W064YHTXDADSMZ8Z0XCXKA	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
optval_01K8W064YHAGCJR7FJZ747YVKQ	Standard	opt_01K8W064YJ7RMXCDKKFY41699T	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
optval_01K8W064YJN95J11NSSB57G63K	Standard	opt_01K8W064YJRFJ9D9WDVHQTKDAZ	\N	2025-10-30 22:05:17.146-04	2025-10-30 22:05:17.146-04	\N
\.


--
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K8RWK93AARXJAGWJEB0XNZWQ	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8RWK94H7N6HA4HT2CE2YT0H	2025-10-29 17:04:49.808854-04	2025-10-30 20:03:04.562-04	2025-10-30 20:03:04.562-04
prod_01K8RWK93AHB0YPPHFVCYB8BG7	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8RWK94H5A9ZHKGKRMHYMX7N	2025-10-29 17:04:49.808854-04	2025-10-30 20:03:08.797-04	2025-10-30 20:03:08.797-04
prod_01K8RWK93AZFKK1971XQMTWAF9	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8RWK94GQ1AH64BRZX5290JR	2025-10-29 17:04:49.808854-04	2025-10-30 20:03:12.992-04	2025-10-30 20:03:12.992-04
prod_01K8RWK93AZMVKX54EYJ9CY432	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8RWK94H18JGK45TYCQC4BXV	2025-10-29 17:04:49.808854-04	2025-10-30 20:03:47.626-04	2025-10-30 20:03:47.626-04
prod_01K8VWV21PMMKRCFKR5G6DQNQ0	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8VWV238HBTVR7GDBRTYEE2M	2025-10-30 21:06:48.038476-04	2025-10-30 21:06:48.038476-04	\N
prod_01K8W064XY05GEZ6GGT5X5ASZK	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W0839XHWYYFNY4834HQQQR	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XY30JJ3Q0DDR8THW7B	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W0839Z3HMCQ58V29QWX50F	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XY5QK4C8TY2RWZAHS6	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W0839Z93DKFK57DM6TZTRB	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XY6642XQKKF20ESTRN	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A0NN3TBJ5XD5E99W74	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XY6HG1PMB3JJ0PYKW5	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A04P53QZ509PJ06SFQ	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XYATTAJY28DVHM06J2	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A0QP2NERHQ2GMA5B67	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XYGJZFVFVD6J3GTDC3	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A0SGJCZ401WG3CVAQ5	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XYH7NDY4T5VCTV0NG5	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A0W78HRSX83Y59H1TB	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XYHP34NB35S1BGY95X	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A0TP6N4RFKKBG31Q8B	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XYKNHD79C16Q47QB2A	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A1B8M4M7BWB53DJ2ZJ	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XYPMJMK6X9V38D9K87	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A1EDBCVAFF6WFGM2MA	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XYRCYB06MGJ8VJ3X58	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A140KW86CXAT0SBJ6F	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XYRKS2CDE7CJB1PWH7	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A1WZVSE9XYQZBXMVNM	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XYW7EXGT5DFC190M4B	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A154XGFFDE0YJ4C95X	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XZ1MJ6K0GS6WWNHYTH	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A1V0YJ4VE9R00DPJZK	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XZ1QSPS8Y2FCFPN0RA	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A117WGV6YDFT2QWCMM	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XZBWW4VJSZCQH3W53Z	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A1SM1GB9HRETEQA464	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XZDPX75E31RCV9BAAB	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A1FTS6QEB29RGXBBHJ	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
prod_01K8W064XZG6F5JRWPZJW5EDRG	sc_01K8RWK37J6CCAMVBZZ92TWT9W	prodsc_01K8W083A14ESN2MF2PQS2H596	2025-10-30 22:06:20.989643-04	2025-10-30 22:06:20.989643-04	\N
\.


--
-- Data for Name: product_shipping_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_shipping_profile (product_id, shipping_profile_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K8RWK93AARXJAGWJEB0XNZWQ	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8RWK950KHARNM0XW0BD0TXD	2025-10-29 17:04:49.823911-04	2025-10-30 20:03:04.565-04	2025-10-30 20:03:04.564-04
prod_01K8RWK93AHB0YPPHFVCYB8BG7	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8RWK9509HRXGHKBVE0Z9SXM	2025-10-29 17:04:49.823911-04	2025-10-30 20:03:08.802-04	2025-10-30 20:03:08.801-04
prod_01K8RWK93AZFKK1971XQMTWAF9	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8RWK9507W5Y53ART1WC1KJF	2025-10-29 17:04:49.823911-04	2025-10-30 20:03:12.993-04	2025-10-30 20:03:12.993-04
prod_01K8RWK93AZMVKX54EYJ9CY432	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8RWK950HMT82WA2M214DFQV	2025-10-29 17:04:49.823911-04	2025-10-30 20:03:47.631-04	2025-10-30 20:03:47.63-04
prod_01K8VWV21PMMKRCFKR5G6DQNQ0	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8VWV23YZPZR9DNWRB59ZKET	2025-10-30 21:06:48.061421-04	2025-10-30 21:06:48.061421-04	\N
prod_01K8W064XYKNHD79C16Q47QB2A	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650QB6EB2MD4ZZYQDGGK	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XY6HG1PMB3JJ0PYKW5	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650RJXCSK4ETK26FEH1R	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XY30JJ3Q0DDR8THW7B	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650RRQ02DGFQGMCD5NZX	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XY5QK4C8TY2RWZAHS6	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650RBNBXBKBZDG7YQY4F	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XYGJZFVFVD6J3GTDC3	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650R7ZTG7ZKGETWF3KKZ	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XY6642XQKKF20ESTRN	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650S9MN8BJNHGCFR5N2Z	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XYW7EXGT5DFC190M4B	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650S53R664YD3RMF1PVP	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XYRCYB06MGJ8VJ3X58	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650S53MEB6157GBF40R7	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XYH7NDY4T5VCTV0NG5	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650SRQ9HX3TC5CX0Y5R7	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XYRKS2CDE7CJB1PWH7	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650S9NB821SWAXQYMBXP	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XYHP34NB35S1BGY95X	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650STT3YKSCZZKX5PFMW	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XYPMJMK6X9V38D9K87	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650T5TQ5EE2TR7QE3C3G	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XY05GEZ6GGT5X5ASZK	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650TWAK6W41J8PCR2T70	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XYATTAJY28DVHM06J2	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650TDZS8X546GA72BCMH	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XZG6F5JRWPZJW5EDRG	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650TFKJHKA7057DWZHCW	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XZ1MJ6K0GS6WWNHYTH	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650TWPZJYC1SZ45J1VFN	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XZBWW4VJSZCQH3W53Z	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650T6BZ2Q0RKB217JMA5	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XZ1QSPS8Y2FCFPN0RA	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650TQYEFQTQ7Z1KBM1X5	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
prod_01K8W064XZDPX75E31RCV9BAAB	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	prodsp_01K8W0650TTFA3QM7Y3EZQR724	2025-10-30 22:05:17.207422-04	2025-10-30 22:05:17.207422-04	\N
\.


--
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K8RWK964F3H6SFFWJM9J4DV2	S	SHORTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZMVKX54EYJ9CY432	2025-10-29 17:04:49.862-04	2025-10-30 20:03:47.634-04	2025-10-30 20:03:47.624-04
variant_01K8RWK964XY0C8NYQJ48GA3P2	M	SHORTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZMVKX54EYJ9CY432	2025-10-29 17:04:49.862-04	2025-10-30 20:03:47.634-04	2025-10-30 20:03:47.624-04
variant_01K8RWK964JBXDMRARDBGHHPFR	L	SHORTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZMVKX54EYJ9CY432	2025-10-29 17:04:49.862-04	2025-10-30 20:03:47.634-04	2025-10-30 20:03:47.624-04
variant_01K8RWK9647NRX89FDK7JJ1YD8	XL	SHORTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZMVKX54EYJ9CY432	2025-10-29 17:04:49.862-04	2025-10-30 20:03:47.634-04	2025-10-30 20:03:47.624-04
variant_01K8RWK963HTQ6JEHS2S2TNPPD	S	SWEATSHIRT-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AARXJAGWJEB0XNZWQ	2025-10-29 17:04:49.861-04	2025-10-30 20:03:04.582-04	2025-10-30 20:03:04.555-04
variant_01K8RWK963PBNKKTXWBJVZR77D	M	SWEATSHIRT-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AARXJAGWJEB0XNZWQ	2025-10-29 17:04:49.862-04	2025-10-30 20:03:04.582-04	2025-10-30 20:03:04.555-04
variant_01K8RWK963JJW66GZGZXM80AZ2	L	SWEATSHIRT-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AARXJAGWJEB0XNZWQ	2025-10-29 17:04:49.862-04	2025-10-30 20:03:04.583-04	2025-10-30 20:03:04.555-04
variant_01K8RWK963FGC6BHDYW8T3K1AF	XL	SWEATSHIRT-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AARXJAGWJEB0XNZWQ	2025-10-29 17:04:49.862-04	2025-10-30 20:03:04.583-04	2025-10-30 20:03:04.555-04
variant_01K8RWK9632RP66K3RYCVAE841	S	SWEATPANTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AHB0YPPHFVCYB8BG7	2025-10-29 17:04:49.862-04	2025-10-30 20:03:08.812-04	2025-10-30 20:03:08.795-04
variant_01K8RWK9643W5MW8C0C418NJXV	M	SWEATPANTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AHB0YPPHFVCYB8BG7	2025-10-29 17:04:49.862-04	2025-10-30 20:03:08.812-04	2025-10-30 20:03:08.795-04
variant_01K8RWK9647YF3T3HRENC4KAHJ	L	SWEATPANTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AHB0YPPHFVCYB8BG7	2025-10-29 17:04:49.862-04	2025-10-30 20:03:08.812-04	2025-10-30 20:03:08.795-04
variant_01K8RWK964EFKFWQSG54V4Z5BF	XL	SWEATPANTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AHB0YPPHFVCYB8BG7	2025-10-29 17:04:49.862-04	2025-10-30 20:03:08.812-04	2025-10-30 20:03:08.795-04
variant_01K8RWK961V910RWS6B6SQYG6V	S / Black	SHIRT-S-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZFKK1971XQMTWAF9	2025-10-29 17:04:49.861-04	2025-10-30 20:03:13.011-04	2025-10-30 20:03:12.988-04
variant_01K8RWK961DX9PH5VW3HCFHPDH	S / White	SHIRT-S-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZFKK1971XQMTWAF9	2025-10-29 17:04:49.861-04	2025-10-30 20:03:13.011-04	2025-10-30 20:03:12.988-04
variant_01K8RWK962VBQ34NY0Y12S99VQ	M / Black	SHIRT-M-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZFKK1971XQMTWAF9	2025-10-29 17:04:49.861-04	2025-10-30 20:03:13.011-04	2025-10-30 20:03:12.988-04
variant_01K8RWK962DV1T4M0CMWBE2EH3	M / White	SHIRT-M-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZFKK1971XQMTWAF9	2025-10-29 17:04:49.861-04	2025-10-30 20:03:13.011-04	2025-10-30 20:03:12.988-04
variant_01K8RWK962E3MXZB2HCQ9B47A4	L / Black	SHIRT-L-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZFKK1971XQMTWAF9	2025-10-29 17:04:49.861-04	2025-10-30 20:03:13.011-04	2025-10-30 20:03:12.988-04
variant_01K8RWK962GD549RN2BXA8EBH8	L / White	SHIRT-L-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZFKK1971XQMTWAF9	2025-10-29 17:04:49.861-04	2025-10-30 20:03:13.011-04	2025-10-30 20:03:12.988-04
variant_01K8RWK962M5DH5Y548DGB6VB6	XL / Black	SHIRT-XL-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZFKK1971XQMTWAF9	2025-10-29 17:04:49.861-04	2025-10-30 20:03:13.011-04	2025-10-30 20:03:12.988-04
variant_01K8RWK9623F1TSQBFAGBBP6YT	XL / White	SHIRT-XL-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8RWK93AZFKK1971XQMTWAF9	2025-10-29 17:04:49.861-04	2025-10-30 20:03:13.011-04	2025-10-30 20:03:12.988-04
variant_01K8VWV257S4Z0H7PBCZEQH31Z	Default variant	NICK-PORTABLE-MINI-PROJ-003	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K8VWV21PMMKRCFKR5G6DQNQ0	2025-10-30 21:06:48.103-04	2025-10-30 21:06:48.103-04	\N
variant_01K8W065271G3NAVX90CTR7F7X	Smartwatch (Budget-Friendly)	SMARTWATCH_BUDGET_FRIENDLY	\N	\N	\N	f	t	\N	\N	\N	\N	180	10	5	10	\N	0	prod_01K8W064XYKNHD79C16Q47QB2A	2025-10-30 22:05:17.259-04	2025-10-30 22:05:17.259-04	\N
variant_01K8W06527R8XBH6X7B3DTZCWC	Wireless Earbuds (Noise-Cancelling)	WIRELESS_EARBUDS_NOISE_CANCELLING	\N	\N	\N	f	t	\N	\N	\N	\N	60	7	4	5	\N	0	prod_01K8W064XY6HG1PMB3JJ0PYKW5	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W06527KEDSRF6NXEP7ZBVK	RGB Mechanical Keyboard	RGB_MECHANICAL_KEYBOARD	\N	\N	\N	f	t	\N	\N	\N	\N	900	45	4	15	\N	0	prod_01K8W064XY30JJ3Q0DDR8THW7B	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W065270C1CM6A1PY23ZX2Q	Wi‑Fi Home Security Camera	WI_FI_HOME_SECURITY_CAMERA	\N	\N	\N	f	t	\N	\N	\N	\N	200	7	11	7	\N	0	prod_01K8W064XY5QK4C8TY2RWZAHS6	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W06528MC0R5SMHESA1KADW	Robot Vacuum Cleaner	ROBOT_VACUUM_CLEANER	\N	\N	\N	f	t	\N	\N	\N	\N	3800	35	9	35	\N	0	prod_01K8W064XYGJZFVFVD6J3GTDC3	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W06528YAWYRB99WXNNZMG2	Air Purifier	AIR_PURIFIER	\N	\N	\N	f	t	\N	\N	\N	\N	2700	22	35	22	\N	0	prod_01K8W064XY6642XQKKF20ESTRN	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W06528Z7JBVGN583HSNW4Y	Automatic Pet Feeder	AUTOMATIC_PET_FEEDER	\N	\N	\N	f	t	\N	\N	\N	\N	2200	20	32	20	\N	0	prod_01K8W064XYW7EXGT5DFC190M4B	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W06528V013M4K316E13CR0	Portable Blender (USB)	PORTABLE_BLENDER_USB	\N	\N	\N	f	t	\N	\N	\N	\N	650	8	24	8	\N	0	prod_01K8W064XYRCYB06MGJ8VJ3X58	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W06529WH3FY859J0FVQP9V	Electric Heated Lunch Box	ELECTRIC_HEATED_LUNCH_BOX	\N	\N	\N	f	t	\N	\N	\N	\N	1200	24	12	17	\N	0	prod_01K8W064XYH7NDY4T5VCTV0NG5	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W065296ECW223VTEM8HJ8E	LED Light Therapy Facial Mask	LED_LIGHT_THERAPY_FACIAL_MASK	\N	\N	\N	f	t	\N	\N	\N	\N	700	21	11	17	\N	0	prod_01K8W064XYRKS2CDE7CJB1PWH7	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W065295GF39VZSQTPEJBCA	Percussion Massage Gun	PERCUSSION_MASSAGE_GUN	\N	\N	\N	f	t	\N	\N	\N	\N	1200	25	10	20	\N	0	prod_01K8W064XYHP34NB35S1BGY95X	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W065297DNR80M0GF8G5ERZ	Water Flosser (Oral Irrigator)	WATER_FLOSSER_ORAL_IRRIGATOR	\N	\N	\N	f	t	\N	\N	\N	\N	400	7	28	7	\N	0	prod_01K8W064XYPMJMK6X9V38D9K87	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W0652AHKY73HS5MJ0072QV	Hair Straightener Brush	HAIR_STRAIGHTENER_BRUSH	\N	\N	\N	f	t	\N	\N	\N	\N	520	28	5	6	\N	0	prod_01K8W064XY05GEZ6GGT5X5ASZK	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W0652A5TFY2NEV9YDGDER4	DIY Gel Nail Kit (Lamp)	DIY_GEL_NAIL_KIT_LAMP	\N	\N	\N	f	t	\N	\N	\N	\N	1500	26	9	22	\N	0	prod_01K8W064XYATTAJY28DVHM06J2	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W0652AWMZMQD06SP7W51VV	Weighted Blanket (15–20 lb)	WEIGHTED_BLANKET_15_20_LB	\N	\N	\N	f	t	\N	\N	\N	\N	8000	40	25	30	\N	0	prod_01K8W064XZG6F5JRWPZJW5EDRG	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W0652AJZ3KZ0RR1X44W0YR	Standing Desk Converter	STANDING_DESK_CONVERTER	\N	\N	\N	f	t	\N	\N	\N	\N	12000	80	15	40	\N	0	prod_01K8W064XZ1MJ6K0GS6WWNHYTH	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W0652AXZG3SAKGZW1W16PV	Tech‑Friendly Laptop Backpack	TECH_FRIENDLY_LAPTOP_BACKPACK	\N	\N	\N	f	t	\N	\N	\N	\N	900	46	15	30	\N	0	prod_01K8W064XZBWW4VJSZCQH3W53Z	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W0652A83Z3JZWQ2YD14EK4	Heated Vest (USB)	HEATED_VEST_USB	\N	\N	\N	f	t	\N	\N	\N	\N	700	35	5	28	\N	0	prod_01K8W064XZ1QSPS8Y2FCFPN0RA	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
variant_01K8W0652BYAZGF2EH29A7SK09	Essential Oil Diffuser & Humidifier	ESSENTIAL_OIL_DIFFUSER_HUMIDIFIER	\N	\N	\N	f	t	\N	\N	\N	\N	700	17	20	17	\N	0	prod_01K8W064XZDPX75E31RCV9BAAB	2025-10-30 22:05:17.26-04	2025-10-30 22:05:17.26-04	\N
\.


--
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
variant_01K8RWK963HTQ6JEHS2S2TNPPD	iitem_01K8RWK96X5EZP8B67TA1FW8B1	pvitem_01K8RWK97KMEMQ3AWRT94MK4PN	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:04.541-04	2025-10-30 20:03:04.54-04
variant_01K8RWK963PBNKKTXWBJVZR77D	iitem_01K8RWK96YXTHX73E378ZAFX47	pvitem_01K8RWK97KA9BSEKBC8RYMW93H	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:04.541-04	2025-10-30 20:03:04.54-04
variant_01K8RWK963JJW66GZGZXM80AZ2	iitem_01K8RWK96YPKT6G65HSVTTFZXH	pvitem_01K8RWK97MTBW9RFNXF4GP0T0N	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:04.541-04	2025-10-30 20:03:04.54-04
variant_01K8RWK963FGC6BHDYW8T3K1AF	iitem_01K8RWK96YCE9VA8JS16NXN1H5	pvitem_01K8RWK97MSB7G6QAGHJRFWWDH	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:04.541-04	2025-10-30 20:03:04.54-04
variant_01K8RWK9632RP66K3RYCVAE841	iitem_01K8RWK96YM6Z0JG0GKFYB6E4J	pvitem_01K8RWK97MQPY0T02210PJMMS8	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:08.782-04	2025-10-30 20:03:08.782-04
variant_01K8RWK9643W5MW8C0C418NJXV	iitem_01K8RWK96YFPC6VBW97AF5VN1M	pvitem_01K8RWK97M4A1FRRKANMGT9JZR	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:08.782-04	2025-10-30 20:03:08.782-04
variant_01K8RWK9647YF3T3HRENC4KAHJ	iitem_01K8RWK96Y82CAQDYNYGM35KBZ	pvitem_01K8RWK97M18HST8XBBJXHQ9VP	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:08.782-04	2025-10-30 20:03:08.782-04
variant_01K8RWK964EFKFWQSG54V4Z5BF	iitem_01K8RWK96YESSXEVHHPH7JG2JA	pvitem_01K8RWK97MF04V7XP5WRNAYFKC	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:08.782-04	2025-10-30 20:03:08.782-04
variant_01K8RWK961V910RWS6B6SQYG6V	iitem_01K8RWK96WA4XH1X8ARFAFQWRT	pvitem_01K8RWK97JB7EY6ZBKE5SYPG48	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:12.976-04	2025-10-30 20:03:12.975-04
variant_01K8RWK961DX9PH5VW3HCFHPDH	iitem_01K8RWK96X7WW5K2SN9E0BN516	pvitem_01K8RWK97KQEDN49BKX3R1CFV2	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:12.976-04	2025-10-30 20:03:12.975-04
variant_01K8RWK962VBQ34NY0Y12S99VQ	iitem_01K8RWK96XWZZFSSVF8E02HS5S	pvitem_01K8RWK97K6YXRM2FMHNBW1ZGB	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:12.976-04	2025-10-30 20:03:12.975-04
variant_01K8RWK962DV1T4M0CMWBE2EH3	iitem_01K8RWK96XZ67G7ES5HCD57YZW	pvitem_01K8RWK97K5CWKYDVP7BBRTKH4	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:12.976-04	2025-10-30 20:03:12.975-04
variant_01K8RWK962E3MXZB2HCQ9B47A4	iitem_01K8RWK96XC1P5YEPMCK19XJC0	pvitem_01K8RWK97KBN8HXEVNEFFE1NCK	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:12.976-04	2025-10-30 20:03:12.975-04
variant_01K8RWK962GD549RN2BXA8EBH8	iitem_01K8RWK96X48CXNPVVFWXJ91B8	pvitem_01K8RWK97K22AM8B5M5TE9F06A	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:12.976-04	2025-10-30 20:03:12.975-04
variant_01K8RWK962M5DH5Y548DGB6VB6	iitem_01K8RWK96X5HXW33WA962J44C4	pvitem_01K8RWK97K7KSPB0GDTFYTQ73C	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:12.976-04	2025-10-30 20:03:12.975-04
variant_01K8RWK9623F1TSQBFAGBBP6YT	iitem_01K8RWK96X1XV708Z6815FW03A	pvitem_01K8RWK97KA8JQJDBT4CDCJ8SE	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:12.976-04	2025-10-30 20:03:12.975-04
variant_01K8RWK964F3H6SFFWJM9J4DV2	iitem_01K8RWK96YF4MX3EWDKSBSY92P	pvitem_01K8RWK97MA3688VXTHHJYTFBW	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:47.615-04	2025-10-30 20:03:47.615-04
variant_01K8RWK964XY0C8NYQJ48GA3P2	iitem_01K8RWK96YY04FDCW2WRSNW05E	pvitem_01K8RWK97MYBQBTZ82RXZM80X8	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:47.615-04	2025-10-30 20:03:47.615-04
variant_01K8RWK964JBXDMRARDBGHHPFR	iitem_01K8RWK96ZB0YWN3P3T01TFS8S	pvitem_01K8RWK97MG980ACDK5SSQQJXD	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:47.615-04	2025-10-30 20:03:47.615-04
variant_01K8RWK9647NRX89FDK7JJ1YD8	iitem_01K8RWK96Z403SDGGJ4DCVSC29	pvitem_01K8RWK97MY8F60HS936DRA8Z3	1	2025-10-29 17:04:49.906448-04	2025-10-30 20:03:47.615-04	2025-10-30 20:03:47.615-04
variant_01K8VWV257S4Z0H7PBCZEQH31Z	iitem_01K8VWV25TFKASPCCCAKMQRBQA	pvitem_01K8VWV26FNH7J0R7G4ZX818DG	1	2025-10-30 21:06:48.142439-04	2025-10-30 21:06:48.142439-04	\N
variant_01K8W065271G3NAVX90CTR7F7X	iitem_01K8W06537GGS8YJF6AZBWXQV0	pvitem_01K8W06540CSXR0MG9GN6HG09N	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W06527R8XBH6X7B3DTZCWC	iitem_01K8W06537Q0K8XJY9AND8BQ48	pvitem_01K8W06540FDCZEPBB6RZPWQRV	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W06527KEDSRF6NXEP7ZBVK	iitem_01K8W065377JGA2KFRYSRZRTB0	pvitem_01K8W06541TBXJS9RDRW4N7ZC2	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W065270C1CM6A1PY23ZX2Q	iitem_01K8W06537BBZNNX63DH83ZS6C	pvitem_01K8W06541BX155N3TCZ87478V	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W06528MC0R5SMHESA1KADW	iitem_01K8W06537YSQ0XD0A98ARK5M2	pvitem_01K8W06541798GN7V02FV2817V	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W06528YAWYRB99WXNNZMG2	iitem_01K8W06538H48FKKJ5T6KJM4Z1	pvitem_01K8W06541F8E0P207FME4S3WT	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W06528Z7JBVGN583HSNW4Y	iitem_01K8W06538JA376QA9KKBD9FZW	pvitem_01K8W06541F2CQ4J0W1F1VC4A1	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W06528V013M4K316E13CR0	iitem_01K8W06538M4R3ZRZP8FJ1NZEY	pvitem_01K8W0654144DPY3GT2FE8RRC6	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W06529WH3FY859J0FVQP9V	iitem_01K8W06538JZJMZK8PZJE05NZ3	pvitem_01K8W06541367SKP9HKEYD1E2G	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W065296ECW223VTEM8HJ8E	iitem_01K8W065395KS7F3AK0D6F1B0S	pvitem_01K8W065419FHYT0YY9999Y80J	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W065295GF39VZSQTPEJBCA	iitem_01K8W06539FC4WPB5H20QF8V72	pvitem_01K8W065415RA93THKA68SC9G8	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W065297DNR80M0GF8G5ERZ	iitem_01K8W06539DCHFVTNSQVN8PFAK	pvitem_01K8W065420TR4H06CAYTT4QC8	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W0652AHKY73HS5MJ0072QV	iitem_01K8W0653947DY1QTD1AJRWKCG	pvitem_01K8W06542PQRQRE8YE4FZAD03	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W0652A5TFY2NEV9YDGDER4	iitem_01K8W06539D3QQNN63FBNYVRC1	pvitem_01K8W06542HCQC92TVE49TSA1B	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W0652AWMZMQD06SP7W51VV	iitem_01K8W06539RP0T582E2RAMS5VJ	pvitem_01K8W06542900Y0B3D2R3F30N6	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W0652AJZ3KZ0RR1X44W0YR	iitem_01K8W0653A6F4BB0YXX31E64AD	pvitem_01K8W06542XZM4QWJCHRTV6JMY	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W0652AXZG3SAKGZW1W16PV	iitem_01K8W0653ADR9CWTC8X4V8PG81	pvitem_01K8W06542ZBSMD0PCQCXENYVS	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W0652A83Z3JZWQ2YD14EK4	iitem_01K8W0653AMPMGR1NN70G9D3DM	pvitem_01K8W06542B5KDSTQAK5N4C17R	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
variant_01K8W0652BYAZGF2EH29A7SK09	iitem_01K8W0653AQX1D0Z4PQBXDZPCW	pvitem_01K8W06542WT00YJCNK2S8PWCK	1	2025-10-30 22:05:17.312829-04	2025-10-30 22:05:17.312829-04	\N
\.


--
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_option (variant_id, option_value_id) FROM stdin;
variant_01K8RWK961V910RWS6B6SQYG6V	optval_01K8RWK93CPMSG2SY7ZGS00TNZ
variant_01K8RWK961V910RWS6B6SQYG6V	optval_01K8RWK93CGWF94WCF9TACAM65
variant_01K8RWK961DX9PH5VW3HCFHPDH	optval_01K8RWK93CPMSG2SY7ZGS00TNZ
variant_01K8RWK961DX9PH5VW3HCFHPDH	optval_01K8RWK93D1N4D4BA3HRDNTN7B
variant_01K8RWK962VBQ34NY0Y12S99VQ	optval_01K8RWK93CGJTAS23AVR4PFPJ0
variant_01K8RWK962VBQ34NY0Y12S99VQ	optval_01K8RWK93CGWF94WCF9TACAM65
variant_01K8RWK962DV1T4M0CMWBE2EH3	optval_01K8RWK93CGJTAS23AVR4PFPJ0
variant_01K8RWK962DV1T4M0CMWBE2EH3	optval_01K8RWK93D1N4D4BA3HRDNTN7B
variant_01K8RWK962E3MXZB2HCQ9B47A4	optval_01K8RWK93CXSPEFM0VGSBMGRDM
variant_01K8RWK962E3MXZB2HCQ9B47A4	optval_01K8RWK93CGWF94WCF9TACAM65
variant_01K8RWK962GD549RN2BXA8EBH8	optval_01K8RWK93CXSPEFM0VGSBMGRDM
variant_01K8RWK962GD549RN2BXA8EBH8	optval_01K8RWK93D1N4D4BA3HRDNTN7B
variant_01K8RWK962M5DH5Y548DGB6VB6	optval_01K8RWK93CY2ZCKQD400Q5ATCK
variant_01K8RWK962M5DH5Y548DGB6VB6	optval_01K8RWK93CGWF94WCF9TACAM65
variant_01K8RWK9623F1TSQBFAGBBP6YT	optval_01K8RWK93CY2ZCKQD400Q5ATCK
variant_01K8RWK9623F1TSQBFAGBBP6YT	optval_01K8RWK93D1N4D4BA3HRDNTN7B
variant_01K8RWK963HTQ6JEHS2S2TNPPD	optval_01K8RWK93E4MFAS0B5ZE64E4JN
variant_01K8RWK963PBNKKTXWBJVZR77D	optval_01K8RWK93E68FST22ABT42ZTGY
variant_01K8RWK963JJW66GZGZXM80AZ2	optval_01K8RWK93EER2RNYYT569XEAFG
variant_01K8RWK963FGC6BHDYW8T3K1AF	optval_01K8RWK93F56DD6A4PMMHKH2HH
variant_01K8RWK9632RP66K3RYCVAE841	optval_01K8RWK93FRANXTQ0ZTAMN9QEC
variant_01K8RWK9643W5MW8C0C418NJXV	optval_01K8RWK93FQSBXBTZZN95DG9N5
variant_01K8RWK9647YF3T3HRENC4KAHJ	optval_01K8RWK93F0XDHN75NBHN26217
variant_01K8RWK964EFKFWQSG54V4Z5BF	optval_01K8RWK93FS84QCFVTXZT6CC0S
variant_01K8RWK964F3H6SFFWJM9J4DV2	optval_01K8RWK93G7K4WBM131JE2J1MT
variant_01K8RWK964XY0C8NYQJ48GA3P2	optval_01K8RWK93GQTTWA40XQQ8YGXCV
variant_01K8RWK964JBXDMRARDBGHHPFR	optval_01K8RWK93G5A7KM2C5QPPZ4HE7
variant_01K8RWK9647NRX89FDK7JJ1YD8	optval_01K8RWK93GBZTYARG7V7QGK3TS
variant_01K8VWV257S4Z0H7PBCZEQH31Z	optval_01K8VWV21S3Q5D9DMWSV44HT28
variant_01K8W065271G3NAVX90CTR7F7X	optval_01K8W064Y0C1SHBKTC491DEK2J
variant_01K8W06527R8XBH6X7B3DTZCWC	optval_01K8W064Y258HJPT9CGVP1TP8D
variant_01K8W06527KEDSRF6NXEP7ZBVK	optval_01K8W064Y386K7CTGFN0BB5ETW
variant_01K8W065270C1CM6A1PY23ZX2Q	optval_01K8W064Y3PT1MBH13K6EGZP3G
variant_01K8W06528MC0R5SMHESA1KADW	optval_01K8W064Y4GMAA4B2105DC3QBF
variant_01K8W06528YAWYRB99WXNNZMG2	optval_01K8W064Y50Z02NTTYGKD4AHZ0
variant_01K8W06528Z7JBVGN583HSNW4Y	optval_01K8W064Y6AMVJVQTBQTQR6K5C
variant_01K8W06528V013M4K316E13CR0	optval_01K8W064Y75S5MDF8RS40XGR87
variant_01K8W06529WH3FY859J0FVQP9V	optval_01K8W064Y8RRXGTXP4MBT3S0QZ
variant_01K8W065296ECW223VTEM8HJ8E	optval_01K8W064YADSASY3220G53W1PV
variant_01K8W065295GF39VZSQTPEJBCA	optval_01K8W064YB8AC4F2AXGE2N4T1F
variant_01K8W065297DNR80M0GF8G5ERZ	optval_01K8W064YCB4CGRX22FZY7AC53
variant_01K8W0652AHKY73HS5MJ0072QV	optval_01K8W064YE1MMGHB28FQHZMT5C
variant_01K8W0652A5TFY2NEV9YDGDER4	optval_01K8W064YE9XRNCSRAJ2PYX99F
variant_01K8W0652AWMZMQD06SP7W51VV	optval_01K8W064YFFSNJ1MRTV3VWEEP1
variant_01K8W0652AJZ3KZ0RR1X44W0YR	optval_01K8W064YG38K57K9K6ANQ3R6R
variant_01K8W0652AXZG3SAKGZW1W16PV	optval_01K8W064YHE61NWFQGWYB0XAVK
variant_01K8W0652A83Z3JZWQ2YD14EK4	optval_01K8W064YHAGCJR7FJZ747YVKQ
variant_01K8W0652BYAZGF2EH29A7SK09	optval_01K8W064YJN95J11NSSB57G63K
\.


--
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K8RWK963HTQ6JEHS2S2TNPPD	pset_01K8RWK98371PFPKNGJBRDGAMK	pvps_01K8RWK99D1X7E4WJJ6N61CFRR	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:04.561-04	2025-10-30 20:03:04.56-04
variant_01K8RWK963PBNKKTXWBJVZR77D	pset_01K8RWK984MGKX1HQ6WDAFGWJ8	pvps_01K8RWK99DJ1PXS3KJQNZ9CAVA	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:04.561-04	2025-10-30 20:03:04.56-04
variant_01K8RWK963JJW66GZGZXM80AZ2	pset_01K8RWK984RGHQ9F8JPSA8QYYC	pvps_01K8RWK99DC2896HTM52Z1HEMP	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:04.561-04	2025-10-30 20:03:04.56-04
variant_01K8RWK963FGC6BHDYW8T3K1AF	pset_01K8RWK984KJ26SW7GQ17K0MFS	pvps_01K8RWK99EFWG5T7332KMX91W2	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:04.561-04	2025-10-30 20:03:04.56-04
variant_01K8RWK9632RP66K3RYCVAE841	pset_01K8RWK984M5GPQCJMAAZYH35T	pvps_01K8RWK99EYETRHAAA02PTB5ZH	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:08.799-04	2025-10-30 20:03:08.798-04
variant_01K8RWK9643W5MW8C0C418NJXV	pset_01K8RWK985JG9TKXHQP5ZF0WWZ	pvps_01K8RWK99EWN4B03FF1W9JCXX8	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:08.799-04	2025-10-30 20:03:08.798-04
variant_01K8RWK9647YF3T3HRENC4KAHJ	pset_01K8RWK98508SFQ80Q1NPF62PM	pvps_01K8RWK99E2JM0EX75T6TGWGSQ	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:08.799-04	2025-10-30 20:03:08.798-04
variant_01K8RWK964EFKFWQSG54V4Z5BF	pset_01K8RWK985Y2WP6X7WRXDCDX5C	pvps_01K8RWK99E1KMN1DCDQS9XGT34	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:08.799-04	2025-10-30 20:03:08.798-04
variant_01K8RWK961V910RWS6B6SQYG6V	pset_01K8RWK9817J0196P1DDTK73KR	pvps_01K8RWK99CHEPD4S9EZT299PGW	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:12.991-04	2025-10-30 20:03:12.99-04
variant_01K8RWK961DX9PH5VW3HCFHPDH	pset_01K8RWK981V27RVV0GRCRANPJC	pvps_01K8RWK99DS8YWSZVCSNMGH261	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:12.991-04	2025-10-30 20:03:12.99-04
variant_01K8RWK962VBQ34NY0Y12S99VQ	pset_01K8RWK981S6XY7Q76R1CBGGW2	pvps_01K8RWK99D975V8SVF7ZS9NBQS	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:12.991-04	2025-10-30 20:03:12.99-04
variant_01K8RWK962DV1T4M0CMWBE2EH3	pset_01K8RWK982PM59PM2DJVVPWRCJ	pvps_01K8RWK99DNTBXFKT8QKWEW672	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:12.991-04	2025-10-30 20:03:12.99-04
variant_01K8RWK962E3MXZB2HCQ9B47A4	pset_01K8RWK98263FD26M7KGKZ0CJX	pvps_01K8RWK99D45XYJ9KS0MQNN8C8	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:12.991-04	2025-10-30 20:03:12.99-04
variant_01K8RWK962GD549RN2BXA8EBH8	pset_01K8RWK98206JF2TQGYZMTH8PS	pvps_01K8RWK99DJ0YKTXSSDE50Y2H9	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:12.991-04	2025-10-30 20:03:12.99-04
variant_01K8RWK962M5DH5Y548DGB6VB6	pset_01K8RWK983JSC3BSA7T6RJYVE6	pvps_01K8RWK99DCZ9J22K6NWNB3V3J	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:12.991-04	2025-10-30 20:03:12.99-04
variant_01K8RWK9623F1TSQBFAGBBP6YT	pset_01K8RWK983BNC2QWBG84MMT1ZF	pvps_01K8RWK99DZP8FKX3MXV8E3FC3	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:12.991-04	2025-10-30 20:03:12.99-04
variant_01K8RWK964F3H6SFFWJM9J4DV2	pset_01K8RWK985MWNQ3KJNJQXWM72S	pvps_01K8RWK99EBMXSD4BFT8SB6Q1C	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:47.628-04	2025-10-30 20:03:47.627-04
variant_01K8RWK964XY0C8NYQJ48GA3P2	pset_01K8RWK986C3N31J7VS4XV6AXW	pvps_01K8RWK99ECMCDBYW6EMMAM9DQ	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:47.628-04	2025-10-30 20:03:47.627-04
variant_01K8RWK964JBXDMRARDBGHHPFR	pset_01K8RWK986D93TDRPFNJWXE2NB	pvps_01K8RWK99ERD88WB43PV0XKBHA	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:47.628-04	2025-10-30 20:03:47.627-04
variant_01K8RWK9647NRX89FDK7JJ1YD8	pset_01K8RWK986RVHNVR149MFCWVMV	pvps_01K8RWK99E2BMJQJ41E4VHP7V4	2025-10-29 17:04:49.964386-04	2025-10-30 20:03:47.628-04	2025-10-30 20:03:47.627-04
variant_01K8VWV257S4Z0H7PBCZEQH31Z	pset_01K8VWV26SXSQGK5BPG5BPNRQJ	pvps_01K8VWV280QZ7VN49VBHMFZC4W	2025-10-30 21:06:48.192132-04	2025-10-30 21:06:48.192132-04	\N
variant_01K8W065271G3NAVX90CTR7F7X	pset_01K8W0654EXEVHRYCZA017WP3X	pvps_01K8W06568CW3HZPNEWPDEPFDG	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W06527R8XBH6X7B3DTZCWC	pset_01K8W0654E3T02TFE7KXJC7V7R	pvps_01K8W065686224HB1M32WJHV7T	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W06527KEDSRF6NXEP7ZBVK	pset_01K8W0654F23SCEAGVZD9ZGDSJ	pvps_01K8W06568R2TJDHZHSFM5QSNQ	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W065270C1CM6A1PY23ZX2Q	pset_01K8W0654FD9G8TSC1H30P2G7Q	pvps_01K8W06569S48V6GTRJ4B83W9J	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W06528MC0R5SMHESA1KADW	pset_01K8W0654FTGH0MJ3FJZKD464G	pvps_01K8W065691WQK67W6DMYQVSFW	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W06528YAWYRB99WXNNZMG2	pset_01K8W0654GYXV4JW0PF12BMHPR	pvps_01K8W06569Q60YYVJTQ57N9SYQ	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W06528Z7JBVGN583HSNW4Y	pset_01K8W0654GEWZQ6RPAPTMGBRJV	pvps_01K8W065696Z48NVDMK6RRNRGD	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W06528V013M4K316E13CR0	pset_01K8W0654GTMTKKESJ0P6FACWY	pvps_01K8W065695NAQ56EXP6J7CKA7	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W06529WH3FY859J0FVQP9V	pset_01K8W0654H096T6X2BA6HW0MXM	pvps_01K8W06569ARK4RV27ES3DH0S1	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W065296ECW223VTEM8HJ8E	pset_01K8W0654JCFQXN5V6F1NJYHQK	pvps_01K8W06569AGN3V08H5EGW4K6Y	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W065295GF39VZSQTPEJBCA	pset_01K8W0654JK89ZQMJW7XAFRTDB	pvps_01K8W06569YJSXDQFEK3TXBAW2	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W065297DNR80M0GF8G5ERZ	pset_01K8W0654KWBJHZDY56CMY4DFG	pvps_01K8W0656930C53014GP0ZAN3S	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W0652AHKY73HS5MJ0072QV	pset_01K8W0654K418VNRCE3B109X8F	pvps_01K8W0656AJJ8YR1892C2K4AA5	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W0652A5TFY2NEV9YDGDER4	pset_01K8W0654KX698B7THEQZKHDP8	pvps_01K8W0656AWVYF40EQTJ6V54SJ	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W0652AWMZMQD06SP7W51VV	pset_01K8W0654M6FGSJCJGBY314874	pvps_01K8W0656AQCM70X9NKJYK7JRD	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W0652AJZ3KZ0RR1X44W0YR	pset_01K8W0654MKGSAGVN6KRA35RP4	pvps_01K8W0656A70ZA0J8FB139KYNH	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W0652AXZG3SAKGZW1W16PV	pset_01K8W0654MYPN3P54Q6MFHWQBV	pvps_01K8W0656A5CZ71ZD1J5XV0KZB	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W0652A83Z3JZWQ2YD14EK4	pset_01K8W0654M0FX8YD9FHRPA5CF2	pvps_01K8W0656AR64DQ3AKG2RJRGDG	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
variant_01K8W0652BYAZGF2EH29A7SK09	pset_01K8W0654NJKJN2P2P73BACZA3	pvps_01K8W0656AS0BPZM6YHESMMSV9	2025-10-30 22:05:17.384729-04	2025-10-30 22:05:17.384729-04	\N
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at, status, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code, attribute) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget_usage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign_budget_usage (id, attribute_value, used, budget_id, raw_used, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at, deleted_at) FROM stdin;
01K8RWNHX1QHW3DSCZN66W02ZS	nickdevmtl@gmail.com	emailpass	authid_01K8RWNHX23G9HJ6CF71WW7WC1	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAebAq6CcOlb2Dx6dynS+grxx/BV5itiSzQBxLzlB71NgCxLvg6x1P31hSY4j76OOriyQLKKybU6vBZisgwJov3rV1cZLxJ8Aawy5WOFIGYMN"}	2025-10-29 17:06:04.323-04	2025-10-29 17:06:04.323-04	\N
01K8S9QEKE6QVS2GBQK7G8HZVB	nickybcotroni@gmail.com	emailpass	authid_01K8S9QEKEPQBT9FFYHSCNRYVZ	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAagJ5y6jMsneCrhuRanLgCuqKW1OAV2354sE6Rf7zUmXtP/ORncGwqM8Sb64hRsupJiGABqiEUE06fqWhbz3NgYLp+iOUgUP6fbXuzVJ8eER"}	2025-10-29 20:54:17.966-04	2025-10-29 20:54:17.966-04	\N
\.


--
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01K8RWK91WHHQ9RCH6DGCNNYYQ	sc_01K8RWK37J6CCAMVBZZ92TWT9W	pksc_01K8RWK928HYEZTM8JVHV9NET3	2025-10-29 17:04:49.736783-04	2025-10-29 17:04:49.736783-04	\N
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at, code) FROM stdin;
refr_01K8RWJMCTD07PJVNFSVBPQ00S	Shipping Issue	Refund due to lost, delayed, or misdelivered shipment	\N	2025-10-29 17:04:28.445929-04	2025-10-29 17:04:28.445929-04	\N	shipping_issue
refr_01K8RWJMCVBWGS01HQ74MK70CP	Customer Care Adjustment	Refund given as goodwill or compensation for inconvenience	\N	2025-10-29 17:04:28.445929-04	2025-10-29 17:04:28.445929-04	\N	customer_care_adjustment
refr_01K8RWJMCVQETYR79F2A8WJGZV	Pricing Error	Refund to correct an overcharge, missing discount, or incorrect price	\N	2025-10-29 17:04:28.445929-04	2025-10-29 17:04:28.445929-04	\N	pricing_error
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01K8RWK8TDVR8KP6R1PS4N5H7W	Europe	cad	\N	2025-10-29 17:04:49.496-04	2025-10-30 23:26:08.314-04	2025-10-30 23:26:08.313-04	t
reg_01K8RWV2KZJZTEJ4K57MTBT8W8	Canada	cad	\N	2025-10-29 17:09:05.288-04	2025-10-31 00:46:35.786-04	\N	t
reg_01K8W9KYA1QHSTYD2G2ETMKBSC	ww	usd	\N	2025-10-31 00:50:06.285-04	2025-10-31 00:50:06.285-04	\N	t
\.


--
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region_country (iso_2, iso_3, num_code, name, display_name, region_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
af	afg	004	AFGHANISTAN	Afghanistan	\N	\N	2025-10-29 17:04:36.536-04	2025-10-29 17:04:36.536-04	\N
al	alb	008	ALBANIA	Albania	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
dz	dza	012	ALGERIA	Algeria	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
as	asm	016	AMERICAN SAMOA	American Samoa	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
ad	and	020	ANDORRA	Andorra	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
ao	ago	024	ANGOLA	Angola	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
ai	aia	660	ANGUILLA	Anguilla	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
aq	ata	010	ANTARCTICA	Antarctica	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
ag	atg	028	ANTIGUA AND BARBUDA	Antigua and Barbuda	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
ar	arg	032	ARGENTINA	Argentina	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
am	arm	051	ARMENIA	Armenia	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
aw	abw	533	ARUBA	Aruba	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
au	aus	036	AUSTRALIA	Australia	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
at	aut	040	AUSTRIA	Austria	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
az	aze	031	AZERBAIJAN	Azerbaijan	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bs	bhs	044	BAHAMAS	Bahamas	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bh	bhr	048	BAHRAIN	Bahrain	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bd	bgd	050	BANGLADESH	Bangladesh	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bb	brb	052	BARBADOS	Barbados	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
by	blr	112	BELARUS	Belarus	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
be	bel	056	BELGIUM	Belgium	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bz	blz	084	BELIZE	Belize	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bj	ben	204	BENIN	Benin	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bm	bmu	060	BERMUDA	Bermuda	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bt	btn	064	BHUTAN	Bhutan	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bo	bol	068	BOLIVIA	Bolivia	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bq	bes	535	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
ba	bih	070	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bw	bwa	072	BOTSWANA	Botswana	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bv	bvd	074	BOUVET ISLAND	Bouvet Island	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
br	bra	076	BRAZIL	Brazil	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
io	iot	086	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bn	brn	096	BRUNEI DARUSSALAM	Brunei Darussalam	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bg	bgr	100	BULGARIA	Bulgaria	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bf	bfa	854	BURKINA FASO	Burkina Faso	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
bi	bdi	108	BURUNDI	Burundi	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
kh	khm	116	CAMBODIA	Cambodia	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cm	cmr	120	CAMEROON	Cameroon	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cv	cpv	132	CAPE VERDE	Cape Verde	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
ky	cym	136	CAYMAN ISLANDS	Cayman Islands	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cf	caf	140	CENTRAL AFRICAN REPUBLIC	Central African Republic	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
td	tcd	148	CHAD	Chad	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cl	chl	152	CHILE	Chile	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cn	chn	156	CHINA	China	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cx	cxr	162	CHRISTMAS ISLAND	Christmas Island	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cc	cck	166	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
co	col	170	COLOMBIA	Colombia	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
km	com	174	COMOROS	Comoros	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cg	cog	178	CONGO	Congo	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cd	cod	180	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
ck	cok	184	COOK ISLANDS	Cook Islands	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cr	cri	188	COSTA RICA	Costa Rica	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
ci	civ	384	COTE D'IVOIRE	Cote D'Ivoire	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
hr	hrv	191	CROATIA	Croatia	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cu	cub	192	CUBA	Cuba	\N	\N	2025-10-29 17:04:36.537-04	2025-10-29 17:04:36.537-04	\N
cw	cuw	531	CURAÇAO	Curaçao	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
cy	cyp	196	CYPRUS	Cyprus	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
cz	cze	203	CZECH REPUBLIC	Czech Republic	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
dj	dji	262	DJIBOUTI	Djibouti	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
dm	dma	212	DOMINICA	Dominica	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
do	dom	214	DOMINICAN REPUBLIC	Dominican Republic	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ec	ecu	218	ECUADOR	Ecuador	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
eg	egy	818	EGYPT	Egypt	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
sv	slv	222	EL SALVADOR	El Salvador	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gq	gnq	226	EQUATORIAL GUINEA	Equatorial Guinea	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
er	eri	232	ERITREA	Eritrea	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ee	est	233	ESTONIA	Estonia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
et	eth	231	ETHIOPIA	Ethiopia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
fk	flk	238	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
fo	fro	234	FAROE ISLANDS	Faroe Islands	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
fj	fji	242	FIJI	Fiji	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
fi	fin	246	FINLAND	Finland	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gf	guf	254	FRENCH GUIANA	French Guiana	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
pf	pyf	258	FRENCH POLYNESIA	French Polynesia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
tf	atf	260	FRENCH SOUTHERN TERRITORIES	French Southern Territories	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ga	gab	266	GABON	Gabon	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gm	gmb	270	GAMBIA	Gambia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ge	geo	268	GEORGIA	Georgia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gh	gha	288	GHANA	Ghana	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gi	gib	292	GIBRALTAR	Gibraltar	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gr	grc	300	GREECE	Greece	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gl	grl	304	GREENLAND	Greenland	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gd	grd	308	GRENADA	Grenada	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gp	glp	312	GUADELOUPE	Guadeloupe	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gu	gum	316	GUAM	Guam	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gt	gtm	320	GUATEMALA	Guatemala	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gg	ggy	831	GUERNSEY	Guernsey	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ca	can	124	CANADA	Canada	reg_01K8RWV2KZJZTEJ4K57MTBT8W8	\N	2025-10-29 17:04:36.537-04	2025-10-31 00:46:57.772-04	\N
gn	gin	324	GUINEA	Guinea	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gw	gnb	624	GUINEA-BISSAU	Guinea-Bissau	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
gy	guy	328	GUYANA	Guyana	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ht	hti	332	HAITI	Haiti	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
hm	hmd	334	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island And Mcdonald Islands	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
va	vat	336	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
hn	hnd	340	HONDURAS	Honduras	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
hk	hkg	344	HONG KONG	Hong Kong	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
hu	hun	348	HUNGARY	Hungary	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
is	isl	352	ICELAND	Iceland	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
in	ind	356	INDIA	India	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
id	idn	360	INDONESIA	Indonesia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ir	irn	364	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
iq	irq	368	IRAQ	Iraq	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ie	irl	372	IRELAND	Ireland	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
im	imn	833	ISLE OF MAN	Isle Of Man	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
il	isr	376	ISRAEL	Israel	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
jm	jam	388	JAMAICA	Jamaica	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
jp	jpn	392	JAPAN	Japan	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
je	jey	832	JERSEY	Jersey	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
jo	jor	400	JORDAN	Jordan	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
kz	kaz	398	KAZAKHSTAN	Kazakhstan	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ke	ken	404	KENYA	Kenya	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ki	kir	296	KIRIBATI	Kiribati	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
kp	prk	408	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
kr	kor	410	KOREA, REPUBLIC OF	Korea, Republic of	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
xk	xkx	900	KOSOVO	Kosovo	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
kw	kwt	414	KUWAIT	Kuwait	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
kg	kgz	417	KYRGYZSTAN	Kyrgyzstan	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
la	lao	418	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
lv	lva	428	LATVIA	Latvia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
lb	lbn	422	LEBANON	Lebanon	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ls	lso	426	LESOTHO	Lesotho	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
lr	lbr	430	LIBERIA	Liberia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ly	lby	434	LIBYA	Libya	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
li	lie	438	LIECHTENSTEIN	Liechtenstein	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
lt	ltu	440	LITHUANIA	Lithuania	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
lu	lux	442	LUXEMBOURG	Luxembourg	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mo	mac	446	MACAO	Macao	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mg	mdg	450	MADAGASCAR	Madagascar	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mw	mwi	454	MALAWI	Malawi	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
my	mys	458	MALAYSIA	Malaysia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mv	mdv	462	MALDIVES	Maldives	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ml	mli	466	MALI	Mali	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mt	mlt	470	MALTA	Malta	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mh	mhl	584	MARSHALL ISLANDS	Marshall Islands	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mq	mtq	474	MARTINIQUE	Martinique	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mr	mrt	478	MAURITANIA	Mauritania	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mu	mus	480	MAURITIUS	Mauritius	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
yt	myt	175	MAYOTTE	Mayotte	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mx	mex	484	MEXICO	Mexico	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
fm	fsm	583	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
md	mda	498	MOLDOVA, REPUBLIC OF	Moldova, Republic of	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mc	mco	492	MONACO	Monaco	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mn	mng	496	MONGOLIA	Mongolia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
me	mne	499	MONTENEGRO	Montenegro	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ms	msr	500	MONTSERRAT	Montserrat	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
ma	mar	504	MOROCCO	Morocco	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mz	moz	508	MOZAMBIQUE	Mozambique	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
mm	mmr	104	MYANMAR	Myanmar	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
na	nam	516	NAMIBIA	Namibia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
nr	nru	520	NAURU	Nauru	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
np	npl	524	NEPAL	Nepal	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
nl	nld	528	NETHERLANDS	Netherlands	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
nc	ncl	540	NEW CALEDONIA	New Caledonia	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.538-04	\N
nz	nzl	554	NEW ZEALAND	New Zealand	\N	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:36.539-04	\N
ni	nic	558	NICARAGUA	Nicaragua	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ne	ner	562	NIGER	Niger	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ng	nga	566	NIGERIA	Nigeria	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
nu	niu	570	NIUE	Niue	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
nf	nfk	574	NORFOLK ISLAND	Norfolk Island	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
mk	mkd	807	NORTH MACEDONIA	North Macedonia	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
mp	mnp	580	NORTHERN MARIANA ISLANDS	Northern Mariana Islands	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
no	nor	578	NORWAY	Norway	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
om	omn	512	OMAN	Oman	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
pk	pak	586	PAKISTAN	Pakistan	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
pw	plw	585	PALAU	Palau	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ps	pse	275	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
pa	pan	591	PANAMA	Panama	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
pg	png	598	PAPUA NEW GUINEA	Papua New Guinea	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
py	pry	600	PARAGUAY	Paraguay	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
pe	per	604	PERU	Peru	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ph	phl	608	PHILIPPINES	Philippines	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
pn	pcn	612	PITCAIRN	Pitcairn	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
pl	pol	616	POLAND	Poland	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
pt	prt	620	PORTUGAL	Portugal	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
pr	pri	630	PUERTO RICO	Puerto Rico	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
qa	qat	634	QATAR	Qatar	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
re	reu	638	REUNION	Reunion	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ro	rom	642	ROMANIA	Romania	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ru	rus	643	RUSSIAN FEDERATION	Russian Federation	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
rw	rwa	646	RWANDA	Rwanda	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
bl	blm	652	SAINT BARTHÉLEMY	Saint Barthélemy	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sh	shn	654	SAINT HELENA	Saint Helena	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
kn	kna	659	SAINT KITTS AND NEVIS	Saint Kitts and Nevis	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
lc	lca	662	SAINT LUCIA	Saint Lucia	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
mf	maf	663	SAINT MARTIN (FRENCH PART)	Saint Martin (French part)	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
pm	spm	666	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
vc	vct	670	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ws	wsm	882	SAMOA	Samoa	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sm	smr	674	SAN MARINO	San Marino	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
st	stp	678	SAO TOME AND PRINCIPE	Sao Tome and Principe	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sa	sau	682	SAUDI ARABIA	Saudi Arabia	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sn	sen	686	SENEGAL	Senegal	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
rs	srb	688	SERBIA	Serbia	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sc	syc	690	SEYCHELLES	Seychelles	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sl	sle	694	SIERRA LEONE	Sierra Leone	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sg	sgp	702	SINGAPORE	Singapore	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sx	sxm	534	SINT MAARTEN	Sint Maarten	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sk	svk	703	SLOVAKIA	Slovakia	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
si	svn	705	SLOVENIA	Slovenia	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sb	slb	090	SOLOMON ISLANDS	Solomon Islands	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
so	som	706	SOMALIA	Somalia	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
za	zaf	710	SOUTH AFRICA	South Africa	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
gs	sgs	239	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ss	ssd	728	SOUTH SUDAN	South Sudan	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
lk	lka	144	SRI LANKA	Sri Lanka	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sd	sdn	729	SUDAN	Sudan	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sr	sur	740	SURINAME	Suriname	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sj	sjm	744	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sz	swz	748	SWAZILAND	Swaziland	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ch	che	756	SWITZERLAND	Switzerland	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
sy	syr	760	SYRIAN ARAB REPUBLIC	Syrian Arab Republic	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tw	twn	158	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tj	tjk	762	TAJIKISTAN	Tajikistan	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tz	tza	834	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
th	tha	764	THAILAND	Thailand	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tl	tls	626	TIMOR LESTE	Timor Leste	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tg	tgo	768	TOGO	Togo	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tk	tkl	772	TOKELAU	Tokelau	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
to	ton	776	TONGA	Tonga	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tt	tto	780	TRINIDAD AND TOBAGO	Trinidad and Tobago	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tn	tun	788	TUNISIA	Tunisia	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tr	tur	792	TURKEY	Turkey	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tm	tkm	795	TURKMENISTAN	Turkmenistan	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tc	tca	796	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
tv	tuv	798	TUVALU	Tuvalu	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ug	uga	800	UGANDA	Uganda	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ua	ukr	804	UKRAINE	Ukraine	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
ae	are	784	UNITED ARAB EMIRATES	United Arab Emirates	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
um	umi	581	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
uy	ury	858	URUGUAY	Uruguay	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
uz	uzb	860	UZBEKISTAN	Uzbekistan	\N	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:36.539-04	\N
vu	vut	548	VANUATU	Vanuatu	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
ve	ven	862	VENEZUELA	Venezuela	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
vn	vnm	704	VIET NAM	Viet Nam	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
vg	vgb	092	VIRGIN ISLANDS, BRITISH	Virgin Islands, British	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
vi	vir	850	VIRGIN ISLANDS, U.S.	Virgin Islands, U.S.	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
wf	wlf	876	WALLIS AND FUTUNA	Wallis and Futuna	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
eh	esh	732	WESTERN SAHARA	Western Sahara	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
ye	yem	887	YEMEN	Yemen	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
zm	zmb	894	ZAMBIA	Zambia	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
zw	zwe	716	ZIMBABWE	Zimbabwe	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
ax	ala	248	ÅLAND ISLANDS	Åland Islands	\N	\N	2025-10-29 17:04:36.54-04	2025-10-29 17:04:36.54-04	\N
dk	dnk	208	DENMARK	Denmark	reg_01K8RWK8TDVR8KP6R1PS4N5H7W	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:49.497-04	\N
fr	fra	250	FRANCE	France	reg_01K8RWK8TDVR8KP6R1PS4N5H7W	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:49.497-04	\N
de	deu	276	GERMANY	Germany	reg_01K8RWK8TDVR8KP6R1PS4N5H7W	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:49.497-04	\N
it	ita	380	ITALY	Italy	reg_01K8RWK8TDVR8KP6R1PS4N5H7W	\N	2025-10-29 17:04:36.538-04	2025-10-29 17:04:49.497-04	\N
es	esp	724	SPAIN	Spain	reg_01K8RWK8TDVR8KP6R1PS4N5H7W	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:49.497-04	\N
se	swe	752	SWEDEN	Sweden	reg_01K8RWK8TDVR8KP6R1PS4N5H7W	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:49.497-04	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	reg_01K8RWK8TDVR8KP6R1PS4N5H7W	\N	2025-10-29 17:04:36.539-04	2025-10-29 17:04:49.497-04	\N
us	usa	840	UNITED STATES	United States	reg_01K8W9KYA1QHSTYD2G2ETMKBSC	\N	2025-10-29 17:04:36.539-04	2025-10-31 00:50:06.285-04	\N
\.


--
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01K8RWV2KZJZTEJ4K57MTBT8W8	pp_system_default	regpp_01K8RWV2MWFCHA76ZSS2TKTNXJ	2025-10-29 17:09:05.306361-04	2025-10-29 17:09:05.306361-04	\N
reg_01K8RWK8TDVR8KP6R1PS4N5H7W	pp_system_default	regpp_01K8RWK8VKGBFE9X5XC16ACTG9	2025-10-29 17:04:49.523216-04	2025-10-30 23:26:08.338-04	2025-10-30 23:26:08.338-04
reg_01K8W9KYA1QHSTYD2G2ETMKBSC	pp_system_default	regpp_01K8W9KYB2MF69S6MRWCA1FG8D	2025-10-31 00:50:06.303913-04	2025-10-31 00:50:06.303913-04	\N
\.


--
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
resitem_01K8S9MW0H9ZR81C2CKHR5T6WC	2025-10-29 20:52:53.403-04	2025-10-30 20:03:47.6-04	2025-10-30 20:03:47.59-04	ordli_01K8S9MVWPTNGCR7BC4K9G7P7H	sloc_01K8RWK8WE14BXV69T1XPA5YSK	1	\N	\N	\N	\N	iitem_01K8RWK96YY04FDCW2WRSNW05E	f	{"value": "1", "precision": 20}
\.


--
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- Data for Name: return_reason; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_reason (id, value, label, description, metadata, parent_return_reason_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01K8RWK37J6CCAMVBZZ92TWT9W	Default Sales Channel	Created by Nick	f	\N	2025-10-29 17:04:43.763-04	2025-10-29 17:09:31.878-04	\N
\.


--
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
sc_01K8RWK37J6CCAMVBZZ92TWT9W	sloc_01K8RWK8WE14BXV69T1XPA5YSK	scloc_01K8RWK91HS8ZJF1HKYY3AWXD7	2025-10-29 17:04:49.712912-04	2025-10-29 17:04:49.712912-04	\N
\.


--
-- Data for Name: script_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.script_migrations (id, script_name, created_at, finished_at) FROM stdin;
1	migrate-product-shipping-profile.js	2025-10-29 17:04:37.940113-04	2025-10-29 17:04:37.97985-04
2	migrate-tax-region-provider.js	2025-10-29 17:04:37.982655-04	2025-10-29 17:04:37.999267-04
\.


--
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
serzo_01K8RWZFKEB2M08DT311ZFNANA	America	\N	fuset_01K8RWK8XDKXQ7J4CP8K15DSYY	2025-10-29 17:11:29.646-04	2025-10-29 17:11:47.025-04	2025-10-29 17:11:47.024-04
serzo_01K8RX1SXW3QDZBFH91WKWW4AH	America 	\N	fuset_01K8RWK8XDKXQ7J4CP8K15DSYY	2025-10-29 17:12:45.756-04	2025-10-29 17:12:45.756-04	\N
serzo_01K8RWK8XD76QB7CXSEQJKJ43F	Europe	\N	fuset_01K8RWK8XDKXQ7J4CP8K15DSYY	2025-10-29 17:04:49.582-04	2025-10-29 17:16:20.79-04	2025-10-29 17:16:20.79-04
\.


--
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
so_01K8RX49ARV8XFWMNSTTCQP521	Standard shipping America 	flat	serzo_01K8RX1SXW3QDZBFH91WKWW4AH	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	manual_manual	{"id": "manual-fulfillment"}	\N	sotype_01K8RWK8ZEYBVZCSZH0AXVE876	2025-10-29 17:14:07.065-04	2025-10-29 17:14:07.065-04	\N
so_01K8RX6A7RYJ0WKGGB9N7VCCKQ	Express shipping America	flat	serzo_01K8RX1SXW3QDZBFH91WKWW4AH	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	manual_manual	{"id": "manual-fulfillment-return", "is_return": true}	\N	sotype_01K8RWK8ZG4NXEPZ7FFPD5GCA4	2025-10-29 17:15:13.528-04	2025-10-29 17:15:41.38-04	2025-10-29 17:15:41.38-04
so_01K8RX80M7TAWH26X3WFB4G73C	Express shipping America	flat	serzo_01K8RX1SXW3QDZBFH91WKWW4AH	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	manual_manual	{"id": "manual-fulfillment"}	\N	sotype_01K8RWK8ZG4NXEPZ7FFPD5GCA4	2025-10-29 17:16:09.224-04	2025-10-29 17:16:09.224-04	\N
so_01K8RWK8ZF13RHZS7QW574KQ5K	Standard Shipping	flat	serzo_01K8RWK8XD76QB7CXSEQJKJ43F	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	manual_manual	\N	\N	sotype_01K8RWK8ZEYBVZCSZH0AXVE876	2025-10-29 17:04:49.648-04	2025-10-29 17:16:20.8-04	2025-10-29 17:16:20.79-04
so_01K8RWK8ZGTW6NND47X5BYQS09	Express Shipping	flat	serzo_01K8RWK8XD76QB7CXSEQJKJ43F	sp_01K8RWJXJJ9XH7WAH4FWS93HQB	manual_manual	\N	\N	sotype_01K8RWK8ZG4NXEPZ7FFPD5GCA4	2025-10-29 17:04:49.649-04	2025-10-29 17:16:20.8-04	2025-10-29 17:16:20.79-04
\.


--
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
so_01K8RWK8ZF13RHZS7QW574KQ5K	pset_01K8RWK906SXWNTXQ7WTDFAZ9D	sops_01K8RWK919F3SYN96PFTWBC6GQ	2025-10-29 17:04:49.7049-04	2025-10-29 17:04:49.7049-04	\N
so_01K8RWK8ZGTW6NND47X5BYQS09	pset_01K8RWK907DSRA8QSDRCTQPMS7	sops_01K8RWK9192N8BK7XH9Y00SZ0J	2025-10-29 17:04:49.7049-04	2025-10-29 17:04:49.7049-04	\N
so_01K8RX49ARV8XFWMNSTTCQP521	pset_01K8RX49BAQ0SXGDD3KWS74YV7	sops_01K8RX49CC7SR3ZDQSC9P81C1M	2025-10-29 17:14:07.116794-04	2025-10-29 17:14:07.116794-04	\N
so_01K8RX6A7RYJ0WKGGB9N7VCCKQ	pset_01K8RX6A850BT8AWJ0RDE8HW2N	sops_01K8RX6A92CMNCV90W59VJYMK5	2025-10-29 17:15:13.570275-04	2025-10-29 17:15:41.398-04	2025-10-29 17:15:41.398-04
so_01K8RX80M7TAWH26X3WFB4G73C	pset_01K8RX80MPR7YQRP37JDM1VT56	sops_01K8RX80NQC1S1V10611DG9V7X	2025-10-29 17:16:09.270389-04	2025-10-29 17:16:09.270389-04	\N
\.


--
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
sorul_01K8RX49ART755779WYASBN158	is_return	eq	"false"	so_01K8RX49ARV8XFWMNSTTCQP521	2025-10-29 17:14:07.065-04	2025-10-29 17:14:07.065-04	\N
sorul_01K8RX49ARBGRP47MR0W3JKH52	enabled_in_store	eq	"true"	so_01K8RX49ARV8XFWMNSTTCQP521	2025-10-29 17:14:07.065-04	2025-10-29 17:14:07.065-04	\N
sorul_01K8RX6A7R8T4X8QQ3EFHGG7Z5	is_return	eq	"true"	so_01K8RX6A7RYJ0WKGGB9N7VCCKQ	2025-10-29 17:15:13.528-04	2025-10-29 17:15:41.386-04	2025-10-29 17:15:41.38-04
sorul_01K8RX6A7R8KFM0WF1ZBGV7K7K	enabled_in_store	eq	"true"	so_01K8RX6A7RYJ0WKGGB9N7VCCKQ	2025-10-29 17:15:13.528-04	2025-10-29 17:15:41.386-04	2025-10-29 17:15:41.38-04
sorul_01K8RX80M7RSSH3XM3AN2AZKVC	is_return	eq	"false"	so_01K8RX80M7TAWH26X3WFB4G73C	2025-10-29 17:16:09.224-04	2025-10-29 17:16:09.224-04	\N
sorul_01K8RX80M72C73QMM8PZQYRTX2	enabled_in_store	eq	"true"	so_01K8RX80M7TAWH26X3WFB4G73C	2025-10-29 17:16:09.224-04	2025-10-29 17:16:09.224-04	\N
sorul_01K8RWK8ZFKE9A19XWN45R9EDR	enabled_in_store	eq	"true"	so_01K8RWK8ZF13RHZS7QW574KQ5K	2025-10-29 17:04:49.649-04	2025-10-29 17:16:20.813-04	2025-10-29 17:16:20.79-04
sorul_01K8RWK8ZFGXVAKT11BPEF4SS7	is_return	eq	"false"	so_01K8RWK8ZF13RHZS7QW574KQ5K	2025-10-29 17:04:49.649-04	2025-10-29 17:16:20.813-04	2025-10-29 17:16:20.79-04
sorul_01K8RWK8ZGBAKDAM4TC76910R5	enabled_in_store	eq	"true"	so_01K8RWK8ZGTW6NND47X5BYQS09	2025-10-29 17:04:49.649-04	2025-10-29 17:16:20.813-04	2025-10-29 17:16:20.79-04
sorul_01K8RWK8ZGKBDN0BPABSBN50CG	is_return	eq	"false"	so_01K8RWK8ZGTW6NND47X5BYQS09	2025-10-29 17:04:49.649-04	2025-10-29 17:16:20.813-04	2025-10-29 17:16:20.79-04
\.


--
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
sotype_01K8RWK8ZEYBVZCSZH0AXVE876	Standard	Ship in 2-3 days.	standard	2025-10-29 17:04:49.648-04	2025-10-29 17:04:49.648-04	\N
sotype_01K8RWK8ZG4NXEPZ7FFPD5GCA4	Express	Ship in 24 hours.	express	2025-10-29 17:04:49.649-04	2025-10-29 17:04:49.649-04	\N
\.


--
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01K8RWJXJJ9XH7WAH4FWS93HQB	Default Shipping Profile	default	\N	2025-10-29 17:04:37.97-04	2025-10-29 17:04:37.97-04	\N
\.


--
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
sloc_01K8RWK8WE14BXV69T1XPA5YSK	2025-10-29 17:04:49.55-04	2025-10-29 17:10:35.966-04	\N	Montreal Warehouse	laddr_01K8RWK8WEA984WXPGR0Y7A3YB	\N
\.


--
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
laddr_01K8RWK8WEA984WXPGR0Y7A3YB	2025-10-29 17:04:49.55-04	2025-10-29 17:10:35.958-04	\N	Sherbrooke Street			Montreal	ca				\N
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01K8RWK3831R2WTSY99XKH9W00	Nick a Deal	sc_01K8RWK37J6CCAMVBZZ92TWT9W	\N	sloc_01K8RWK8WE14BXV69T1XPA5YSK	\N	2025-10-29 17:04:43.778378-04	2025-10-29 17:04:43.778378-04	\N
\.


--
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01K8W9G3GH63DH6STSQTG6BW2F	usd	f	store_01K8RWK3831R2WTSY99XKH9W00	2025-10-31 00:48:00.520257-04	2025-10-31 00:48:00.520257-04	\N
stocur_01K8W9G3GJT5Y1J80KGB8Z9ZZ9	cad	t	store_01K8RWK3831R2WTSY99XKH9W00	2025-10-31 00:48:00.520257-04	2025-10-31 00:48:00.520257-04	\N
\.


--
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
tp_system	t	2025-10-29 17:04:36.569-04	2025-10-29 17:04:36.569-04	\N
\.


--
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
txreg_01K8RWK8VZ2RMX9CD2TYNG79BY	tp_system	gb	\N	\N	\N	2025-10-29 17:04:49.536-04	2025-10-29 17:04:49.536-04	\N	\N
txreg_01K8RWK8VZD7T8JMA058AGJK27	tp_system	de	\N	\N	\N	2025-10-29 17:04:49.536-04	2025-10-29 17:04:49.536-04	\N	\N
txreg_01K8RWK8VZQ3VJNXQDE9SQWQA5	tp_system	dk	\N	\N	\N	2025-10-29 17:04:49.536-04	2025-10-29 17:04:49.536-04	\N	\N
txreg_01K8RWK8VZWZ3YMMZVWJ8BZ12D	tp_system	se	\N	\N	\N	2025-10-29 17:04:49.536-04	2025-10-29 17:04:49.536-04	\N	\N
txreg_01K8RWK8W061437FVM7AS6MQK4	tp_system	fr	\N	\N	\N	2025-10-29 17:04:49.536-04	2025-10-29 17:04:49.536-04	\N	\N
txreg_01K8RWK8W0G16ZD8VA4K0MDBJ4	tp_system	es	\N	\N	\N	2025-10-29 17:04:49.536-04	2025-10-29 17:04:49.536-04	\N	\N
txreg_01K8RWK8W0623TX03JYF240CHP	tp_system	it	\N	\N	\N	2025-10-29 17:04:49.536-04	2025-10-29 17:04:49.536-04	\N	\N
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01K8RWNHYRDPC1T3FZ2KKPK7MM	Nicky	Bruno	nickdevmtl@gmail.com	\N	\N	2025-10-29 17:06:04.377-04	2025-10-29 17:06:04.377-04	\N
\.


--
-- Data for Name: user_preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_preference (id, user_id, key, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: view_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.view_configuration (id, entity, name, user_id, is_system_default, configuration, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at, retention_time, run_id) FROM stdin;
wf_exec_01K8S9MVSC8QW6HBH9RQG3TKBD	complete-cart	cart_01K8S0X34JT7SAJHSFNEHB351N	{"_v": 0, "runId": "01K8S9MVS6WRCC8W2PSDJVYVTZ", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.acquire-lock-step"]}, "_root.acquire-lock-step": {"_v": 0, "id": "_root.acquire-lock-step", "next": ["_root.acquire-lock-step.use-query-graph-step", "_root.acquire-lock-step.cart-query"], "uuid": "01K8RZPHE2HC4X42M6NGHZATFW", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573177, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE2HC4X42M6NGHZATFW", "action": "acquire-lock-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573177, "saveResponse": true}, "_root.acquire-lock-step.cart-query": {"_v": 0, "id": "_root.acquire-lock-step.cart-query", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments"], "uuid": "01K8RZPHE232BJP3FNW4ESA09Q", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573179, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE232BJP3FNW4ESA09Q", "async": false, "action": "cart-query", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1761785573179, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step": {"_v": 0, "id": "_root.acquire-lock-step.use-query-graph-step", "next": [], "uuid": "01K8RZPHE21PABQ6QA2JM98DEZ", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573179, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE21PABQ6QA2JM98DEZ", "action": "use-query-graph-step", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1761785573179, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed"], "uuid": "01K8RZPHE21908F3HS4AK9QZ7Q", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573229, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE21908F3HS4AK9QZ7Q", "action": "validate-cart-payments", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1761785573229, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate"], "uuid": "01K8RZPHE21FBJ2VR681B0VYRT", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573234, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE21FBJ2VR681B0VYRT", "action": "compensate-payment-if-needed", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573234, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query"], "uuid": "01K8RZPHE3RF5HJH46VRA28W4D", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573237, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE3RF5HJH46VRA28W4D", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573237, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping"], "uuid": "01K8RZPHE3D6K86V4MZFAB59SH", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573241, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE3D6K86V4MZFAB59SH", "async": false, "action": "shipping-options-query", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1761785573241, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders"], "uuid": "01K8RZPHE3R8TVQKDZ8Q6XDNNV", "depth": 7, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573253, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE3R8TVQKDZ8Q6XDNNV", "action": "validate-shipping", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1761785573253, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.create-remote-links", "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.update-carts", "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.reserve-inventory-step", "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.register-usage", "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step"], "uuid": "01K8RZPHE3KD8YDECQVAJVWJ0H", "depth": 8, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573256, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE3KD8YDECQVAJVWJ0H", "action": "create-orders", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573256, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.update-carts": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.update-carts", "next": [], "uuid": "01K8RZPHE3TMT923E916QAHHT7", "depth": 9, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573361, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE3TMT923E916QAHHT7", "action": "update-carts", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573361, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.register-usage": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.register-usage", "next": [], "uuid": "01K8RZPHE4689WWDH1SDETVTJ4", "depth": 9, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573361, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE4689WWDH1SDETVTJ4", "action": "register-usage", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573361, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization"], "uuid": "01K8RZPHE4T5M8N3CYW7BK8TFA", "depth": 9, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573361, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE4T5M8N3CYW7BK8TFA", "action": "emit-event-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573361, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.create-remote-links": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.create-remote-links", "next": [], "uuid": "01K8RZPHE3DQ54YJXQ16AY7CC7", "depth": 9, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573361, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE3DQ54YJXQ16AY7CC7", "action": "create-remote-links", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573361, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.reserve-inventory-step": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.reserve-inventory-step", "next": [], "uuid": "01K8RZPHE40TSYCP3GP3TTJE0Y", "depth": 9, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573361, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE40TSYCP3GP3TTJE0Y", "action": "reserve-inventory-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573361, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step"], "uuid": "01K8RZPHE4MZ6732D0YBKN9Y1J", "depth": 10, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573415, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE4MZ6732D0YBKN9Y1J", "action": "beforePaymentAuthorization", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573415, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction"], "uuid": "01K8RZPHE4Q5VYPPEK3Y4EF1FD", "depth": 11, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573419, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE4Q5VYPPEK3Y4EF1FD", "action": "authorize-payment-session-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573419, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated"], "uuid": "01K8RZPHE475XC1V3TETD5NJVP", "depth": 12, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573468, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE475XC1V3TETD5NJVP", "action": "add-order-transaction", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573468, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order"], "uuid": "01K8RZPHE4H2Q2V2Y1AWRTFGYN", "depth": 13, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573472, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE4H2Q2V2Y1AWRTFGYN", "action": "orderCreated", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1761785573472, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order", "next": ["_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order.release-lock-step"], "uuid": "01K8RZPHE418BSGMG5MPCHHEXV", "depth": 14, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573476, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE418BSGMG5MPCHHEXV", "action": "create-order", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1761785573476, "saveResponse": true}, "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order.release-lock-step": {"_v": 0, "id": "_root.acquire-lock-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order.release-lock-step", "next": [], "uuid": "01K8RZPHE4PEGV423CG41ANZW1", "depth": 15, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1761785573479, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K8RZPHE4PEGV423CG41ANZW1", "action": "release-lock-step", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1761785573479, "saveResponse": true}}, "modelId": "complete-cart", "options": {"name": "complete-cart", "store": true, "idempotent": false, "retentionTime": 259200}, "metadata": {"sourcePath": "D:\\\\DEV-D\\\\nick_a_deal\\\\nick-a-deal-shop\\\\node_modules\\\\@medusajs\\\\core-flows\\\\dist\\\\cart\\\\workflows\\\\complete-cart.js", "eventGroupId": "01K8S9MVS4JRTMEABMBJ4NNSBF", "preventReleaseEvents": false}, "startedAt": 1761785573176, "definition": {"next": [{"uuid": "01K8RZPHE21PABQ6QA2JM98DEZ", "action": "use-query-graph-step", "noCompensation": true}, {"next": {"next": {"next": {"next": {"next": {"next": {"next": [{"uuid": "01K8RZPHE3DQ54YJXQ16AY7CC7", "action": "create-remote-links", "noCompensation": false}, {"uuid": "01K8RZPHE3TMT923E916QAHHT7", "action": "update-carts", "noCompensation": false}, {"uuid": "01K8RZPHE40TSYCP3GP3TTJE0Y", "action": "reserve-inventory-step", "noCompensation": false}, {"uuid": "01K8RZPHE4689WWDH1SDETVTJ4", "action": "register-usage", "noCompensation": false}, {"next": {"next": {"next": {"next": {"next": {"next": {"uuid": "01K8RZPHE4PEGV423CG41ANZW1", "action": "release-lock-step", "noCompensation": true}, "uuid": "01K8RZPHE418BSGMG5MPCHHEXV", "action": "create-order", "noCompensation": true}, "uuid": "01K8RZPHE4H2Q2V2Y1AWRTFGYN", "action": "orderCreated", "noCompensation": false}, "uuid": "01K8RZPHE475XC1V3TETD5NJVP", "action": "add-order-transaction", "noCompensation": false}, "uuid": "01K8RZPHE4Q5VYPPEK3Y4EF1FD", "action": "authorize-payment-session-step", "noCompensation": false}, "uuid": "01K8RZPHE4MZ6732D0YBKN9Y1J", "action": "beforePaymentAuthorization", "noCompensation": false}, "uuid": "01K8RZPHE4T5M8N3CYW7BK8TFA", "action": "emit-event-step", "noCompensation": false}], "uuid": "01K8RZPHE3KD8YDECQVAJVWJ0H", "action": "create-orders", "noCompensation": false}, "uuid": "01K8RZPHE3R8TVQKDZ8Q6XDNNV", "action": "validate-shipping", "noCompensation": true}, "uuid": "01K8RZPHE3D6K86V4MZFAB59SH", "async": false, "action": "shipping-options-query", "noCompensation": true, "compensateAsync": false}, "uuid": "01K8RZPHE3RF5HJH46VRA28W4D", "action": "validate", "noCompensation": false}, "uuid": "01K8RZPHE21FBJ2VR681B0VYRT", "action": "compensate-payment-if-needed", "noCompensation": false}, "uuid": "01K8RZPHE21908F3HS4AK9QZ7Q", "action": "validate-cart-payments", "noCompensation": true}, "uuid": "01K8RZPHE232BJP3FNW4ESA09Q", "async": false, "action": "cart-query", "noCompensation": true, "compensateAsync": false}], "uuid": "01K8RZPHE2HC4X42M6NGHZATFW", "action": "acquire-lock-step", "noCompensation": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "cart_01K8S0X34JT7SAJHSFNEHB351N", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "cart-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"data": {"id": "cart_01K8S0X34JT7SAJHSFNEHB351N", "email": "nickdevmtl@gmail.com", "items": [{"id": "cali_01K8S0X3DGSM8JGHXYB3YNZY28", "title": "Medusa Shorts", "total": 21, "cart_id": "cart_01K8S0X34JT7SAJHSFNEHB351N", "variant": {"id": "variant_01K8RWK964XY0C8NYQJ48GA3P2", "product": {"id": "prod_01K8RWK93AZMVKX54EYJ9CY432", "is_giftcard": false, "shipping_profile": {"id": "sp_01K8RWJXJJ9XH7WAH4FWS93HQB"}}, "product_id": "prod_01K8RWK93AZMVKX54EYJ9CY432", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01K8RWK96YY04FDCW2WRSNW05E", "location_levels": [{"location_id": "sloc_01K8RWK8WE14BXV69T1XPA5YSK", "stock_locations": [{"id": "sloc_01K8RWK8WE14BXV69T1XPA5YSK", "name": "Montreal Warehouse", "sales_channels": [{"id": "sc_01K8RWK37J6CCAMVBZZ92TWT9W", "name": "Default Sales Channel"}]}], "stocked_quantity": 1000000, "reserved_quantity": 0, "raw_stocked_quantity": {"value": "1000000", "precision": 20}, "raw_reserved_quantity": {"value": "0", "precision": 20}}], "requires_shipping": true}, "variant_id": "variant_01K8RWK964XY0C8NYQJ48GA3P2", "inventory_item_id": "iitem_01K8RWK96YY04FDCW2WRSNW05E", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 1, "subtitle": "M", "subtotal": 21, "raw_total": {"value": "21", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png", "created_at": "2025-10-29T22:20:05.937Z", "deleted_at": null, "product_id": "prod_01K8RWK93AZMVKX54EYJ9CY432", "unit_price": 21, "updated_at": "2025-10-29T22:20:05.937Z", "variant_id": "variant_01K8RWK964XY0C8NYQJ48GA3P2", "adjustments": [], "is_giftcard": false, "variant_sku": "SHORTS-M", "product_type": null, "raw_subtotal": {"value": "21", "precision": 20}, "product_title": "Medusa Shorts", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M", "discount_total": 0, "original_total": 21, "product_handle": "shorts", "raw_unit_price": {"value": "21", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "original_subtotal": 21, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "21", "precision": 20}, "product_description": "Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_original_subtotal": {"value": "21", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 37, "region": {"id": "reg_01K8RWV2KZJZTEJ4K57MTBT8W8", "name": "North America", "metadata": null, "created_at": "2025-10-29T21:09:05.288Z", "deleted_at": null, "updated_at": "2025-10-29T21:09:05.288Z", "currency_code": "cad", "automatic_taxes": true}, "customer": {"id": "cus_01K8S9FBF3R8RS3AMN86DY8BDD", "email": "nickdevmtl@gmail.com", "phone": null, "metadata": null, "last_name": null, "created_at": "2025-10-30T00:49:52.612Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-10-30T00:49:52.612Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 37, "raw_total": {"value": "37", "precision": 20}, "region_id": "reg_01K8RWV2KZJZTEJ4K57MTBT8W8", "tax_total": 0, "created_at": "2025-10-29T22:20:05.652Z", "item_total": 21, "promotions": [], "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": "cus_01K8S9FBF3R8RS3AMN86DY8BDD", "completed_at": null, "credit_lines": [], "raw_subtotal": {"value": "37", "precision": 20}, "currency_code": "cad", "item_subtotal": 21, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "item_tax_total": 0, "original_total": 37, "raw_item_total": {"value": "21", "precision": 20}, "shipping_total": 16, "billing_address": {"id": "caaddr_01K8S9MBJR3D6YFGG4DHG5B775", "city": "Terrebonne", "phone": "", "company": "", "metadata": null, "province": "QC", "address_1": "212 Rue du Curé Lamothe", "address_2": "", "last_name": "Cotroni", "created_at": "2025-10-30T00:52:36.568Z", "deleted_at": null, "first_name": "Nicky", "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": null, "postal_code": "J6W 5Y2", "country_code": "ca"}, "sales_channel_id": "sc_01K8RWK37J6CCAMVBZZ92TWT9W", "shipping_address": {"id": "caaddr_01K8S9MBJR7D023DWAJBB8CB7J", "city": "Terrebonne", "phone": "", "company": "", "metadata": null, "province": "QC", "address_1": "212 Rue du Curé Lamothe", "address_2": "", "last_name": "Cotroni", "created_at": "2025-10-30T00:52:36.568Z", "deleted_at": null, "first_name": "Nicky", "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": null, "postal_code": "J6W 5Y2", "country_code": "ca"}, "shipping_methods": [{"id": "casm_01K8S9FH87NAGQC6ATJ2PAHVY8", "data": {}, "name": "Express shipping America", "total": 16, "amount": 16, "cart_id": "cart_01K8S0X34JT7SAJHSFNEHB351N", "metadata": null, "subtotal": 16, "raw_total": {"value": "16", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-10-30T00:49:58.535Z", "deleted_at": null, "raw_amount": {"value": "16", "precision": 20}, "updated_at": "2025-10-30T00:49:58.535Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "16", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 16, "is_tax_inclusive": false, "discount_subtotal": 0, "original_subtotal": 16, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "16", "precision": 20}, "shipping_option_id": "so_01K8RX80M7TAWH26X3WFB4G73C", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_original_subtotal": {"value": "16", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "raw_item_subtotal": {"value": "21", "precision": 20}, "shipping_subtotal": 16, "discount_tax_total": 0, "original_tax_total": 0, "payment_collection": {"id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z", "amount": 37, "status": "not_paid", "metadata": null, "created_at": "2025-10-30T00:50:06.880Z", "deleted_at": null, "raw_amount": {"value": "37", "precision": 20}, "updated_at": "2025-10-30T00:50:06.880Z", "completed_at": null, "currency_code": "cad", "captured_amount": null, "refunded_amount": null, "payment_sessions": [{"id": "payses_01K8S9FSEWAZ08S1VXM0VVCX2J", "data": {}, "amount": 37, "status": "pending", "context": {}, "metadata": {}, "created_at": "2025-10-30T00:50:06.940Z", "deleted_at": null, "raw_amount": {"value": "37", "precision": 20}, "updated_at": "2025-10-30T00:50:06.940Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "cad", "payment_collection_id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z"}], "authorized_amount": null, "raw_captured_amount": null, "raw_refunded_amount": null, "raw_authorized_amount": null}, "raw_discount_total": {"value": "0", "precision": 20}, "raw_item_tax_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "37", "precision": 20}, "raw_shipping_total": {"value": "16", "precision": 20}, "shipping_tax_total": 0, "original_item_total": 21, "raw_shipping_subtotal": {"value": "16", "precision": 20}, "original_item_subtotal": 21, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_shipping_tax_total": {"value": "0", "precision": 20}, "original_item_tax_total": 0, "original_shipping_total": 16, "raw_original_item_total": {"value": "21", "precision": 20}, "original_shipping_subtotal": 16, "raw_original_item_subtotal": {"value": "21", "precision": 20}, "original_shipping_tax_total": 0, "raw_original_item_tax_total": {"value": "0", "precision": 20}, "raw_original_shipping_total": {"value": "16", "precision": 20}, "raw_original_shipping_subtotal": {"value": "16", "precision": 20}, "raw_original_shipping_tax_total": {"value": "0", "precision": 20}}}, "compensateInput": {"data": {"id": "cart_01K8S0X34JT7SAJHSFNEHB351N", "email": "nickdevmtl@gmail.com", "items": [{"id": "cali_01K8S0X3DGSM8JGHXYB3YNZY28", "title": "Medusa Shorts", "total": 21, "cart_id": "cart_01K8S0X34JT7SAJHSFNEHB351N", "variant": {"id": "variant_01K8RWK964XY0C8NYQJ48GA3P2", "product": {"id": "prod_01K8RWK93AZMVKX54EYJ9CY432", "is_giftcard": false, "shipping_profile": {"id": "sp_01K8RWJXJJ9XH7WAH4FWS93HQB"}}, "product_id": "prod_01K8RWK93AZMVKX54EYJ9CY432", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01K8RWK96YY04FDCW2WRSNW05E", "location_levels": [{"location_id": "sloc_01K8RWK8WE14BXV69T1XPA5YSK", "stock_locations": [{"id": "sloc_01K8RWK8WE14BXV69T1XPA5YSK", "name": "Montreal Warehouse", "sales_channels": [{"id": "sc_01K8RWK37J6CCAMVBZZ92TWT9W", "name": "Default Sales Channel"}]}], "stocked_quantity": 1000000, "reserved_quantity": 0, "raw_stocked_quantity": {"value": "1000000", "precision": 20}, "raw_reserved_quantity": {"value": "0", "precision": 20}}], "requires_shipping": true}, "variant_id": "variant_01K8RWK964XY0C8NYQJ48GA3P2", "inventory_item_id": "iitem_01K8RWK96YY04FDCW2WRSNW05E", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 1, "subtitle": "M", "subtotal": 21, "raw_total": {"value": "21", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png", "created_at": "2025-10-29T22:20:05.937Z", "deleted_at": null, "product_id": "prod_01K8RWK93AZMVKX54EYJ9CY432", "unit_price": 21, "updated_at": "2025-10-29T22:20:05.937Z", "variant_id": "variant_01K8RWK964XY0C8NYQJ48GA3P2", "adjustments": [], "is_giftcard": false, "variant_sku": "SHORTS-M", "product_type": null, "raw_subtotal": {"value": "21", "precision": 20}, "product_title": "Medusa Shorts", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M", "discount_total": 0, "original_total": 21, "product_handle": "shorts", "raw_unit_price": {"value": "21", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "original_subtotal": 21, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "21", "precision": 20}, "product_description": "Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_original_subtotal": {"value": "21", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 37, "region": {"id": "reg_01K8RWV2KZJZTEJ4K57MTBT8W8", "name": "North America", "metadata": null, "created_at": "2025-10-29T21:09:05.288Z", "deleted_at": null, "updated_at": "2025-10-29T21:09:05.288Z", "currency_code": "cad", "automatic_taxes": true}, "customer": {"id": "cus_01K8S9FBF3R8RS3AMN86DY8BDD", "email": "nickdevmtl@gmail.com", "phone": null, "metadata": null, "last_name": null, "created_at": "2025-10-30T00:49:52.612Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-10-30T00:49:52.612Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 37, "raw_total": {"value": "37", "precision": 20}, "region_id": "reg_01K8RWV2KZJZTEJ4K57MTBT8W8", "tax_total": 0, "created_at": "2025-10-29T22:20:05.652Z", "item_total": 21, "promotions": [], "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": "cus_01K8S9FBF3R8RS3AMN86DY8BDD", "completed_at": null, "credit_lines": [], "raw_subtotal": {"value": "37", "precision": 20}, "currency_code": "cad", "item_subtotal": 21, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "item_tax_total": 0, "original_total": 37, "raw_item_total": {"value": "21", "precision": 20}, "shipping_total": 16, "billing_address": {"id": "caaddr_01K8S9MBJR3D6YFGG4DHG5B775", "city": "Terrebonne", "phone": "", "company": "", "metadata": null, "province": "QC", "address_1": "212 Rue du Curé Lamothe", "address_2": "", "last_name": "Cotroni", "created_at": "2025-10-30T00:52:36.568Z", "deleted_at": null, "first_name": "Nicky", "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": null, "postal_code": "J6W 5Y2", "country_code": "ca"}, "sales_channel_id": "sc_01K8RWK37J6CCAMVBZZ92TWT9W", "shipping_address": {"id": "caaddr_01K8S9MBJR7D023DWAJBB8CB7J", "city": "Terrebonne", "phone": "", "company": "", "metadata": null, "province": "QC", "address_1": "212 Rue du Curé Lamothe", "address_2": "", "last_name": "Cotroni", "created_at": "2025-10-30T00:52:36.568Z", "deleted_at": null, "first_name": "Nicky", "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": null, "postal_code": "J6W 5Y2", "country_code": "ca"}, "shipping_methods": [{"id": "casm_01K8S9FH87NAGQC6ATJ2PAHVY8", "data": {}, "name": "Express shipping America", "total": 16, "amount": 16, "cart_id": "cart_01K8S0X34JT7SAJHSFNEHB351N", "metadata": null, "subtotal": 16, "raw_total": {"value": "16", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-10-30T00:49:58.535Z", "deleted_at": null, "raw_amount": {"value": "16", "precision": 20}, "updated_at": "2025-10-30T00:49:58.535Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "16", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 16, "is_tax_inclusive": false, "discount_subtotal": 0, "original_subtotal": 16, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "16", "precision": 20}, "shipping_option_id": "so_01K8RX80M7TAWH26X3WFB4G73C", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_original_subtotal": {"value": "16", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "raw_item_subtotal": {"value": "21", "precision": 20}, "shipping_subtotal": 16, "discount_tax_total": 0, "original_tax_total": 0, "payment_collection": {"id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z", "amount": 37, "status": "not_paid", "metadata": null, "created_at": "2025-10-30T00:50:06.880Z", "deleted_at": null, "raw_amount": {"value": "37", "precision": 20}, "updated_at": "2025-10-30T00:50:06.880Z", "completed_at": null, "currency_code": "cad", "captured_amount": null, "refunded_amount": null, "payment_sessions": [{"id": "payses_01K8S9FSEWAZ08S1VXM0VVCX2J", "data": {}, "amount": 37, "status": "pending", "context": {}, "metadata": {}, "created_at": "2025-10-30T00:50:06.940Z", "deleted_at": null, "raw_amount": {"value": "37", "precision": 20}, "updated_at": "2025-10-30T00:50:06.940Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "cad", "payment_collection_id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z"}], "authorized_amount": null, "raw_captured_amount": null, "raw_refunded_amount": null, "raw_authorized_amount": null}, "raw_discount_total": {"value": "0", "precision": 20}, "raw_item_tax_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "37", "precision": 20}, "raw_shipping_total": {"value": "16", "precision": 20}, "shipping_tax_total": 0, "original_item_total": 21, "raw_shipping_subtotal": {"value": "16", "precision": 20}, "original_item_subtotal": 21, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_shipping_tax_total": {"value": "0", "precision": 20}, "original_item_tax_total": 0, "original_shipping_total": 16, "raw_original_item_total": {"value": "21", "precision": 20}, "original_shipping_subtotal": 16, "raw_original_item_subtotal": {"value": "21", "precision": 20}, "original_shipping_tax_total": 0, "raw_original_item_tax_total": {"value": "0", "precision": 20}, "raw_original_shipping_total": {"value": "16", "precision": 20}, "raw_original_shipping_subtotal": {"value": "16", "precision": 20}, "raw_original_shipping_tax_total": {"value": "0", "precision": 20}}}}}, "create-order": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "email": "nickdevmtl@gmail.com", "items": [{"id": "ordli_01K8S9MVWPTNGCR7BC4K9G7P7H", "title": "Medusa Shorts", "detail": {"id": "orditem_01K8S9MVWQ8023ZSNAPB63HYB2", "item_id": "ordli_01K8S9MVWPTNGCR7BC4K9G7P7H", "version": 1, "metadata": null, "order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "quantity": 1, "created_at": "2025-10-30T00:52:53.273Z", "deleted_at": null, "unit_price": null, "updated_at": "2025-10-30T00:52:53.273Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "M", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png", "created_at": "2025-10-30T00:52:53.273Z", "deleted_at": null, "product_id": "prod_01K8RWK93AZMVKX54EYJ9CY432", "unit_price": 21, "updated_at": "2025-10-30T00:52:53.273Z", "variant_id": "variant_01K8RWK964XY0C8NYQJ48GA3P2", "adjustments": [], "is_giftcard": false, "variant_sku": "SHORTS-M", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa Shorts", "variant_title": "M", "product_handle": "shorts", "raw_unit_price": {"value": "21", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "accounting_total": 37, "credit_line_total": 0, "transaction_total": 0, "pending_difference": 37, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 37, "original_order_total": 37, "raw_accounting_total": {"value": "37", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "37", "precision": 20}, "raw_current_order_total": {"value": "37", "precision": 20}, "raw_original_order_total": {"value": "37", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01K8RWV2KZJZTEJ4K57MTBT8W8", "created_at": "2025-10-30T00:52:53.273Z", "deleted_at": null, "display_id": 1, "updated_at": "2025-10-30T00:52:53.273Z", "canceled_at": null, "customer_id": "cus_01K8S9FBF3R8RS3AMN86DY8BDD", "credit_lines": [], "transactions": [], "currency_code": "cad", "is_draft_order": false, "billing_address": {"id": "ordaddr_01K8S9MVWC2H6HE5EWK8YWRPPK", "city": "Terrebonne", "phone": "", "company": "", "metadata": null, "province": "QC", "address_1": "212 Rue du Curé Lamothe", "address_2": "", "last_name": "Cotroni", "created_at": "2025-10-30T00:52:36.568Z", "deleted_at": null, "first_name": "Nicky", "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": null, "postal_code": "J6W 5Y2", "country_code": "ca"}, "no_notification": false, "sales_channel_id": "sc_01K8RWK37J6CCAMVBZZ92TWT9W", "shipping_address": {"id": "ordaddr_01K8S9MVWC9R11GFW2500X6ZD7", "city": "Terrebonne", "phone": "", "company": "", "metadata": null, "province": "QC", "address_1": "212 Rue du Curé Lamothe", "address_2": "", "last_name": "Cotroni", "created_at": "2025-10-30T00:52:36.568Z", "deleted_at": null, "first_name": "Nicky", "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": null, "postal_code": "J6W 5Y2", "country_code": "ca"}, "shipping_methods": [{"id": "ordsm_01K8S9MVWKE9P4RKX3GVWHTRE2", "data": {}, "name": "Express shipping America", "amount": 16, "detail": {"id": "ordspmv_01K8S9MVWKXP9PVYX96SBHZAZW", "version": 1, "claim_id": null, "order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "return_id": null, "created_at": "2025-10-30T00:52:53.274Z", "deleted_at": null, "updated_at": "2025-10-30T00:52:53.274Z", "exchange_id": null, "shipping_method_id": "ordsm_01K8S9MVWKE9P4RKX3GVWHTRE2"}, "metadata": null, "order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "tax_lines": [], "created_at": "2025-10-30T00:52:53.274Z", "deleted_at": null, "raw_amount": {"value": "16", "precision": 20}, "updated_at": "2025-10-30T00:52:53.274Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01K8RX80M7TAWH26X3WFB4G73C"}], "billing_address_id": "ordaddr_01K8S9MVWC2H6HE5EWK8YWRPPK", "shipping_address_id": "ordaddr_01K8S9MVWC9R11GFW2500X6ZD7"}, "compensateInput": {"id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "email": "nickdevmtl@gmail.com", "items": [{"id": "ordli_01K8S9MVWPTNGCR7BC4K9G7P7H", "title": "Medusa Shorts", "detail": {"id": "orditem_01K8S9MVWQ8023ZSNAPB63HYB2", "item_id": "ordli_01K8S9MVWPTNGCR7BC4K9G7P7H", "version": 1, "metadata": null, "order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "quantity": 1, "created_at": "2025-10-30T00:52:53.273Z", "deleted_at": null, "unit_price": null, "updated_at": "2025-10-30T00:52:53.273Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "M", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png", "created_at": "2025-10-30T00:52:53.273Z", "deleted_at": null, "product_id": "prod_01K8RWK93AZMVKX54EYJ9CY432", "unit_price": 21, "updated_at": "2025-10-30T00:52:53.273Z", "variant_id": "variant_01K8RWK964XY0C8NYQJ48GA3P2", "adjustments": [], "is_giftcard": false, "variant_sku": "SHORTS-M", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa Shorts", "variant_title": "M", "product_handle": "shorts", "raw_unit_price": {"value": "21", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "accounting_total": 37, "credit_line_total": 0, "transaction_total": 0, "pending_difference": 37, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 37, "original_order_total": 37, "raw_accounting_total": {"value": "37", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "37", "precision": 20}, "raw_current_order_total": {"value": "37", "precision": 20}, "raw_original_order_total": {"value": "37", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01K8RWV2KZJZTEJ4K57MTBT8W8", "created_at": "2025-10-30T00:52:53.273Z", "deleted_at": null, "display_id": 1, "updated_at": "2025-10-30T00:52:53.273Z", "canceled_at": null, "customer_id": "cus_01K8S9FBF3R8RS3AMN86DY8BDD", "credit_lines": [], "transactions": [], "currency_code": "cad", "is_draft_order": false, "billing_address": {"id": "ordaddr_01K8S9MVWC2H6HE5EWK8YWRPPK", "city": "Terrebonne", "phone": "", "company": "", "metadata": null, "province": "QC", "address_1": "212 Rue du Curé Lamothe", "address_2": "", "last_name": "Cotroni", "created_at": "2025-10-30T00:52:36.568Z", "deleted_at": null, "first_name": "Nicky", "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": null, "postal_code": "J6W 5Y2", "country_code": "ca"}, "no_notification": false, "sales_channel_id": "sc_01K8RWK37J6CCAMVBZZ92TWT9W", "shipping_address": {"id": "ordaddr_01K8S9MVWC9R11GFW2500X6ZD7", "city": "Terrebonne", "phone": "", "company": "", "metadata": null, "province": "QC", "address_1": "212 Rue du Curé Lamothe", "address_2": "", "last_name": "Cotroni", "created_at": "2025-10-30T00:52:36.568Z", "deleted_at": null, "first_name": "Nicky", "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": null, "postal_code": "J6W 5Y2", "country_code": "ca"}, "shipping_methods": [{"id": "ordsm_01K8S9MVWKE9P4RKX3GVWHTRE2", "data": {}, "name": "Express shipping America", "amount": 16, "detail": {"id": "ordspmv_01K8S9MVWKXP9PVYX96SBHZAZW", "version": 1, "claim_id": null, "order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "return_id": null, "created_at": "2025-10-30T00:52:53.274Z", "deleted_at": null, "updated_at": "2025-10-30T00:52:53.274Z", "exchange_id": null, "shipping_method_id": "ordsm_01K8S9MVWKE9P4RKX3GVWHTRE2"}, "metadata": null, "order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "tax_lines": [], "created_at": "2025-10-30T00:52:53.274Z", "deleted_at": null, "raw_amount": {"value": "16", "precision": 20}, "updated_at": "2025-10-30T00:52:53.274Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01K8RX80M7TAWH26X3WFB4G73C"}], "billing_address_id": "ordaddr_01K8S9MVWC2H6HE5EWK8YWRPPK", "shipping_address_id": "ordaddr_01K8S9MVWC9R11GFW2500X6ZD7"}}}, "orderCreated": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "update-carts": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "cart_01K8S0X34JT7SAJHSFNEHB351N", "email": "nickdevmtl@gmail.com", "metadata": null, "region_id": "reg_01K8RWV2KZJZTEJ4K57MTBT8W8", "created_at": "2025-10-29T22:20:05.652Z", "deleted_at": null, "updated_at": "2025-10-30T00:52:53.396Z", "customer_id": "cus_01K8S9FBF3R8RS3AMN86DY8BDD", "completed_at": "2025-10-30T00:52:53.366Z", "currency_code": "cad", "billing_address": {"id": "caaddr_01K8S9MBJR3D6YFGG4DHG5B775"}, "sales_channel_id": "sc_01K8RWK37J6CCAMVBZZ92TWT9W", "shipping_address": {"id": "caaddr_01K8S9MBJR7D023DWAJBB8CB7J"}, "billing_address_id": "caaddr_01K8S9MBJR3D6YFGG4DHG5B775", "shipping_address_id": "caaddr_01K8S9MBJR7D023DWAJBB8CB7J"}], "compensateInput": [{"id": "cart_01K8S0X34JT7SAJHSFNEHB351N", "email": "nickdevmtl@gmail.com", "metadata": null, "region_id": "reg_01K8RWV2KZJZTEJ4K57MTBT8W8", "customer_id": "cus_01K8S9FBF3R8RS3AMN86DY8BDD", "completed_at": null, "currency_code": "cad", "sales_channel_id": "sc_01K8RWK37J6CCAMVBZZ92TWT9W"}]}}, "create-orders": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "email": "nickdevmtl@gmail.com", "items": [{"id": "ordli_01K8S9MVWPTNGCR7BC4K9G7P7H", "title": "Medusa Shorts", "detail": {"id": "orditem_01K8S9MVWQ8023ZSNAPB63HYB2", "item_id": "ordli_01K8S9MVWPTNGCR7BC4K9G7P7H", "version": 1, "metadata": null, "order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "quantity": 1, "created_at": "2025-10-30T00:52:53.273Z", "deleted_at": null, "unit_price": null, "updated_at": "2025-10-30T00:52:53.273Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "M", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png", "created_at": "2025-10-30T00:52:53.273Z", "deleted_at": null, "product_id": "prod_01K8RWK93AZMVKX54EYJ9CY432", "unit_price": 21, "updated_at": "2025-10-30T00:52:53.273Z", "variant_id": "variant_01K8RWK964XY0C8NYQJ48GA3P2", "adjustments": [], "is_giftcard": false, "variant_sku": "SHORTS-M", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa Shorts", "variant_title": "M", "product_handle": "shorts", "raw_unit_price": {"value": "21", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "accounting_total": 37, "credit_line_total": 0, "transaction_total": 0, "pending_difference": 37, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 37, "original_order_total": 37, "raw_accounting_total": {"value": "37", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "37", "precision": 20}, "raw_current_order_total": {"value": "37", "precision": 20}, "raw_original_order_total": {"value": "37", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01K8RWV2KZJZTEJ4K57MTBT8W8", "created_at": "2025-10-30T00:52:53.273Z", "deleted_at": null, "display_id": 1, "updated_at": "2025-10-30T00:52:53.273Z", "canceled_at": null, "customer_id": "cus_01K8S9FBF3R8RS3AMN86DY8BDD", "credit_lines": [], "transactions": [], "currency_code": "cad", "is_draft_order": false, "billing_address": {"id": "ordaddr_01K8S9MVWC2H6HE5EWK8YWRPPK", "city": "Terrebonne", "phone": "", "company": "", "metadata": null, "province": "QC", "address_1": "212 Rue du Curé Lamothe", "address_2": "", "last_name": "Cotroni", "created_at": "2025-10-30T00:52:36.568Z", "deleted_at": null, "first_name": "Nicky", "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": null, "postal_code": "J6W 5Y2", "country_code": "ca"}, "no_notification": false, "sales_channel_id": "sc_01K8RWK37J6CCAMVBZZ92TWT9W", "shipping_address": {"id": "ordaddr_01K8S9MVWC9R11GFW2500X6ZD7", "city": "Terrebonne", "phone": "", "company": "", "metadata": null, "province": "QC", "address_1": "212 Rue du Curé Lamothe", "address_2": "", "last_name": "Cotroni", "created_at": "2025-10-30T00:52:36.568Z", "deleted_at": null, "first_name": "Nicky", "updated_at": "2025-10-30T00:52:36.568Z", "customer_id": null, "postal_code": "J6W 5Y2", "country_code": "ca"}, "shipping_methods": [{"id": "ordsm_01K8S9MVWKE9P4RKX3GVWHTRE2", "data": {}, "name": "Express shipping America", "amount": 16, "detail": {"id": "ordspmv_01K8S9MVWKXP9PVYX96SBHZAZW", "version": 1, "claim_id": null, "order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "return_id": null, "created_at": "2025-10-30T00:52:53.274Z", "deleted_at": null, "updated_at": "2025-10-30T00:52:53.274Z", "exchange_id": null, "shipping_method_id": "ordsm_01K8S9MVWKE9P4RKX3GVWHTRE2"}, "metadata": null, "order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW", "tax_lines": [], "created_at": "2025-10-30T00:52:53.274Z", "deleted_at": null, "raw_amount": {"value": "16", "precision": 20}, "updated_at": "2025-10-30T00:52:53.274Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01K8RX80M7TAWH26X3WFB4G73C"}], "billing_address_id": "ordaddr_01K8S9MVWC2H6HE5EWK8YWRPPK", "shipping_address_id": "ordaddr_01K8S9MVWC9R11GFW2500X6ZD7"}], "compensateInput": ["order_01K8S9MVWM4KDN1M9RZHTZJHYW"]}}, "register-usage": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": {"computedActions": [], "registrationContext": {"customer_id": "cus_01K8S9FBF3R8RS3AMN86DY8BDD", "customer_email": "nickdevmtl@gmail.com"}}}}, "emit-event-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"eventName": "order.placed", "eventGroupId": "01K8S9MVS4JRTMEABMBJ4NNSBF"}, "compensateInput": {"eventName": "order.placed", "eventGroupId": "01K8S9MVS4JRTMEABMBJ4NNSBF"}}}, "acquire-lock-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": {"keys": ["cart_01K8S0X34JT7SAJHSFNEHB351N"]}}}, "release-lock-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": true, "compensateInput": true}}, "validate-shipping": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "create-remote-links": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"cart": {"cart_id": "cart_01K8S0X34JT7SAJHSFNEHB351N"}, "order": {"order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW"}}, {"order": {"order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW"}, "payment": {"payment_collection_id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z"}}], "compensateInput": [{"cart": {"cart_id": "cart_01K8S0X34JT7SAJHSFNEHB351N"}, "order": {"order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW"}}, {"order": {"order_id": "order_01K8S9MVWM4KDN1M9RZHTZJHYW"}, "payment": {"payment_collection_id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z"}}]}}, "use-query-graph-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {}, "compensateInput": {}}}, "add-order-transaction": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": null}}, "reserve-inventory-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "resitem_01K8S9MW0H9ZR81C2CKHR5T6WC", "metadata": null, "quantity": 1, "created_at": "2025-10-30T00:52:53.403Z", "created_by": null, "deleted_at": null, "updated_at": "2025-10-30T00:52:53.403Z", "description": null, "external_id": null, "location_id": "sloc_01K8RWK8WE14BXV69T1XPA5YSK", "line_item_id": "ordli_01K8S9MVWPTNGCR7BC4K9G7P7H", "raw_quantity": {"value": "1", "precision": 20}, "allow_backorder": false, "inventory_item_id": "iitem_01K8RWK96YY04FDCW2WRSNW05E"}], "compensateInput": {"reservations": ["resitem_01K8S9MW0H9ZR81C2CKHR5T6WC"], "inventoryItemIds": ["iitem_01K8RWK96YY04FDCW2WRSNW05E"]}}}, "shipping-options-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"data": [{"id": "so_01K8RX80M7TAWH26X3WFB4G73C", "shipping_profile_id": "sp_01K8RWJXJJ9XH7WAH4FWS93HQB"}]}, "compensateInput": {"data": [{"id": "so_01K8RX80M7TAWH26X3WFB4G73C", "shipping_profile_id": "sp_01K8RWJXJJ9XH7WAH4FWS93HQB"}]}}}, "validate-cart-payments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "payses_01K8S9FSEWAZ08S1VXM0VVCX2J", "data": {}, "amount": 37, "status": "pending", "context": {}, "metadata": {}, "created_at": "2025-10-30T00:50:06.940Z", "deleted_at": null, "raw_amount": {"value": "37", "precision": 20}, "updated_at": "2025-10-30T00:50:06.940Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "cad", "payment_collection_id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z"}], "compensateInput": [{"id": "payses_01K8S9FSEWAZ08S1VXM0VVCX2J", "data": {}, "amount": 37, "status": "pending", "context": {}, "metadata": {}, "created_at": "2025-10-30T00:50:06.940Z", "deleted_at": null, "raw_amount": {"value": "37", "precision": 20}, "updated_at": "2025-10-30T00:50:06.940Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "cad", "payment_collection_id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z"}]}}, "beforePaymentAuthorization": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "compensate-payment-if-needed": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": "payses_01K8S9FSEWAZ08S1VXM0VVCX2J", "compensateInput": "payses_01K8S9FSEWAZ08S1VXM0VVCX2J"}}, "authorize-payment-session-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "pay_01K8S9MW1V1Y9CF6Q3RZFYP0RH", "data": {}, "amount": 37, "captures": [], "metadata": null, "created_at": "2025-10-30T00:52:53.435Z", "deleted_at": null, "raw_amount": {"value": "37", "precision": 20}, "updated_at": "2025-10-30T00:52:53.435Z", "canceled_at": null, "captured_at": null, "provider_id": "pp_system_default", "currency_code": "cad", "payment_collection": {"id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z"}, "payment_session_id": "payses_01K8S9FSEWAZ08S1VXM0VVCX2J", "payment_collection_id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z"}, "compensateInput": {"id": "pay_01K8S9MW1V1Y9CF6Q3RZFYP0RH", "data": {}, "amount": 37, "captures": [], "metadata": null, "created_at": "2025-10-30T00:52:53.435Z", "deleted_at": null, "raw_amount": {"value": "37", "precision": 20}, "updated_at": "2025-10-30T00:52:53.435Z", "canceled_at": null, "captured_at": null, "provider_id": "pp_system_default", "currency_code": "cad", "payment_collection": {"id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z"}, "payment_session_id": "payses_01K8S9FSEWAZ08S1VXM0VVCX2J", "payment_collection_id": "pay_col_01K8S9FSD0BR7BQQK1DSCFPP7Z"}}}}, "payload": {"id": "cart_01K8S0X34JT7SAJHSFNEHB351N"}, "compensate": {}}, "errors": []}	done	2025-10-30 00:52:53.164	2025-10-30 00:52:53.489	\N	259200	01K8S9MVS6WRCC8W2PSDJVYVTZ
\.


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 18, true);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 138, true);


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 1, true);


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_display_id_seq', 1, true);


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- Name: script_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.script_migrations_id_seq', 2, true);


--
-- Name: account_holder account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_holder
    ADD CONSTRAINT account_holder_pkey PRIMARY KEY (id);


--
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: credit_line credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_pkey PRIMARY KEY (id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- Name: customer_account_holder customer_account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_account_holder
    ADD CONSTRAINT customer_account_holder_pkey PRIMARY KEY (customer_id, account_holder_id);


--
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- Name: order_credit_line order_credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_pkey PRIMARY KEY (id);


--
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_pkey PRIMARY KEY (id);


--
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- Name: product_shipping_profile product_shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_shipping_profile
    ADD CONSTRAINT product_shipping_profile_pkey PRIMARY KEY (product_id, shipping_profile_id);


--
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget_usage promotion_campaign_budget_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget_usage
    ADD CONSTRAINT promotion_campaign_budget_usage_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- Name: script_migrations script_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.script_migrations
    ADD CONSTRAINT script_migrations_pkey PRIMARY KEY (id);


--
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_preference user_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_preference
    ADD CONSTRAINT user_preference_pkey PRIMARY KEY (id);


--
-- Name: view_configuration view_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_configuration
    ADD CONSTRAINT view_configuration_pkey PRIMARY KEY (id);


--
-- Name: workflow_execution workflow_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT workflow_execution_pkey PRIMARY KEY (workflow_id, transaction_id, run_id);


--
-- Name: IDX_account_holder_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_account_holder_deleted_at" ON public.account_holder USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_account_holder_id_5cb3a0c0" ON public.customer_account_holder USING btree (account_holder_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_provider_id_external_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_account_holder_provider_id_external_id_unique" ON public.account_holder USING btree (provider_id, external_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_deleted_at" ON public.api_key USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_redacted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_redacted" ON public.api_key USING btree (redacted) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_revoked_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_revoked_at" ON public.api_key USING btree (revoked_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- Name: IDX_auth_identity_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_auth_identity_deleted_at" ON public.auth_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- Name: IDX_cart_credit_line_reference_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_credit_line_reference_reference_id" ON public.credit_line USING btree (reference, reference_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_credit_line_cart_id" ON public.credit_line USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_credit_line_deleted_at" ON public.credit_line USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- Name: IDX_customer_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_address_deleted_at" ON public.customer_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- Name: IDX_customer_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_deleted_at" ON public.customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- Name: IDX_customer_group_customer_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_deleted_at" ON public.customer_group_customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_deleted_at" ON public.customer_group USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_id_5cb3a0c0" ON public.customer_account_holder USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_17a262437" ON public.product_shipping_profile USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_5cb3a0c0" ON public.customer_account_holder USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_provider_deleted_at" ON public.fulfillment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- Name: IDX_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_17a262437" ON public.product_shipping_profile USING btree (id);


--
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- Name: IDX_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_5cb3a0c0" ON public.customer_account_holder USING btree (id);


--
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- Name: IDX_image_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_image_deleted_at" ON public.image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_image_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_image_product_id" ON public.image USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_sku; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_level_location_id_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_invite_email_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_invite_email_unique" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- Name: IDX_line_item_product_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_product_type_id" ON public.order_line_item USING btree (product_type_id) WHERE ((deleted_at IS NULL) AND (product_type_id IS NOT NULL));


--
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- Name: IDX_notification_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_deleted_at" ON public.notification USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_provider_deleted_at" ON public.notification_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- Name: IDX_option_product_id_title_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);


--
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- Name: IDX_order_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_address_deleted_at" ON public.order_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_version" ON public.order_change USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_credit_line_deleted_at" ON public.order_credit_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_credit_line_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_credit_line_order_id" ON public.order_credit_line USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_credit_line_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_credit_line_order_id_version" ON public.order_credit_line USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_sales_channel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_sales_channel_id" ON public."order" USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_shipping_method_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_summary_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_order_id" ON public.order_transaction USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- Name: IDX_payment_payment_session_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_payment_payment_session_id_unique" ON public.payment USING btree (payment_session_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_deleted_at" ON public.payment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_id_status_starts_at_ends_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_id_status_starts_at_ends_at" ON public.price_list USING btree (id, status, starts_at, ends_at) WHERE ((deleted_at IS NULL) AND (status = 'active'::text));


--
-- Name: IDX_price_list_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_attribute" ON public.price_list_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_value" ON public.price_list_rule USING gin (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_attribute" ON public.price_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_attribute_value" ON public.price_rule USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value_price_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_attribute_value_price_id" ON public.price_rule USING btree (attribute, value, price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_rule_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_operator" ON public.price_rule USING btree (operator);


--
-- Name: IDX_price_rule_operator_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_operator_value" ON public.price_rule USING btree (operator, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_price_id" ON public.price_rule USING btree (price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id_attribute_operator_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_operator_unique" ON public.price_rule USING btree (price_id, attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_parent_category_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_parent_category_id" ON public.product_category USING btree (parent_category_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_id_17a262437" ON public.product_shipping_profile USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_rank; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_rank" ON public.image USING btree (rank) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_rank_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_rank_product_id" ON public.image USING btree (rank, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_url_rank_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_url_rank_product_id" ON public.image USING btree (url, rank, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- Name: IDX_product_option_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_product_id" ON public.product_option USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- Name: IDX_product_option_value_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_value_option_id" ON public.product_option_value USING btree (option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_status" ON public.product USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_id_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_id_product_id" ON public.product_variant USING btree (id, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_promotion_application_method_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_application_method_deleted_at" ON public.promotion_application_method USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_promotion_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_application_method_promotion_id_unique" ON public.promotion_application_method USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_campaign_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_campaign_id_unique" ON public.promotion_campaign_budget USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_budget_deleted_at" ON public.promotion_campaign_budget USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_usage_attribute_value_budget_id_u; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_usage_attribute_value_budget_id_u" ON public.promotion_campaign_budget_usage USING btree (attribute_value, budget_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_usage_budget_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_budget_usage_budget_id" ON public.promotion_campaign_budget_usage USING btree (budget_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_usage_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_budget_usage_deleted_at" ON public.promotion_campaign_budget_usage USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_deleted_at" ON public.promotion_campaign USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_id" ON public.promotion USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_deleted_at" ON public.promotion USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_is_automatic; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_is_automatic" ON public.promotion USING btree (is_automatic) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- Name: IDX_promotion_rule_attribute_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_attribute_operator" ON public.promotion_rule USING btree (attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_attribute_operator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_attribute_operator_id" ON public.promotion_rule USING btree (operator, attribute, id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_deleted_at" ON public.promotion_rule USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- Name: IDX_promotion_rule_value_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_deleted_at" ON public.promotion_rule_value USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_promotion_rule_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_promotion_rule_id" ON public.promotion_rule_value USING btree (promotion_rule_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_rule_id_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_rule_id_value" ON public.promotion_rule_value USING btree (promotion_rule_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_value" ON public.promotion_rule_value USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_status" ON public.promotion USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- Name: IDX_provider_identity_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_provider_identity_deleted_at" ON public.provider_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_reason_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_reason_deleted_at" ON public.refund_reason USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_refund_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_refund_reason_id" ON public.refund USING btree (refund_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_country_deleted_at" ON public.region_country USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_country_region_id" ON public.region_country USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_parent_return_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_reason_parent_return_reason_id" ON public.return_reason USING btree (parent_return_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_profile_id_17a262437" ON public.product_shipping_profile USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_address_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_stock_location_address_id_unique" ON public.stock_location USING btree (address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_store_currency_store_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_currency_store_id" ON public.store_currency USING btree (store_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_provider_deleted_at" ON public.tax_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- Name: IDX_tax_region_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_provider_id" ON public.tax_region USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_unique_promotion_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_unique_promotion_code" ON public.promotion USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_user_email_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_user_email_unique" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_preference_deleted_at" ON public.user_preference USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_preference_user_id" ON public.user_preference USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_user_id_key_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_user_preference_user_id_key_unique" ON public.user_preference USING btree (user_id, key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_deleted_at" ON public.view_configuration USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_entity_is_system_default; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_entity_is_system_default" ON public.view_configuration USING btree (entity, is_system_default) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_entity_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_entity_user_id" ON public.view_configuration USING btree (entity, user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_user_id" ON public.view_configuration USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_deleted_at" ON public.workflow_execution USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_retention_time_updated_at_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_retention_time_updated_at_state" ON public.workflow_execution USING btree (retention_time, updated_at, state) WHERE ((deleted_at IS NULL) AND (retention_time IS NOT NULL));


--
-- Name: IDX_workflow_execution_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_run_id" ON public.workflow_execution USING btree (run_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_state_updated_at" ON public.workflow_execution USING btree (state, updated_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_updated_at_retention_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_updated_at_retention_time" ON public.workflow_execution USING btree (updated_at, retention_time) WHERE ((deleted_at IS NULL) AND (retention_time IS NOT NULL) AND ((state)::text = ANY ((ARRAY['done'::character varying, 'failed'::character varying, 'reverted'::character varying])::text[])));


--
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_workflow_id_transaction_id" ON public.workflow_execution USING btree (workflow_id, transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id_run_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_workflow_execution_workflow_id_transaction_id_run_id_unique" ON public.workflow_execution USING btree (workflow_id, transaction_id, run_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_script_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_script_name_unique ON public.script_migrations USING btree (script_name);


--
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: credit_line credit_line_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE;


--
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: image image_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_credit_line order_credit_line_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_summary order_summary_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_col_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_col_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_pro_2d555_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_pro_2d555_foreign FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_session payment_session_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget_usage promotion_campaign_budget_usage_budget_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget_usage
    ADD CONSTRAINT promotion_campaign_budget_usage_budget_id_foreign FOREIGN KEY (budget_id) REFERENCES public.promotion_campaign_budget(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: return_reason return_reason_parent_return_reason_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id);


--
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict SjT4Oh5CarfYHDEXESw6oStkAm4IKnQlAQuU0aw8148zQetfhlfcJ8c9PmEb3ee

