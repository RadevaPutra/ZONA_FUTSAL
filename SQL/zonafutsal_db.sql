--
-- PostgreSQL database dump
--

\restrict xXbvmNzGz6LLCcRgJ9ah7bDPfm0QeynGmpMQDaGCtconCmgm7IttK9N3tEjQ4lq

-- Dumped from database version 18.3 (Homebrew)
-- Dumped by pg_dump version 18.2

-- Started on 2026-05-24 22:21:20 WIB

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16407)
-- Name: users; Type: TABLE; Schema: public; Owner: anom
--

CREATE TABLE public.users (
    id integer NOT NULL,
    nama character varying(100),
    email character varying(100),
    password character varying(100),
    nomor_telepon character varying(20),
    foto_profile text
);


ALTER TABLE public.users OWNER TO anom;

--
-- TOC entry 219 (class 1259 OID 16406)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: anom
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO anom;

--
-- TOC entry 3852 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anom
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3695 (class 2604 OID 16410)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: anom
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3846 (class 0 OID 16407)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: anom
--

COPY public.users (id, nama, email, password, nomor_telepon, foto_profile) FROM stdin;
2	anom10	anom@gmail.com	$2b$10$Fvjfz/ihx6e.ipXf85viEeKPMPJht/SUeiizPbwVItmc68jqvm1ki	08966666666	\N
3	anom	anom@gmail.com	$2b$10$jOPCMOohU8kL3sDZNhR.h.k5hzdNE34xTveJRqf.bzJNSUyvsNblW	08970449852	\N
4	ayuradha	anom10@gmail.com	$2b$10$DaU5T7CNlfYt8rZmQmx19OGNIhyxDSyL7fwsJnanRH/yPF2/oCZbK	0897044985222	\N
5	ayu	ayu@gmail.com	$2b$10$XD8LDTUPhCuucPAg/qgK4u1bQWm/2rZeB2kzKGrVqVmoASKbeg9hW	111111111111	\N
1	anom	anom@gmail.com	$2b$10$shziSMy/YdZpTmfRWTVgVeEj6lI9iwVqWO65yWuuuIJ85RVlb63Le	08970449852	1779628874866-872f169a-8ddb-4e01-b8e8-0a9a8094b0421551573987558399080.jpg
6	anomayu	anomayu@gmail.com	$2b$10$NJrEuKXxybFCTVW9k7/eP.sT07paLL4XmYbm8L1kYT2OAtaSlKkJS	111111111	\N
\.


--
-- TOC entry 3853 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anom
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- TOC entry 3697 (class 2606 OID 16413)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: anom
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


-- Completed on 2026-05-24 22:21:21 WIB

--
-- PostgreSQL database dump complete
--

\unrestrict xXbvmNzGz6LLCcRgJ9ah7bDPfm0QeynGmpMQDaGCtconCmgm7IttK9N3tEjQ4lq

