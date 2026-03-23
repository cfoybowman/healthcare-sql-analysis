-- =========================================================
-- File: 07_analysis_queries.sql
-- Project: Healthcare Provider Services SQL Analysis
-- Author: Christina Bowman
-- Purpose: Core analytical SQL queries demonstrating joins,
--          aggregations, CTEs, and window functions.
-- =========================================================


-- ---------------------------------------------------------
-- Query 1: Weekly Admissions Trend by Region
-- Business Question:
-- How did average confirmed COVID admissions change over time by region?
-- ---------------------------------------------------------
SELECT
    r.region_name,
    d.full_date AS week_ending_date,
    f.avg_adm_all_covid_confirmed
FROM analytics.fact_weekly_hospitalization f
JOIN analytics.dim_region r
    ON f.region_key = r.region_key
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
ORDER BY r.region_name, d.full_date;


-- ---------------------------------------------------------
-- Query 2: Total Admissions by Region
-- Business Question:
-- Which regions had the highest total confirmed admissions?
-- ---------------------------------------------------------
SELECT
    r.region_name,
    SUM(f.total_adm_all_covid_confirmed_past_7days) AS total_admissions
FROM analytics.fact_weekly_hospitalization f
JOIN analytics.dim_region r
    ON f.region_key = r.region_key
GROUP BY r.region_name
ORDER BY total_admissions DESC;


-- ---------------------------------------------------------
-- Query 3: Average ICU Burden by Region
-- Business Question:
-- Which regions experienced the highest ICU utilization rates?
-- ---------------------------------------------------------
SELECT
    r.region_name,
    ROUND(AVG(f.avg_percent_staff_icu_beds_covid), 2) AS avg_icu_burden_pct
FROM analytics.fact_weekly_hospitalization f
JOIN analytics.dim_region r
    ON f.region_key = r.region_key
GROUP BY r.region_name
ORDER BY avg_icu_burden_pct DESC;


-- ---------------------------------------------------------
-- Query 4: Average Inpatient Bed Occupancy by Region
-- Business Question:
-- Which regions had the highest inpatient bed occupancy?
-- ---------------------------------------------------------
SELECT
    r.region_name,
    ROUND(AVG(f.avg_percent_inpatient_beds_occupied_covid_confirmed), 2) AS avg_bed_occupancy_pct
FROM analytics.fact_weekly_hospitalization f
JOIN analytics.dim_region r
    ON f.region_key = r.region_key
GROUP BY r.region_name
ORDER BY avg_bed_occupancy_pct DESC;


-- ---------------------------------------------------------
-- Query 5: Peak Hospitalization Week by Region
-- Business Question:
-- When did each region experience peak hospitalizations?
-- ---------------------------------------------------------
WITH ranked_weeks AS (
    SELECT
        r.region_name,
        d.full_date,
        f.avg_total_patients_hospitalized_covid_confirmed,
        RANK() OVER (
            PARTITION BY r.region_name
            ORDER BY f.avg_total_patients_hospitalized_covid_confirmed DESC
        ) AS rnk
    FROM analytics.fact_weekly_hospitalization f
    JOIN analytics.dim_region r
        ON f.region_key = r.region_key
    JOIN analytics.dim_date d
        ON f.date_key = d.date_key
)
SELECT
    region_name,
    full_date AS peak_week,
    avg_total_patients_hospitalized_covid_confirmed
FROM ranked_weeks
WHERE rnk = 1
ORDER BY region_name;


-- ---------------------------------------------------------
-- Query 6: Monthly Admissions Trend
-- Business Question:
-- How did admissions trend on a monthly basis?
-- ---------------------------------------------------------
SELECT
    d.calendar_year,
    d.calendar_month,
    r.region_name,
    SUM(f.total_adm_all_covid_confirmed_past_7days) AS monthly_admissions
FROM analytics.fact_weekly_hospitalization f
JOIN analytics.dim_region r
    ON f.region_key = r.region_key
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
GROUP BY
    d.calendar_year,
    d.calendar_month,
    r.region_name
ORDER BY
    d.calendar_year,
    d.calendar_month,
    r.region_name;


-- ---------------------------------------------------------
-- Query 7: 4-Week Moving Average of Admissions
-- Business Question:
-- What is the smoothed 4-week trend in admissions?
-- ---------------------------------------------------------
SELECT
    r.region_name,
    d.full_date,
    f.avg_adm_all_covid_confirmed,
    ROUND(
        AVG(f.avg_adm_all_covid_confirmed) OVER (
            PARTITION BY r.region_name
            ORDER BY d.full_date
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_4_week
FROM analytics.fact_weekly_hospitalization f
JOIN analytics.dim_region r
    ON f.region_key = r.region_key
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
ORDER BY r.region_name, d.full_date;


-- ---------------------------------------------------------
-- Query 8: Week-over-Week Change in Admissions
-- Business Question:
-- How did admissions change week over week?
-- ---------------------------------------------------------
SELECT
    r.region_name,
    d.full_date,
    f.avg_adm_all_covid_confirmed,
    LAG(f.avg_adm_all_covid_confirmed) OVER (
        PARTITION BY r.region_name
        ORDER BY d.full_date
    ) AS prior_week,
    ROUND(
        f.avg_adm_all_covid_confirmed
        - LAG(f.avg_adm_all_covid_confirmed) OVER (
            PARTITION BY r.region_name
            ORDER BY d.full_date
        ),
        2
    ) AS wow_change
FROM analytics.fact_weekly_hospitalization f
JOIN analytics.dim_region r
    ON f.region_key = r.region_key
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
ORDER BY r.region_name, d.full_date;


-- ---------------------------------------------------------
-- Query 9: Region with Highest Average Bed Occupancy
-- Business Question:
-- Which region had the highest average hospital occupancy?
-- ---------------------------------------------------------
SELECT
    r.region_name,
    ROUND(AVG(f.avg_percent_inpatient_beds_occupied_covid_confirmed), 2) AS avg_bed_occupancy
FROM analytics.fact_weekly_hospitalization f
JOIN analytics.dim_region r
    ON f.region_key = r.region_key
GROUP BY r.region_name
ORDER BY avg_bed_occupancy DESC;


-- ---------------------------------------------------------
-- Query 10: Highest Stress Weeks Across Regions
-- Business Question:
-- Which weeks experienced the highest combined healthcare system strain?
-- ---------------------------------------------------------
WITH stress_scores AS (
    SELECT
        r.region_name,
        d.full_date,
        f.avg_percent_inpatient_beds_occupied_covid_confirmed,
        f.avg_percent_staff_icu_beds_covid,
        (
            COALESCE(f.avg_percent_inpatient_beds_occupied_covid_confirmed, 0)
            + COALESCE(f.avg_percent_staff_icu_beds_covid, 0)
        ) AS stress_score
    FROM analytics.fact_weekly_hospitalization f
    JOIN analytics.dim_region r
        ON f.region_key = r.region_key
    JOIN analytics.dim_date d
        ON f.date_key = d.date_key
)
SELECT
    region_name,
    full_date,
    avg_percent_inpatient_beds_occupied_covid_confirmed,
    avg_percent_staff_icu_beds_covid,
    stress_score
FROM stress_scores
ORDER BY stress_score DESC
LIMIT 15;