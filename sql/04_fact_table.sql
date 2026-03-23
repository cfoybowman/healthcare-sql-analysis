-- =========================================================
-- File: 04_fact_table.sql
-- Project: Healthcare Provider Services SQL Analysis
-- Author: Christina Foy-Bowman
-- Purpose: Create fact table containing weekly hospitalization metrics.
-- Notes: Grain = one row per region per week ending date.
-- =========================================================

DROP TABLE IF EXISTS analytics.fact_weekly_hospitalization;

CREATE TABLE analytics.fact_weekly_hospitalization (
    fact_id BIGSERIAL PRIMARY KEY,
    region_key INT NOT NULL REFERENCES analytics.dim_region(region_key),
    date_key INT NOT NULL REFERENCES analytics.dim_date(date_key),

    avg_adm_all_covid_confirmed NUMERIC(14,2),
    pct_chg_avg_adm_all_covid_confirmed_per_100k NUMERIC(14,2),
    total_adm_all_covid_confirmed_past_7days NUMERIC(14,2),
    total_adm_all_covid_confirmed_past_7days_per_100k NUMERIC(14,2),
    sum_adm_all_covid_confirmed NUMERIC(14,2),
    avg_total_patients_hospitalized_covid_confirmed NUMERIC(14,2),
    avg_percent_inpatient_beds_occupied_covid_confirmed NUMERIC(14,2),
    abs_chg_avg_percent_inpatient_beds_occupied_covid_confirmed NUMERIC(14,2),
    avg_percent_staff_icu_beds_covid NUMERIC(14,2),
    abs_chg_avg_percent_staff_icu_beds_covid NUMERIC(14,2),

    CONSTRAINT uq_fact_region_date UNIQUE (region_key, date_key)
);