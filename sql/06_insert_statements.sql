INSERT INTO analytics.dim_date (
    date_key,
    full_date,
    calendar_year,
    calendar_month,
    month_name,
    quarter_num
)
SELECT DISTINCT
    TO_CHAR(TO_DATE(TRIM(week_ending_date), 'YYYY-MM-DD'), 'YYYYMMDD')::INT AS date_key,
    TO_DATE(TRIM(week_ending_date), 'YYYY-MM-DD') AS full_date,
    EXTRACT(YEAR FROM TO_DATE(TRIM(week_ending_date), 'YYYY-MM-DD'))::INT,
    EXTRACT(MONTH FROM TO_DATE(TRIM(week_ending_date), 'YYYY-MM-DD'))::INT,
    TRIM(TO_CHAR(TO_DATE(TRIM(week_ending_date), 'YYYY-MM-DD'), 'Month'))::VARCHAR(20),
    EXTRACT(QUARTER FROM TO_DATE(TRIM(week_ending_date), 'YYYY-MM-DD'))::INT
FROM staging.stg_cdc_weekly_hospitalization
WHERE NULLIF(TRIM(week_ending_date), '') IS NOT NULL
ON CONFLICT (date_key) DO NOTHING;

INSERT INTO analytics.fact_weekly_hospitalization (
    region_key,
    date_key,
    avg_adm_all_covid_confirmed,
    pct_chg_avg_adm_all_covid_confirmed_per_100k,
    total_adm_all_covid_confirmed_past_7days,
    total_adm_all_covid_confirmed_past_7days_per_100k,
    sum_adm_all_covid_confirmed,
    avg_total_patients_hospitalized_covid_confirmed,
    avg_percent_inpatient_beds_occupied_covid_confirmed,
    abs_chg_avg_percent_inpatient_beds_occupied_covid_confirmed,
    avg_percent_staff_icu_beds_covid,
    abs_chg_avg_percent_staff_icu_beds_covid
)
SELECT
    r.region_key,
    d.date_key,
    NULLIF(REPLACE(TRIM(s.avg_adm_all_covid_confirmed), ',', ''), '')::NUMERIC(14,2),
    NULLIF(REPLACE(TRIM(s.pct_chg_avg_adm_all_covid_confirmed_per_100k), ',', ''), '')::NUMERIC(14,2),
    NULLIF(REPLACE(TRIM(s.total_adm_all_covid_confirmed_past_7days), ',', ''), '')::NUMERIC(14,2),
    NULLIF(REPLACE(TRIM(s.total_adm_all_covid_confirmed_past_7days_per_100k), ',', ''), '')::NUMERIC(14,2),
    NULLIF(REPLACE(TRIM(s.sum_adm_all_covid_confirmed), ',', ''), '')::NUMERIC(14,2),
    NULLIF(REPLACE(TRIM(s.avg_total_patients_hospitalized_covid_confirmed), ',', ''), '')::NUMERIC(14,2),
    NULLIF(REPLACE(TRIM(s.avg_percent_inpatient_beds_occupied_covid_confirmed), ',', ''), '')::NUMERIC(14,2),
    NULLIF(REPLACE(TRIM(s.abs_chg_avg_percent_inpatient_beds_occupied_covid_confirmed), ',', ''), '')::NUMERIC(14,2),
    NULLIF(REPLACE(TRIM(s.avg_percent_staff_icu_beds_covid), ',', ''), '')::NUMERIC(14,2),
    NULLIF(REPLACE(TRIM(s.abs_chg_avg_percent_staff_icu_beds_covid), ',', ''), '')::NUMERIC(14,2)
FROM staging.stg_cdc_weekly_hospitalization s
JOIN analytics.dim_region r
    ON TRIM(s.state) = r.region_name
JOIN analytics.dim_date d
    ON TO_DATE(TRIM(s.week_ending_date), 'YYYY-MM-DD') = d.full_date
ON CONFLICT (region_key, date_key) DO NOTHING;