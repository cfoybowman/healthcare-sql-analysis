-- =========================================================
-- File: 02_staging_tables.sql
-- Project: Healthcare Provider Services SQL Analysis
-- Author: Christina Foy-Bowman
-- Purpose: Create raw staging table for CDC weekly hospitalization data.
-- Notes: All fields stored as TEXT for flexible ingestion and cleaning.
-- =========================================================

DROP TABLE IF EXISTS staging.stg_cdc_weekly_hospitalization;

CREATE TABLE staging.stg_cdc_weekly_hospitalization (
    week_ending_date TEXT,
    state TEXT,
    avg_adm_all_covid_confirmed TEXT,
    pct_chg_avg_adm_all_covid_confirmed_per_100k TEXT,
    total_adm_all_covid_confirmed_past_7days TEXT,
    total_adm_all_covid_confirmed_past_7days_per_100k TEXT,
    sum_adm_all_covid_confirmed TEXT,
    avg_total_patients_hospitalized_covid_confirmed TEXT,
    avg_percent_inpatient_beds_occupied_covid_confirmed TEXT,
    abs_chg_avg_percent_inpatient_beds_occupied_covid_confirmed TEXT,
    avg_percent_staff_icu_beds_covid TEXT,
    abs_chg_avg_percent_staff_icu_beds_covid TEXT
);