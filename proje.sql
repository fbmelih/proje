--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

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

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch (
    branch_id integer NOT NULL,
    branch_name character varying(50),
    branch_city character varying(50),
    branch_region character varying(50)
);


ALTER TABLE public.branch OWNER TO postgres;

--
-- Name: branch_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.branch_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.branch_branch_id_seq OWNER TO postgres;

--
-- Name: branch_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_branch_id_seq OWNED BY public.branch.branch_id;


--
-- Name: ins_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ins_policy (
    policy_id integer NOT NULL,
    policy_type character varying(50),
    ins_commusion integer,
    ins_risk integer,
    start_date date,
    ins_company_id integer,
    ins_premium integer,
    earthquake_cov character varying(5),
    flood_cov character varying(5),
    customer_id integer,
    CONSTRAINT chk_earthquake_flood CHECK ((((earthquake_cov)::text = ANY ((ARRAY['true'::character varying, 'false'::character varying])::text[])) AND ((flood_cov)::text = ANY ((ARRAY['true'::character varying, 'false'::character varying])::text[]))))
);


ALTER TABLE public.ins_policy OWNER TO postgres;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    sales_id integer NOT NULL,
    customer_id integer,
    branch_id integer,
    salesdate date,
    policy_id integer,
    ins_company_id integer
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- Name: branch_performance; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.branch_performance AS
 SELECT branch.branch_id,
    branch.branch_name,
    count(sales.sales_id) AS total_number_of_sales,
    sum(ins_policy.ins_commusion) AS total_commusion,
    sum(ins_policy.ins_premium) AS total_premium
   FROM ((public.branch
     LEFT JOIN public.sales ON ((branch.branch_id = sales.branch_id)))
     LEFT JOIN public.ins_policy ON ((sales.policy_id = ins_policy.policy_id)))
  GROUP BY branch.branch_id, branch.branch_name
  ORDER BY branch.branch_id;


ALTER VIEW public.branch_performance OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customer_id integer NOT NULL,
    name character varying(50),
    surname character varying(50),
    age integer,
    location character varying(50),
    state character varying(50),
    postal_code character varying(50),
    email character varying(100)
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_customer_id_seq OWNER TO postgres;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_customer_id_seq OWNED BY public.customer.customer_id;


--
-- Name: customer_policies_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.customer_policies_details AS
 SELECT customer.name,
    customer.surname,
    ins_policy.policy_id,
    ins_policy.policy_type,
    ins_policy.ins_premium
   FROM (public.ins_policy
     LEFT JOIN public.customer ON ((ins_policy.customer_id = customer.customer_id)))
  ORDER BY customer.name, customer.surname;


ALTER VIEW public.customer_policies_details OWNER TO postgres;

--
-- Name: customers_paid_premiums; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.customers_paid_premiums AS
 SELECT customer.name,
    customer.surname,
    string_agg((ins_policy.ins_premium)::text, ', '::text ORDER BY ins_policy.policy_id) AS premium_details
   FROM (public.customer
     LEFT JOIN public.ins_policy ON ((customer.customer_id = ins_policy.customer_id)))
  GROUP BY customer.name, customer.surname
  ORDER BY customer.name, customer.surname;


ALTER VIEW public.customers_paid_premiums OWNER TO postgres;

--
-- Name: ins_policy_policy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ins_policy_policy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ins_policy_policy_id_seq OWNER TO postgres;

--
-- Name: insurance_companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insurance_companies (
    ins_company_id integer NOT NULL,
    ins_company_name character varying(50)
);


ALTER TABLE public.insurance_companies OWNER TO postgres;

--
-- Name: insurance_companies_ins_company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insurance_companies_ins_company_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.insurance_companies_ins_company_id_seq OWNER TO postgres;

--
-- Name: insurance_companies_ins_company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insurance_companies_ins_company_id_seq OWNED BY public.insurance_companies.ins_company_id;


--
-- Name: policy_policy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.policy_policy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.policy_policy_id_seq OWNER TO postgres;

--
-- Name: policy_policy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.policy_policy_id_seq OWNED BY public.ins_policy.policy_id;


--
-- Name: sales_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sales_sales_id_seq OWNER TO postgres;

--
-- Name: sales_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_sales_id_seq OWNED BY public.sales.sales_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(20) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: branch branch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch ALTER COLUMN branch_id SET DEFAULT nextval('public.branch_branch_id_seq'::regclass);


--
-- Name: customer customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer ALTER COLUMN customer_id SET DEFAULT nextval('public.customer_customer_id_seq'::regclass);


--
-- Name: ins_policy policy_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ins_policy ALTER COLUMN policy_id SET DEFAULT nextval('public.policy_policy_id_seq'::regclass);


--
-- Name: insurance_companies ins_company_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_companies ALTER COLUMN ins_company_id SET DEFAULT nextval('public.insurance_companies_ins_company_id_seq'::regclass);


--
-- Name: sales sales_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales ALTER COLUMN sales_id SET DEFAULT nextval('public.sales_sales_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: branch branch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pkey PRIMARY KEY (branch_id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: insurance_companies ins_company_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_companies
    ADD CONSTRAINT ins_company_id UNIQUE (ins_company_id) INCLUDE (ins_company_id);


--
-- Name: insurance_companies insurance_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_companies
    ADD CONSTRAINT insurance_companies_pkey PRIMARY KEY (ins_company_id);


--
-- Name: ins_policy policy_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ins_policy
    ADD CONSTRAINT policy_id UNIQUE (policy_id) INCLUDE (policy_id);


--
-- Name: ins_policy policy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ins_policy
    ADD CONSTRAINT policy_pkey PRIMARY KEY (policy_id);


--
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (sales_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: ins_policy INS_COMPANY_ID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ins_policy
    ADD CONSTRAINT "INS_COMPANY_ID" FOREIGN KEY (ins_company_id) REFERENCES public.insurance_companies(ins_company_id) NOT VALID;


--
-- Name: ins_policy customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ins_policy
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) NOT VALID;


--
-- Name: ins_policy customer_id_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ins_policy
    ADD CONSTRAINT customer_id_foreign_key FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

