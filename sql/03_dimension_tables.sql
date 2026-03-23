-- =========================================================
-- File: 03_dimension_tables.sql
-- Project: Healthcare Provider Services SQL Analysis
-- Author: Christina Foy-Bowman
-- Purpose: Create and populate dimension tables for region and date.
-- Notes: Region values align to the source file's Region 1-10 and
--        United States labels.
-- =========================================================

DROP TABLE IF EXISTS analytics.dim_region CASCADE;

CREATE TABLE analytics.dim_region (
    region_key SERIAL PRIMARY KEY,
    region_name VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO analytics.dim_region (region_name) VALUES
('Region 1'),
('Region 2'),
('Region 3'),
('Region 4'),
('Region 5'),
('Region 6'),
('Region 7'),
('Region 8'),
('Region 9'),
('Region 10'),
('United States');

DROP TABLE IF EXISTS analytics.dim_date CASCADE;

CREATE TABLE analytics.dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    calendar_year INT NOT NULL,
    calendar_month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter_num INT NOT NULL
);