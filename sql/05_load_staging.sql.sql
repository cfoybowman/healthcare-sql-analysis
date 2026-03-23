-- =========================================================
-- File: 05_load_staging.sql
-- Project: Healthcare Provider Services SQL Analysis
-- Author: Christina Foy-Bowman
-- Purpose: Load raw CDC CSV data into the staging table.
-- Notes: Update the file path before running.
-- =========================================================

COPY staging.stg_cdc_weekly_hospitalization
FROM 'C:/Users/Public/cdc_weekly_hospitalization_raw.csv.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    NULL ''
);

-- Validation check
SELECT COUNT(*) AS staging_row_count
FROM staging.stg_cdc_weekly_hospitalization;