# 🏥 Healthcare Provider Services SQL Analysis

## 📌 Project Overview

This project analyzes U.S. healthcare system strain using CDC hospitalization data. The objective is to evaluate trends in COVID-19 admissions, ICU utilization, and inpatient bed occupancy across regions over time.

The project simulates a real-world analytics pipeline by implementing a structured data model with staging, dimension, and fact tables in PostgreSQL, followed by advanced SQL analysis using joins, aggregations, CTEs, and window functions.

---

## 🎯 Business Objectives

* Identify which regions experienced the highest healthcare system strain
* Analyze trends in hospital admissions over time
* Measure ICU and inpatient bed utilization levels
* Detect peak stress periods across the healthcare system
* Compare regional performance using standardized metrics

---

## 🗂️ Data Source

* CDC Weekly U.S. Hospitalization Metrics (Jurisdiction-Level)

---

## 🏗️ Data Architecture

This project follows a **star schema design**:

### 🔹 Staging Layer

* `stg_cdc_weekly_hospitalization`
* Raw CDC data stored as TEXT for flexible ingestion and transformation

### 🔹 Dimension Tables

* `dim_region` → Region classification (Region 1–10, United States)
* `dim_date` → Calendar attributes (year, month, quarter)

### 🔹 Fact Table

* `fact_weekly_hospitalization`
* Contains key metrics:

  * Admissions
  * ICU utilization
  * Bed occupancy
  * Weekly trends

---

## ⚙️ Key SQL Techniques Used

* Joins (fact-to-dimension relationships)
* Aggregations (SUM, AVG, GROUP BY)
* Common Table Expressions (CTEs)
* Window Functions (LAG, RANK, moving averages)
* Data Cleaning (NULL handling, string-to-numeric conversion)

---

# 📊 Featured Queries

Below are the core analytical queries used to evaluate healthcare system performance.

---

## 📈 1. Weekly Admissions Trend by Region

Tracks how COVID-19 hospital admissions change over time across regions, helping identify surges and declines.

---

## 🏥 2. Total Admissions by Region

Aggregates total confirmed admissions to compare overall healthcare burden across regions.

---

## 🧠 3. Average ICU Burden by Region

Measures ICU utilization rates to highlight regions experiencing sustained critical care pressure.

---

## 📊 4. Average Inpatient Bed Occupancy

Evaluates how full hospitals were on average, indicating system capacity constraints.

---

## ⚠️ 5. Peak Hospitalization Week by Region

Uses ranking (CTE + window function) to identify the highest hospitalization week per region.

---

## 📅 6. Monthly Admissions Trend

Rolls weekly data into monthly totals to analyze broader trends and reduce short-term volatility.

---

## 🔄 7. 4-Week Moving Average of Admissions

Applies a rolling average to smooth fluctuations and reveal underlying trends.

---

## 📉 8. Week-over-Week Change in Admissions

Uses `LAG()` to calculate weekly changes, helping detect rapid increases or declines.

---

## 🏆 9. Region with Highest Average Bed Occupancy

Identifies which regions consistently operated closest to capacity.

---

## 🔥 10. Highest Stress Weeks Across Regions

Creates a composite **stress score** using ICU utilization and bed occupancy to identify peak strain periods.

---

## 💡 Key Insights

* Regions experienced distinct waves of hospitalization rather than uniform trends
* ICU utilization and bed occupancy strongly correlate during peak periods
* Moving averages reveal sustained pressure rather than isolated spikes
* Peak stress periods can be identified using composite metrics and ranking logic

---

## 🚀 Tools & Technologies

* PostgreSQL
* SQL (CTEs, Window Functions, Aggregations)
* CDC Public Health Data

---

## 📁 Project Structure

```
healthcare-sql-analysis/
│
├── data/
│   └── cdc_weekly_hospitalization_raw.csv
│
├── sql/
│   ├── 01_create_schemas.sql
│   ├── 02_staging_tables.sql
│   ├── 03_dimension_tables.sql
│   ├── 04_fact_table.sql
│   ├── 05_load_staging.sql
│   ├── 06_transform_load_fact.sql
│   └── 07_analysis_queries.sql
│
├── .gitignore
└── README.md
```

---

## 💡 Why This Project Stands Out

This project demonstrates:

* End-to-end SQL pipeline development
* Real-world data modeling (fact + dimension design)
* Advanced analytical SQL techniques
* Business-focused insights from healthcare data

---

## 🔗 Future Enhancements

* Add state-level dataset for deeper geographic analysis
* Integrate population data for per-capita metrics
* Build interactive dashboard in Tableau or Power BI
* Automate data pipeline for scheduled updates

---
