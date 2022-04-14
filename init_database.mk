# ~/Documents/GitHub/makefile_analytics_project/config/make/init_database.mk
############################################################################
# Database initiation                                                      #
############################################################################
init-database: test-database test-REF_CALENDAR_001 test-META_TABLES_001

############################################################################
# Tests                                                                    #
############################################################################
check-database: test-database test-database_schema.png test-database_schema.er \
test-REF_CALENDAR_001 test-META_TABLES_001	

test-database: create-database
	$(test-database)

test-REF_CALENDAR_001: TABLENAME = REF_CALENDAR_001
test-REF_CALENDAR_001: create-REF_CALENDAR_001 config/sql_ddl/REF_CALENDAR_001_create.sql
	$(test-table)

test-META_TABLES_001: TABLENAME = META_TABLES_001
test-META_TABLES_001: META_TABLES_001
	$(test-table)


############################################################################
# Create database                                                      #
############################################################################
create-database: 
	$(create-database)

############################################################################
# Create initial tables                                                    #
############################################################################
# Create the default project database 
init-tables: metric-REF_CALENDAR_001 META_TABLES_001 check-database

# Create database reference tables 
create-REF_CALENDAR_001: REF_CALENDAR_001_create.sql 
	$(execute-sql)

metric-REF_CALENDAR_001: TABLENAME=REF_CALENDAR_001
metric-REF_CALENDAR_001: test-REF_CALENDAR_001
	$(record-count-table)

############################################################################
# Data seeds and queries                                                   #
############################################################################
config/sql_ddl/REF_CALENDAR_001_create.sql: .FORCE
	@echo "-- REF_CALENDAR_001_create.sql" > $@
	@echo "----------------------------------------------------------" >> $@
	@echo "CREATE TABLE IF NOT EXISTS REF_CALENDAR_001 (" >> $@
	@echo "date TEXT UNIQUE NOT NULL," >> $@
	@echo "date_int INTEGER NOT NULL," >> $@
	@echo "date_julian_day_number REAL NOT NULL," >> $@
	@echo "date_end_of_year TEXT NOT NULL," >> $@
	@echo "date_end_of_month TEXT NOT NULL," >> $@
	@echo "date_end_of_week_smtwtfs TEXT NOT NULL," >> $@
	@echo "days_in_period_month INTEGER NOT NULL," >> $@
	@echo "days_in_period_week INTEGER NOT NULL," >> $@
	@echo "year TEXT NOT NULL," >> $@
	@echo "year_month TEXT NOT NULL," >> $@
	@echo "year_week_of_year TEXT NOT NULL" >> $@
	@echo ");" >> $@
	@echo "CREATE UNIQUE INDEX IF NOT EXISTS idx_ref_calendar_001_date ON REF_CALENDAR_001 (date);" >> $@
	@echo "CREATE UNIQUE INDEX IF NOT EXISTS idx_ref_calendar_001_date_int ON REF_CALENDAR_001 (date_int);" >> $@
	@echo "INSERT OR IGNORE INTO REF_CALENDAR_001 (" >> $@
	@echo "date," >> $@
	@echo "date_int," >> $@
	@echo "date_julian_day_number," >> $@
	@echo "date_end_of_year," >> $@
	@echo "date_end_of_month," >> $@
	@echo "date_end_of_week_smtwtfs," >> $@
	@echo "days_in_period_month," >> $@
	@echo "days_in_period_week," >> $@
	@echo "year," >> $@
	@echo "year_month," >> $@
	@echo "year_week_of_year)" >> $@
	@echo "SELECT *" >> $@
	@echo "FROM (" >> $@
	@echo "WITH RECURSIVE dates(d) AS (" >> $@
	@echo "VALUES('2020-01-01')" >> $@
	@echo "UNION ALL" >> $@
	@echo "SELECT date(d, '+1 day')" >> $@
	@echo "FROM dates" >> $@
	@echo "WHERE d < '2024-01-01')" >> $@
	@echo "SELECT " >> $@  
	@echo "d AS date, " >> $@
	@echo "CAST(strftime('%Y%m%d', d) AS INT) AS date_int," >> $@
	@echo "strftime('%J', d) AS date_julian_day_number, " >> $@
	@echo "date(d, 'start of year','+1 year', '-1 day') AS date_end_of_year," >> $@
	@echo "date(d, 'start of month','+1 month', '-1 day') AS date_end_of_month, " >> $@
	@echo "date(d, 'weekday 0', '-1 days') AS date_end_of_week_smtwtfs," >> $@
	@echo "JULIANDAY(date(d, 'start of month','+1 month')) - JULIANDAY(date(d, 'start of month')) AS days_in_period_month," >> $@
	@echo "JULIANDAY(date(d, 'weekday 0')) - JULIANDAY(date(d, 'weekday 0', '-7 days')) AS days_in_period_week, " >> $@
	@echo "strftime('%Y', d) AS year, " >> $@
	@echo "strftime('%Y-%m', d) AS year_month, " >> $@
	@echo "strftime('%Y-%W', d) AS year_week_of_year" >> $@
	@echo "FROM dates);" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

config/sql_ddl/er_relationships.txt: 
	@echo "REF_CALENDAR_001 1--1 REF_CALENDAR_001" > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

############################################################################
# Create standard load files                                               #
############################################################################

build/load/metric/metric_sample_001.csv: 
	@echo provider_code,node_code,node_qualifier,metric_code,value_dts,metric_value > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)


############################################################################
# Uninstall                                                                #
############################################################################
uninstall-database: FILES=*.db *.db-* database_schema.* er_relationships.txt *.er config/sql_ddl/REF_CALENDAR_001_create.sql
uninstall-database: 
	$(uninstall-file-list)	