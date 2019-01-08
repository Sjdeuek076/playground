--
-- PostgreSQL database dump
--

-- Dumped from database version 10.6
-- Dumped by pg_dump version 10.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: matview; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA matview;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: classify_in_quota(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.classify_in_quota() RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
-- Source of Stock code allocation plan: 
-- https://www.hkex.com.hk/-/media/HKEX-Market/Products/Securities/Stock-Code-Allocation-Plan/scap.pdf
insert into warrants_d select * from stock_d where cast (code as INTEGER)  between 10000 and 29999 ; -- warrants  10000-29999  HKD 
insert into warrants_d select * from stock_d where cast (code as INTEGER)  between 89000 and 89999 ; -- warrants  89000-89999  CNY
insert into cbbc_d select * from stock_d where cast (code as INTEGER) between 57000 and 69999 ; -- CBBC  57000-69999 HKD
insert into etf_d select * from stock_d where cast (code as INTEGER) between 82800 and 82849 ; -- ETF 82800-82849 CNY
insert into etf_d select * from stock_d where cast (code as INTEGER) between 83000 and 83199 ; -- ETF 83000-83199 CNY
RAISE NOTICE 'finish classify';

delete from stock_d where cast (code as INTEGER)  between 10000 and 29999 ; -- warrants  10000-29999  HKD 
delete from stock_d where cast (code as INTEGER)  between 89000 and 89999 ; -- warrants  89000-89999  CNY
delete from stock_d where cast (code as INTEGER) between 57000 and 69999 ; -- CBBC  57000-69999 HKD
delete from stock_d where cast (code as INTEGER) between 82800 and 82849 ; -- ETF 82800-82849 CNY
delete from stock_d where cast (code as INTEGER) between 83000 and 83199 ; -- ETF 83000-83199 CNY
RAISE NOTICE 'finish clean up';

refresh materialized view matview.derivatives;
RAISE NOTICE 'finish refresh matview.derivatives';
refresh materialized view matview.turnover;
RAISE NOTICE 'finish refresh matview.turnover';
end;
 $$;


--
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.modified_D = now();
    RETURN NEW;	
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: futures_n_option_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.futures_n_option_contract (
    tdate date,
    f_contract_volume integer,
    f_open_interest integer,
    o_contract_volume integer,
    o_open_interest integer,
    fo_contract_volume integer,
    fo_open_interest integer,
    modified_d timestamp without time zone
);


--
-- Name: hsi_future_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hsi_future_contract (
    tdate date,
    spot_month integer,
    second_month integer,
    contract_volume integer,
    open_interest integer,
    modified_d timestamp without time zone
);


--
-- Name: hsi_option_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hsi_option_contract (
    tdate date,
    call_contract_volume integer,
    put_contract_volume integer,
    total_contract_volume integer,
    call_open_interest integer,
    put_open_interest integer,
    total_open_interest integer,
    modified_d timestamp without time zone
);


--
-- Name: hsi_vix_future_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hsi_vix_future_contract (
    tdate date,
    spot_month real,
    second_month real,
    contract_volume integer,
    open_interest integer,
    modified_d timestamp without time zone
);


--
-- Name: mini_hsi_future_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mini_hsi_future_contract (
    tdate date,
    spot_month integer,
    second_month integer,
    contract_volume integer,
    open_interest integer,
    modified_d timestamp without time zone
);


--
-- Name: mini_hsi_option_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mini_hsi_option_contract (
    tdate date,
    call_contract_volume integer,
    put_contract_volume integer,
    total_contract_volume integer,
    call_open_interest integer,
    put_open_interest integer,
    total_open_interest integer,
    modified_d timestamp without time zone
);


--
-- Name: rmb_future_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rmb_future_contract (
    tdate date,
    spot_month real,
    second_month real,
    contract_volume integer,
    open_interest integer,
    modified_d timestamp without time zone
);


--
-- Name: stock_future_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_future_contract (
    tdate date,
    contract_volume integer,
    open_interest integer,
    modified_d timestamp without time zone
);


--
-- Name: stock_option_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_option_contract (
    tdate date,
    call_contract_volume integer,
    put_contract_volume integer,
    total_contract_volume integer,
    call_open_interest integer,
    put_open_interest integer,
    total_open_interest integer,
    modified_d timestamp without time zone
);


--
-- Name: derivatives; Type: MATERIALIZED VIEW; Schema: matview; Owner: -
--

CREATE MATERIALIZED VIEW matview.derivatives AS
 SELECT fo.tdate,
    fo.f_contract_volume AS fofcv,
    fo.f_open_interest AS fofoi,
    fo.o_contract_volume AS foocv,
    fo.o_open_interest AS foooi,
    fo.fo_contract_volume AS foallcv,
    fo.fo_open_interest AS foalloi,
    hf.spot_month AS hfsptm,
    hf.second_month AS hfsecm,
    hf.contract_volume AS hfcv,
    hf.open_interest AS hfoi,
    hvf.spot_month AS hvfsptm,
    hvf.second_month AS hvfsecm,
    hvf.contract_volume AS hvfcv,
    hvf.open_interest AS hvfoi,
    mhf.spot_month AS mhfsptm,
    mhf.second_month AS mhfsecm,
    mhf.contract_volume AS mhfcv,
    mhf.open_interest AS mhfoi,
    rf.spot_month AS rfsptm,
    rf.second_month AS rfsecm,
    rf.contract_volume AS rfcv,
    rf.open_interest AS rfoi,
    sf.contract_volume AS sfcv,
    sf.open_interest AS sfoi,
    ho.call_contract_volume AS hoccv,
    ho.put_contract_volume AS hopcv,
    ho.total_contract_volume AS hottlcv,
    ho.call_open_interest AS hocoi,
    ho.put_open_interest AS hopoi,
    ho.total_open_interest AS hottloi,
    mho.call_contract_volume AS mhoccv,
    mho.put_contract_volume AS mhopcv,
    mho.total_contract_volume AS mhottlcv,
    mho.call_open_interest AS mhocoi,
    mho.put_open_interest AS mhopoi,
    mho.total_open_interest AS mhottloi,
    so.call_contract_volume AS soccv,
    so.put_contract_volume AS sopcv,
    so.total_contract_volume AS sottlcv,
    so.call_open_interest AS socoi,
    so.put_open_interest AS sopoi,
    so.total_open_interest AS sottloi
   FROM ((((((((public.futures_n_option_contract fo
     LEFT JOIN public.hsi_future_contract hf USING (tdate))
     LEFT JOIN public.hsi_vix_future_contract hvf USING (tdate))
     LEFT JOIN public.mini_hsi_future_contract mhf USING (tdate))
     LEFT JOIN public.rmb_future_contract rf USING (tdate))
     LEFT JOIN public.stock_future_contract sf USING (tdate))
     LEFT JOIN public.hsi_option_contract ho USING (tdate))
     LEFT JOIN public.mini_hsi_option_contract mho USING (tdate))
     LEFT JOIN public.stock_option_contract so USING (tdate))
  WITH NO DATA;


--
-- Name: cbbc_d; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cbbc_d (
    code character varying(5),
    pre_close real,
    ask real,
    high real,
    shares double precision,
    close real,
    bid real,
    low real,
    turnover double precision,
    tdate date
);


--
-- Name: etf_d; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.etf_d (
    code character varying(5),
    pre_close real,
    ask real,
    high real,
    shares double precision,
    close real,
    bid real,
    low real,
    turnover double precision,
    tdate date
);


--
-- Name: stock_d; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_d (
    code character varying(5),
    pre_close real DEFAULT 0,
    ask real DEFAULT 0,
    high real DEFAULT 0,
    shares double precision DEFAULT 0,
    close real DEFAULT 0,
    bid real DEFAULT 0,
    low real DEFAULT 0,
    turnover double precision DEFAULT 0,
    tdate date
);


--
-- Name: stock_shortput; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_shortput (
    stockno character varying(5),
    qty double precision,
    amount double precision,
    unit_price real,
    trade_date date,
    short_qty double precision,
    short_amount double precision
);


--
-- Name: warrants_d; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.warrants_d (
    code character varying(5),
    pre_close real,
    ask real,
    high real,
    shares double precision,
    close real,
    bid real,
    low real,
    turnover double precision,
    tdate date
);


--
-- Name: turnover; Type: MATERIALIZED VIEW; Schema: matview; Owner: -
--

CREATE MATERIALIZED VIEW matview.turnover AS
 SELECT sp.trade_date AS tdate,
    sum(sp.short_qty) AS sp_shares,
    sum(sp.short_amount) AS sp_turnover,
    'shortputs'::text AS c_type
   FROM public.stock_shortput sp
  GROUP BY sp.trade_date
UNION
 SELECT cb.tdate,
    sum(cb.shares) AS sp_shares,
    sum(cb.turnover) AS sp_turnover,
    'cbbcs'::text AS c_type
   FROM public.cbbc_d cb
  GROUP BY cb.tdate
UNION
 SELECT etf.tdate,
    sum(etf.shares) AS sp_shares,
    sum(etf.turnover) AS sp_turnover,
    'etfs'::text AS c_type
   FROM public.etf_d etf
  GROUP BY etf.tdate
UNION
 SELECT warr.tdate,
    sum(warr.shares) AS sp_shares,
    sum(warr.turnover) AS sp_turnover,
    'warrants'::text AS c_type
   FROM public.warrants_d warr
  GROUP BY warr.tdate
UNION
 SELECT std.tdate,
    sum(std.shares) AS sp_shares,
    sum(std.turnover) AS sp_turnover,
    'stocks'::text AS c_type
   FROM public.stock_d std
  GROUP BY std.tdate
  ORDER BY 4
  WITH NO DATA;


--
-- Name: cbbc_h; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cbbc_h (
    code character varying(5),
    name_of_list_securities character varying(100),
    board_lot integer,
    expiry_date date,
    remark character varying(10),
    modified_date date
);


--
-- Name: etf_h; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.etf_h (
    code character varying(5),
    name_of_list_securities character varying(100),
    board_lot integer,
    fund_manager character varying(100),
    remark character varying(10),
    modified_date date
);


--
-- Name: hsi_future_price_d; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hsi_future_price_d (
    contract_month character varying(10),
    prev_ah_opening_price real,
    prev_ah_daily_high real,
    prev_ah_daily_low real,
    prev_ah_close_price real,
    prev_ah_volume integer,
    ds_opening_price real,
    ds_daily_high real,
    ds_daily_low real,
    ds_volume integer,
    ds_settlement_price real,
    ds_change_in_settlement_price real,
    combined_contract_high integer,
    combined_contract_low integer,
    combined_volume integer,
    combined_open_interest integer,
    combined_change_in_oi integer,
    tdate date
);


--
-- Name: hsi_option_price_d; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hsi_option_price_d (
    contract_month character varying(10),
    strike_price integer,
    contract_type character(1),
    prev_ah_opening_price real,
    prev_ah_daily_high real,
    prev_ah_daily_low real,
    prev_ah_close_price real,
    prev_ah_volume integer,
    ds_opening_price real,
    ds_daily_high real,
    ds_daily_low real,
    ds_oqp_close real,
    ds_oqp_change real,
    ds_iv real,
    ds_volume integer,
    combined_contract_high integer,
    combined_contract_low integer,
    combined_volume integer,
    combined_open_interest integer,
    combined_change_in_oi integer,
    tdate date
);


--
-- Name: stock_future_price_d; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_future_price_d (
    code character varying(5),
    contract_month character varying(10),
    opening_price real,
    daily_high real,
    daily_low real,
    settlement_price real,
    change_in_settlement_price real,
    volume integer,
    open_interst integer,
    change_in_oi integer,
    tdate date
);


--
-- Name: stock_h; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_h (
    code character varying(5),
    name character varying(100),
    board_lot integer,
    remark character varying(10),
    issue bigint,
    faf real,
    cf real,
    spread real,
    weight real,
    sensitivity_factor real,
    modified_date date
);


--
-- Name: stock_option_price_d; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_option_price_d (
    code character varying(5),
    underly_stock_close_price real,
    contract_month character varying(10),
    strike_price real,
    contract_type character(1),
    opening_price real,
    daily_hight real,
    daily_low real,
    settlement_price real,
    change_in_setlment_price real,
    iv real,
    volume integer,
    open_interest integer,
    change_in_oi integer,
    tdate date
);


--
-- Name: stock_option_price_sum; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_option_price_sum (
    code character varying(5),
    call_volume integer,
    put_volume integer,
    total_volume integer,
    call_open_interest integer,
    put_open_interest integer,
    total_open_interest integer,
    iv real,
    tdate date
);


--
-- Name: testnegative; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.testnegative (
    id integer NOT NULL,
    name character varying NOT NULL,
    price numeric(5,2),
    change_in_price real
);


--
-- Name: testnegative_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.testnegative_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: testnegative_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.testnegative_id_seq OWNED BY public.testnegative.id;


--
-- Name: testtbl; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.testtbl (
    uid integer NOT NULL,
    username character varying(100) NOT NULL,
    departname character varying(500) NOT NULL,
    created date
);


--
-- Name: tmp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tmp (
    code character varying(5),
    pre_close real,
    ask real,
    high real,
    shares double precision,
    close real,
    bid real,
    low real,
    turnover double precision,
    tdate date
);


--
-- Name: userinfo_uid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.userinfo_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userinfo_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.userinfo_uid_seq OWNED BY public.testtbl.uid;


--
-- Name: vhsi; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vhsi (
    tdate date,
    close real DEFAULT 0,
    open real DEFAULT 0,
    high real DEFAULT 0,
    low real DEFAULT 0,
    volumn double precision DEFAULT 0,
    change character varying(10)
);


--
-- Name: warrants_h; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.warrants_h (
    code character varying(5),
    descname character varying(100),
    board_lot integer,
    expiry_date date,
    remark character varying(10),
    modified_date date
);


--
-- Name: testnegative id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.testnegative ALTER COLUMN id SET DEFAULT nextval('public.testnegative_id_seq'::regclass);


--
-- Name: testtbl uid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.testtbl ALTER COLUMN uid SET DEFAULT nextval('public.userinfo_uid_seq'::regclass);


--
-- Name: testnegative testnegative_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.testnegative
    ADD CONSTRAINT testnegative_pkey PRIMARY KEY (id);


--
-- Name: testtbl userinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.testtbl
    ADD CONSTRAINT userinfo_pkey PRIMARY KEY (uid);


--
-- Name: idxcbbcd; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxcbbcd ON public.cbbc_d USING btree (code, tdate);


--
-- Name: idxetfd; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxetfd ON public.etf_d USING btree (code, tdate);


--
-- Name: idxfuturesnoptions; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxfuturesnoptions ON public.futures_n_option_contract USING btree (tdate);


--
-- Name: idxhsifuturepriced; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxhsifuturepriced ON public.hsi_future_price_d USING btree (contract_month, tdate);


--
-- Name: idxhsifutures; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxhsifutures ON public.hsi_future_contract USING btree (tdate);


--
-- Name: idxhsioptionpriced; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxhsioptionpriced ON public.hsi_option_price_d USING btree (contract_month, strike_price, contract_type, tdate);


--
-- Name: idxhsioptions; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxhsioptions ON public.hsi_option_contract USING btree (tdate);


--
-- Name: idxhsivixfutures; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxhsivixfutures ON public.hsi_vix_future_contract USING btree (tdate);


--
-- Name: idxminihsifutures; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxminihsifutures ON public.mini_hsi_future_contract USING btree (tdate);


--
-- Name: idxminihsioptions; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxminihsioptions ON public.mini_hsi_option_contract USING btree (tdate);


--
-- Name: idxrmbfutures; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxrmbfutures ON public.rmb_future_contract USING btree (tdate);


--
-- Name: idxshortput; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxshortput ON public.stock_shortput USING btree (stockno, trade_date);


--
-- Name: idxstockd; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxstockd ON public.stock_d USING btree (code, tdate);


--
-- Name: idxstockfuturepriced; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxstockfuturepriced ON public.stock_future_price_d USING btree (code, contract_month, tdate);


--
-- Name: idxstockfutures; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxstockfutures ON public.stock_future_contract USING btree (tdate);


--
-- Name: idxstockoptionpriced; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxstockoptionpriced ON public.stock_option_price_d USING btree (code, contract_month, strike_price, contract_type, tdate);


--
-- Name: idxstockoptionpricesum; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxstockoptionpricesum ON public.stock_option_price_sum USING btree (code, tdate);


--
-- Name: idxstockoptions; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxstockoptions ON public.stock_option_contract USING btree (tdate);


--
-- Name: idxvhsi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxvhsi ON public.vhsi USING btree (tdate);


--
-- Name: idxwarrantsd; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idxwarrantsd ON public.warrants_d USING btree (code, tdate);


--
-- Name: futures_n_option_contract upd_fno; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER upd_fno BEFORE UPDATE ON public.futures_n_option_contract FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- Name: hsi_future_contract upd_hsif; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER upd_hsif BEFORE UPDATE ON public.hsi_future_contract FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- Name: hsi_option_contract upd_hsio; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER upd_hsio BEFORE UPDATE ON public.hsi_option_contract FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- Name: hsi_vix_future_contract upd_hvixf; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER upd_hvixf BEFORE UPDATE ON public.hsi_vix_future_contract FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- Name: mini_hsi_future_contract upd_mhsif; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER upd_mhsif BEFORE UPDATE ON public.mini_hsi_future_contract FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- Name: mini_hsi_option_contract upd_mhsio; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER upd_mhsio BEFORE UPDATE ON public.mini_hsi_option_contract FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- Name: rmb_future_contract upd_rmbf; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER upd_rmbf BEFORE UPDATE ON public.rmb_future_contract FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- Name: stock_future_contract upd_stockf; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER upd_stockf BEFORE UPDATE ON public.stock_future_contract FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- Name: stock_option_contract upd_stocko; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER upd_stocko BEFORE UPDATE ON public.stock_option_contract FOR EACH ROW EXECUTE PROCEDURE public.update_modified_column();


--
-- PostgreSQL database dump complete
--

