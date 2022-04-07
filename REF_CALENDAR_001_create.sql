-- REF_CALENDAR_001_create.sql
----------------------------------------------------------
CREATE TABLE IF NOT EXISTS REF_CALENDAR_001 (
date TEXT UNIQUE NOT NULL,
date_int INTEGER NOT NULL,
date_julian_day_number REAL NOT NULL,
date_end_of_year TEXT NOT NULL,
date_end_of_month TEXT NOT NULL,
date_end_of_week_smtwtfs TEXT NOT NULL,
days_in_period_month INTEGER NOT NULL,
days_in_period_week INTEGER NOT NULL,
year TEXT NOT NULL,
year_month TEXT NOT NULL,
year_week_of_year TEXT NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_ref_calendar_001_date ON REF_CALENDAR_001 (date);
CREATE UNIQUE INDEX IF NOT EXISTS idx_ref_calendar_001_date_int ON REF_CALENDAR_001 (date_int);
INSERT OR IGNORE INTO REF_CALENDAR_001 (
date,
date_int,
date_julian_day_number,
date_end_of_year,
date_end_of_month,
date_end_of_week_smtwtfs,
days_in_period_month,
days_in_period_week,
year,
year_month,
year_week_of_year)
SELECT *
FROM (
WITH RECURSIVE dates(d) AS (
VALUES('2020-01-01')
UNION ALL
SELECT date(d, '+1 day')
FROM dates
WHERE d < '2024-01-01')
SELECT 
d AS date, 
CAST(strftime('%Y%m%d', d) AS INT) AS date_int,
strftime('%J', d) AS date_julian_day_number, 
date(d, 'start of year','+1 year', '-1 day') AS date_end_of_year,
date(d, 'start of month','+1 month', '-1 day') AS date_end_of_month, 
date(d, 'weekday 0', '-1 days') AS date_end_of_week_smtwtfs,
JULIANDAY(date(d, 'start of month','+1 month')) - JULIANDAY(date(d, 'start of month')) AS days_in_period_month,
JULIANDAY(date(d, 'weekday 0')) - JULIANDAY(date(d, 'weekday 0', '-7 days')) AS days_in_period_week, 
strftime('%Y', d) AS year, 
strftime('%Y-%m', d) AS year_month, 
strftime('%Y-%W', d) AS year_week_of_year
FROM dates);
