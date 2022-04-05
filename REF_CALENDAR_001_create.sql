-- REF_CALENDAR_001_create.sql
----------------------------------------------------------

CREATE TABLE IF NOT EXISTS REF_CALENDAR_001 (
date TEXT UNIQUE NOT NULL,
date_int INT NOT NULL,
date_mmddyy_slash TEXT NOT NULL,
date_julian_day_number REAL NOT NULL,
date_epoc_seconds INT NOT NULL,
date_start_ISO8601 TEXT NOT NULL,
date_end_ISO8601 TEXT NOT NULL,
date_start_of_year TEXT NOT NULL,
date_end_of_year TEXT NOT NULL,
date_start_of_quarter TEXT NOT NULL,
date_end_of_quarter TEXT NOT NULL,
date_start_of_month TEXT NOT NULL,
date_end_of_month TEXT NOT NULL,
date_start_of_week_smtwtfs TEXT NOT NULL,
date_end_of_week_smtwtfs TEXT NOT NULL,
date_start_of_week_mtwtfss TEXT NOT NULL,
date_end_of_week_mtwtfss TEXT NOT NULL,
days_in_period_year TEXT NOT NULL,
days_in_period_quarter TEXT NOT NULL,
days_in_period_month TEXT NOT NULL,
days_in_period_week TEXT NOT NULL,
year TEXT NOT NULL,
year_quarter TEXT NOT NULL,
year_quarter_q TEXT NOT NULL,
quarter_number TEXT NOT NULL,
quarter_number_q TEXT NOT NULL,
year_month TEXT NOT NULL,
month_number TEXT NOT NULL,
month_name_long TEXT NOT NULL,
month_name_short TEXT NOT NULL,
year_week_of_year TEXT NOT NULL,
week_number TEXT NOT NULL,
year_day_of_year TEXT NOT NULL,
day_of_year_number TEXT NOT NULL,
day_of_week_smtwtfs TEXT NOT NULL,
day_of_week_mtwtfss TEXT NOT NULL,
weekday_name_long TEXT NOT NULL,
weekday_name_short TEXT NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_ref_calendar_001_date ON REF_CALENDAR_001 (date);

CREATE UNIQUE INDEX IF NOT EXISTS idx_ref_calendar_001_date_int ON REF_CALENDAR_001 (date_int);

INSERT OR IGNORE INTO REF_CALENDAR_001 (
date,
date_int,
date_mmddyy_slash,
date_julian_day_number,
date_epoc_seconds,
date_start_ISO8601,
date_end_ISO8601,
date_start_of_year,
date_end_of_year,
date_start_of_quarter,
date_end_of_quarter,
date_start_of_month,
date_end_of_month,
date_start_of_week_smtwtfs,
date_end_of_week_smtwtfs,
date_start_of_week_mtwtfss,
date_end_of_week_mtwtfss,
days_in_period_year,
days_in_period_quarter,
days_in_period_month,
days_in_period_week,
year,
year_quarter,
year_quarter_q,
quarter_number,
quarter_number_q,
year_month,
month_number,
month_name_long,
month_name_short,
year_week_of_year,
week_number,
year_day_of_year,
day_of_year_number,
day_of_week_smtwtfs,
day_of_week_mtwtfss,
weekday_name_long,
weekday_name_short
)
SELECT *
FROM (
  WITH RECURSIVE dates(d) AS (
    VALUES('2019-01-01')
    UNION ALL
    SELECT date(d, '+1 day')
    FROM dates
    WHERE d < '2025-01-01'
  )
  SELECT   
    ---- typical date keys ----    
    d AS date, 
    CAST(strftime('%Y%m%d', d) AS INT) AS date_int,
    strftime('%m/%d/%Y', d) AS date_mmddyy_slash, 
    strftime('%J', d) AS date_julian_day_number, 
    strftime('%s', d) AS date_epoc_seconds,    
    ---- ISO8601 date ----   
    strftime('%Y-%m-%dT%H:%M:%S', d) AS date_start_ISO8601,
    strftime('%Y-%m-%dT%H:%M:%S', d, '+1 day', '-1 second') AS date_end_ISO8601, 
    ---- start of period and end of period dates ----     
    date(d, 'start of year') AS date_start_of_year,
    date(d, 'start of year','+1 year', '-1 day') AS date_end_of_year,
    CASE
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 1 AND 3 THEN date(d, 'start of year')
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 4 AND 6 THEN date(d, 'start of year','+3 month')
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 7 AND 9 THEN date(d, 'start of year','+6 month')
      ELSE date(d, 'start of year','+9 month')
    END AS date_start_of_quarter, 
    CASE
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 1 AND 3 THEN date(d, 'start of year','+3 month', '-1 day')
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 4 AND 6 THEN date(d, 'start of year','+6 month', '-1 day')
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 7 AND 9 THEN date(d, 'start of year','+9 month', '-1 day')
      ELSE date(d, 'start of year','+12 month', '-1 day')
    END AS date_end_of_quarter,
    date(d, 'start of month') AS date_start_of_month,
    date(d, 'start of month','+1 month', '-1 day') AS date_end_of_month, 
    date(d, 'weekday 0', '-7 days') AS date_start_of_week_smtwtfs,
    date(d, 'weekday 0', '-1 days') AS date_end_of_week_smtwtfs,
    date(d, 'weekday 0', '-6 days') AS date_start_of_week_mtwtfss,
    date(d, 'weekday 0') AS date_end_of_week_mtwtfss,
	---- days in period ----
	JULIANDAY(date(d, 'start of year','+1 year')) - JULIANDAY(date(d, 'start of year')) AS days_in_period_year, 
	JULIANDAY(CASE
		WHEN CAST(strftime('%m', d) AS INT) BETWEEN 1 AND 3 THEN date(d, 'start of year','+3 month')
		WHEN CAST(strftime('%m', d) AS INT) BETWEEN 4 AND 6 THEN date(d, 'start of year','+6 month')
		WHEN CAST(strftime('%m', d) AS INT) BETWEEN 7 AND 9 THEN date(d, 'start of year','+9 month')
		ELSE date(d, 'start of year','+12 month')
		END) - 
		JULIANDAY(CASE
			WHEN CAST(strftime('%m', d) AS INT) BETWEEN 1 AND 3 THEN date(d, 'start of year')
			WHEN CAST(strftime('%m', d) AS INT) BETWEEN 4 AND 6 THEN date(d, 'start of year','+3 month')
			WHEN CAST(strftime('%m', d) AS INT) BETWEEN 7 AND 9 THEN date(d, 'start of year','+6 month')
			ELSE date(d, 'start of year','+9 month')
		END) AS days_in_period_quarter,
	JULIANDAY(date(d, 'start of month','+1 month')) - JULIANDAY(date(d, 'start of month')) AS days_in_period_month,
	JULIANDAY(date(d, 'weekday 0')) - JULIANDAY(date(d, 'weekday 0', '-7 days')) AS days_in_period_week, 
	---- year ----     
    strftime('%Y', d) AS year, 
    ---- quarters ----     
    CASE
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 1 AND 3 THEN strftime('%Y', d)||'-01'
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 4 AND 6 THEN strftime('%Y', d)||'-02'
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 7 AND 9 THEN strftime('%Y', d)||'-03'
      ELSE strftime('%Y', d)||'-04'
    END AS year_quarter,
    CASE
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 1 AND 3 THEN strftime('%Y', d)||'-Q1'
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 4 AND 6 THEN strftime('%Y', d)||'-Q2'
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 7 AND 9 THEN strftime('%Y', d)||'-Q3'
    ELSE strftime('%Y', d)||'-Q4'
    END AS year_quarter_q,
    CASE
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 1 AND 3 THEN '01'
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 4 AND 6 THEN '02'
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 7 AND 9 THEN '03'
      ELSE '04'
    END AS quarter_number,      
    CASE
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 1 AND 3 THEN 'Q1'
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 4 AND 6 THEN 'Q2'
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 7 AND 9 THEN 'Q3'
      ELSE 'Q4'
    END AS quarter_number_q,      
    ---- months ----  
    strftime('%Y-%m', d) AS year_month, 
    strftime('%m', d) AS month_number, 
        CASE
      (CAST(strftime('%m', d) AS INT))
      WHEN 1 THEN 'January'
      WHEN 2 THEN 'February'
      WHEN 3 THEN 'March'
      WHEN 4 THEN 'April'
      WHEN 5 THEN 'May'
      WHEN 6 THEN 'June'
      WHEN 7 THEN 'July'
      WHEN 8 THEN 'August'
      WHEN 9 THEN 'September'
      WHEN 10 THEN 'October'
      WHEN 11 THEN 'November' 
      WHEN 12 THEN 'November' 
      ELSE 'error'
    END AS month_name_long,
    CASE
      (CAST(strftime('%m', d) AS INT))
      WHEN 1 THEN 'JAN'
      WHEN 2 THEN 'FEB'
      WHEN 3 THEN 'MAR'
      WHEN 4 THEN 'APR'
      WHEN 5 THEN 'MAY'
      WHEN 6 THEN 'JUN'
      WHEN 7 THEN 'JUL'
      WHEN 8 THEN 'AUG'
      WHEN 9 THEN 'SEP'
      WHEN 10 THEN 'OCT'
      WHEN 11 THEN 'NOV' 
      WHEN 12 THEN 'DEC' 
      ELSE 'error'
    END AS month_name_short,           
    ---- weeks ----
    strftime('%Y-%W', d) AS year_week_of_year,
    strftime('%W', d) AS week_number,      
    ---- days ----  
    strftime('%Y-%j', d) AS year_day_of_year,  
    strftime('%j', d) AS day_of_year_number,  
    printf('%02d',strftime('%w', d)) AS day_of_week_smtwtfs,  
    printf('%02d',strftime('%w', d, '-1 day')) AS day_of_week_mtwtfss,
    CASE
      (CAST(strftime('%w', d) AS INT))
      WHEN 0 THEN 'Sunday'
      WHEN 1 THEN 'Monday'
      WHEN 2 THEN 'Tuesday'
      WHEN 3 THEN 'Wednesday'
      WHEN 4 THEN 'Thursday'
      WHEN 5 THEN 'Friday'
      WHEN 6 THEN 'Saturday'
      ELSE 'error'
    END AS weekday_name_long,
    CASE
      (CAST(strftime('%w', d) AS INT))
      WHEN 0 THEN 'SUN'
      WHEN 1 THEN 'MON'
      WHEN 2 THEN 'TUE'
      WHEN 3 THEN 'WED'
      WHEN 4 THEN 'THU'
      WHEN 5 THEN 'FRI'
      WHEN 6 THEN 'SAT'
      ELSE 'error'
    END AS weekday_name_short      
  FROM dates
);