# ~/Documents/GitHub/makefile_analytocs_project/makefile
#
# Setup a macOS computer with a base python analytics development environment.
#
# USE: Copy the contents of this directory into a new directory and run 
# 'make installcheck' then 'make install'
#
# NOTE: Updating OS software, installing xcode and Homebrew should be done 
# on first installation or as needed. Refer to the information in this 
# repository - https://github.com/brianmcmillan/makefile_system_setup
#-------------------------------------------------------------------------
# make all                  Executes the default make task.
# make help                 List of all makefile tasks.
# make installcheck         Run the project installation test suite.
# make install              Run installation steps (may include pre-install, normal-install, post-install steps).
# make check                Executes all test suites.
# make documentation        Builds the documentation files for the build. (e.g. schema docs, data flow diagrams)
# make uninstall            Uninstalls the project.

include config/make/macros.mk
include config/make/variables.mk

############################################################################
# Variables                                                                #
############################################################################
# Project variables
BUSINESS-CONTACT-NAME := "Brian McMillan"
BUSINESS-CONTACT-EMAIL := "brian@minimumviablearchitecture.com"
TECHNICAL-CONTACT-NAME := "Some Person"
TECHNICAL-CONTACT-EMAIL := "me@example.com"


# Deployment variables
LOCAL_ADDRESS := $(shell ipconfig getifaddr en0) #192.168.1.251
LOCAL_PORT := 8001

#######################################
all: installcheck initial-documentation ## Executes the default make task.

.FORCE: 

foo:
	echo $(LOGFILE)


installdirs: ## Creates the project directories.
	@mkdir -p $(PROJECTLOGDIR) $(TEMPSTATEDIR) \
	$(SQLITE-SRCDIR) $(TEMPLATE-FILEDIR) $(UNIT-TESTSDIR) $(INTEGRATION-TESTSDIR) \
	$(PYTHON-CONFIGDIR) $(APPSERVER-CONFIGDIR) $(VIZSERVER-CONFIGDIR) $(SCHEDULE-CONFIGDIR) $(PIPELINE-CONFIGDIR) \
	$(DATA_SOURCE-CONFIGDIR) $(SEED_DATA-CONFIGDIR) $(SQL_DLL-CONFIGDIR) $(SQL_DML-CONFIGDIR) \
	$(TUTORIAL-FILEDIR) $(HOWTO-FILEDIR) $(REFERENCE-FILEDIR) $(DISCUSSION-FILEDIR) \
	$(METRICS-FILEDIR) $(LOG-FILEDIR) $(ERROR-FILEDIR) $(STATIC-FILEDIR) $(METADATA-FILEDIR) \
	$(DATABASE-FILEDIR) $(SQL_DQL-FILEDIR) \
	$(LOCAL-DEPLOYMENTDIR) $(CLOUDRUN-DEPLOYMENTDIR) $(SQLITE3-DEPLOYMENTDIR)
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $@\" >> $(LOGFILE)







# .PHONY: all help documentation initial-documentation list-variables \
# installcheck check test-gitignore test-README.md test-brew_packages_base.txt test-brew_packages_installed.txt install \
# update update-macos install-xcode update-homebrew uninstall uninstall-files

############################################################################
# Documentation                                                            #
############################################################################
documentation: test-makefile_graph.png test-directory_listing.txt test-database_schema.png test-database_schema.er ## Builds the documentation files for the build. (e.g. schema docs, data flow diagrams)

initial-documentation: test-directory_listing.txt help

help: ## List of all makefile tasks.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | sort | \
	awk 'BEGIN {FS = ":.*?## "};\
	{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' 

directory_listing.txt: .FORCE
	$(directory-listing)

makefile_graph.png: .FORCE
	$(makefile-graph)

database_schema.png: er_relationships.txt .FORCE
	$(er-diagram)

database_schema.er: er_relationships.txt .FORCE
	$(er-diagram)

list-variables: 
	@echo PYENVDIR - $(PYENVDIR)
	@echo PYTHON - $(PYTHON)
	@echo PIP - $(PIP)

############################################################################
# Tests                                                                    #
############################################################################
installcheck: test-gitignore test-directory_listing.txt test-README-TEMPLATE.md test-README.md test-LICENSE.md ## Run the pre-installation test suite.

check: installcheck check-base-software check-database check-load-files check-documentation ## Executes all test suites.

check-base-software: test-brew_packages_base.txt test-brew_packages_installed.txt \
test-requirements.txt test-requirements_base.txt test-gitignore test-python-version

check-documentation: test-makefile_graph.png test-makefile_graph.txt test-directory_listing.txt

check-database: test-database test-database_schema.png test-database_schema.er \
test-REF_CALENDAR_001 test-META_TABLES_001

check-load-files: test-metric_sample_001.csv


test-gitignore: .gitignore
	$(test-dependent-file)

test-python-version: .python-version
	$(test-dependent-file)

test-README.md: README.md
	$(test-dependent-file)

test-README-TEMPLATE.md: README-TEMPLATE.md
	$(test-dependent-file)

test-LICENSE.md: LICENSE.md
	$(test-dependent-file)

test-directory_listing.txt: directory_listing.txt
	$(test-dependent-file)

test-brew_packages_base.txt: brew_packages_base.txt
	$(test-dependent-file)

test-brew_packages_installed.txt: brew_packages_installed.txt
	$(test-dependent-file)

test-requirements.txt: requirements.txt
	$(test-dependent-file)

test-requirements_base.txt: requirements_base.txt
	$(test-dependent-file)

test-makefile_graph.png: makefile_graph.png
	$(test-dependent-file)

test-makefile_graph.txt: makefile_graph.txt
	$(test-dependent-file)

test-database_schema.png: database_schema.png
	$(test-dependent-file)

test-database_schema.er: database_schema.er
	$(test-dependent-file)

#------------------------------------------------
test-database: create-database
	$(test-database)

test-REF_CALENDAR_001_create.sql: REF_CALENDAR_001_create.sql
	$(test-dependent-file)

test-REF_CALENDAR_001: TABLENAME = REF_CALENDAR_001
test-REF_CALENDAR_001: create-REF_CALENDAR_001 test-REF_CALENDAR_001_create.sql
	$(test-table)

test-META_TABLES_001: TABLENAME = META_TABLES_001
test-META_TABLES_001: META_TABLES_001
	$(test-table)


test-metric_sample_001.csv: metric_sample_001.csv
	$(test-dependent-file)

test-metadata.yaml: metadata.yaml
	$(test-dependent-file)	

############################################################################
# Installation - Base Software                                             #
############################################################################
install: install-pip-packages .gitignore git-init check ## Run once when setting up a new project.

brew_packages_base.txt: .FORCE
	$(base-brew-package-list)

brew_packages_installed.txt: brew_packages_base.txt .FORCE
	$(list-brew-packages)

install-python-local-virtualenv: 
	$(install-python-local-virtualenv)

# Python pip packages
# To upgrade - Edit requirements_base.txt with the new projects and/or versions
# then run 'make update-pip-packages'.
requirements_base.txt: .FORCE
	@echo makefile2dot==1.0.2 > $@
	@echo pygraphviz==1.9 >> $@
	@echo sqlite-utils==3.22.1 >> $@
	@echo ERAlchemy==1.2.10 >> $@
	@echo SQLAlchemy==1.3.24 >> $@
	@echo datasette==0.61.1 >> $@
	@echo datasette-copyable==0.3.1 >> $@
	@echo datasette-vega==0.6.2 >> $@
	@echo datasette-yaml==0.1.1 >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

requirements.txt: requirements_base.txt
	$(freeze-pip)

install-pip-packages: requirements_base.txt install-python-local-virtualenv
	$(install-pip-packages)

############################################################################
# Utility tasks to update shell profiles on macOS.
# WARNING: These will be appended to the profiles and duplicates will need to be manually removed. 
# update-bash-profile:
# 	@echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# 	@echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
# 	@echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
# 	@echo 'eval "$(pyenv init --path)"' >> ~/.profile
# 	@echo 'if [ -n "$PS1" -a -n "$BASH_VERSION" ]; then source ~/.bashrc; fi' >> ~/.profile
# 	@echo 'if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi' >>  ~/.profile
# 	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"bash shell configuration updated.\" 
#
############################################################################

git-init: 
	@git init

############################################################################
# Utility commands to setup git for a user.
# git config --global user.name <name>
# git config --global user.email <email>
# git config --global color.ui auto
############################################################################

compact-database: $(DATABASE-PATH) ## Database maintenance scripts.
	$(compact-database)

backup-database: BACKUPFILEPATH=$(DATABASE-PATH).bak
backup-database: $(DATABASE-PATH)
	$(backup-database)

log-rotate: LOGFILEPATH=$(LOGFILE)
log-rotate: 
	$(log-rotate)


############################################################################
# Update                                                                   #
############################################################################
update: update-homebrew update-pip-packages check ## Updates base software (OS, Homebrew, python, pip)

update-macos: 
	$(update-macos)

update-homebrew: 
	$(update-homebrew)

update-pip-packages: requirements_base.txt
	$(update-pip-packages)

############################################################################
# Uninstall                                                                #
############################################################################
uninstall: uninstall-files uninstall-database ## Uninstalls the project files.

uninstall-all: uninstall uninstall-virtualenv

uninstall-files: FILES=.gitignore README-TEMPLATE.md LICENSE.md brew_packages_*.txt directory_listing.txt \
makefile_graph.png requirements_base.txt requirements.txt brew_packages_* metric_sample_001.csv test-metadata.yaml
uninstall-files: 
	$(uninstall-file-list)

uninstall-database: FILES=*.db *.db-* database_schema.* er_relationships.txt *.er REF_CALENDAR_001_create.sql
uninstall-database: 
	$(uninstall-file-list)

uninstall-virtualenv: 
	$(uninstall-virtualenv)

# WARNING: Uninstalling Homebrew *WILL* affect outher applications
# uninstall-homebrew: .FORCE
# 	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
# 	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Homebrew uninstalled\"

############################################################################
# Document Templates                                                       #
############################################################################
.gitignore: 
	@echo ".DS_Store" > $@
	@echo ".DS_Store?" >> $@
	@echo "*.DS_Store" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

README-TEMPLATE.md: LICENSE.md
	@echo "# $(PROJECT-NAME)" >> $@
	@echo "## Brief Description" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo "  " >> $@
	@echo "## Project Status" >> $@
	@echo "[ ACTIVE | DEPRICATED | NOT ACTIVE ]  " >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Problem Statement" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Who is this for?" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Prerequsites" >> $@
	@echo "[ ] Lorem ipsum dolor sit amet.  " >> $@
	@echo "[ ] Consectetur adipiscing elit.  " >> $@
	@echo "[ ] Sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Usage" >> $@
	@echo "1. Lorem ipsum dolor sit amet.  " >> $@
	@echo "2. Consectetur adipiscing elit.  " >> $@
	@echo "3. Sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "### First time setup" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo "1. Lorem ipsum dolor sit amet  " >> $@
	@echo "2. Consectetur adipiscing elit  " >> $@
	@echo "3. Sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "### Normal operation" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo "1. Lorem ipsum dolor sit amet  " >> $@
	@echo "2. Consectetur adipiscing elit  " >> $@
	@echo "3. Sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Images / Screen Shots" >> $@
	@echo "[image caption](some.jpg)" >> $@
	@echo " " >> $@
	@echo "## Support" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## Roadmap" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "## How you can help" >> $@
	@echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.  " >> $@
	@echo " " >> $@
	@echo "----" >> $@
	@echo " " >> $@
	@echo "### License" >> $@
	@echo "[MIT](LICENSE.md)" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

LICENSE.md:
	@echo "# MIT License" >> $@
	@echo "Copyright (c) $(shell date -u +"%Y") $(BUSINESS-CONTACT-NAME) $(BUSINESS-CONTACT-NAME)" >> $@
	@echo " " >> $@
	@echo "Permission is hereby granted, free of charge, to any person obtaining a copy" >> $@
	@echo "of this software and associated documentation files (the "Software"), to deal" >> $@
	@echo "in the Software without restriction, including without limitation the rights" >> $@
	@echo "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell" >> $@
	@echo "copies of the Software, and to permit persons to whom the Software is" >> $@
	@echo "furnished to do so, subject to the following conditions:" >> $@
	@echo " " >> $@
	@echo "The above copyright notice and this permission notice shall be included in all" >> $@
	@echo "copies or substantial portions of the Software." >> $@
	@echo " " >> $@
	@echo "THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR" >> $@
	@echo "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY," >> $@
	@echo "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE" >> $@
	@echo "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER" >> $@
	@echo "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM," >> $@
	@echo "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE" >> $@
	@echo "SOFTWARE." >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

REF_CALENDAR_001_create.sql: .FORCE
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

er_relationships.txt: .FORCE
	@echo "REF_CALENDAR_001 1--1 REF_CALENDAR_001" > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

metric_sample_001.csv: 
	@echo provider_code,node_code,node_qualifier,metric_code,value_dts,metric_value > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

metadata.yaml: 
	@echo "title{{colon}} $(PROJECT-NAME)" > $@
	@echo "about{{colon}} Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor." >> $@
	@echo "about_url{{colon}} https{{colon}}//example.com/" >> $@
	@echo "source{{colon}} Building Data Products" >> $@
	@echo "source_url{{colon}} https{{colon}}//example.com/" >> $@
	@echo "description_html{{colon}} |-" >> $@
	@echo "  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.<br>" >> $@
	@echo "  Lorem ipsum dolor sit amet, consectetur adipiscing elit." >> $@
	@echo "  <p></p>" >> $@
	@echo "  <strong>Contacts{{colon}}</strong><br>" >> $@
	@echo "  Business Contact{{colon}} <a href = mailto{{colon}} "brian@minimumviablearchitecture.com">Brian McMillan</a><br>" >> $@
	@echo "  Technical Contact{{colon}} <a href = mailto{{colon}} "me@example.com">Some Person</a>" >> $@
	@echo "license{{colon}} DbCL" >> $@
	@echo "license_url{{colon}} https{{colon}}//opendatacommons.org/licenses/dbcl/1-0/" >> $@
	@echo "databases{{colon}}" >> $@
	@echo "  makefile_analytics_project{{colon}}" >> $@
	@echo "    tables{{colon}}" >> $@
	@echo "      REF_CALENDAR_001{{colon}}" >> $@
	@echo "        description{{colon}} Basic date dimension table. JOIN on either the date or date_int columns." >> $@
	@echo "        source{{colon}} REF_CALENDAR_001_create.sql" >> $@
	@echo "        about{{colon}} Standard reference table with dates between 2020-01-01 and 2024-01-01" >> $@
	@echo "        sort{{colon}} date_int" >> $@
	@echo "        columns{{colon}} " >> $@
	@echo "            date{{colon}} Date in YYYY-MM-DD format." >> $@
	@echo "            date_int{{colon}} Date in YYYYMMDD format." >> $@
	@echo "            date_julian_day{{colon}} Numeric date value used to compute the differences between dates." >> $@
	@echo "            date_end_of_year{{colon}} Date at the end of the year." >> $@
	@echo "            date_end_of_week_smtwtfs{{colon}} Date at the end of the week. Assumes the week starts on a Sunday and ends on a Saturday." >> $@
	@echo "            days_in_period_month{{colon}} Number of days in this month." >> $@
	@echo "            days_in_period_week{{colon}} Number of days in this week." >> $@
	@echo "            year{{colon}} Year in YYYY format." >> $@
	@echo "            year_month{{colon}} Month in YYYY-MM format." >> $@
	@echo "            year_week_of_year{{colon}} Week of the year in YYYY-WW format." >> $@
	@echo "      META_TABLES_001{{colon}}" >> $@
	@echo "        description{{colon}} Data catalog table." >> $@
	@echo "        source{{colon}} META_TABLES_001_create" >> $@
	@echo "        about{{colon}} Standard reference table with metadata for each table in the database." >> $@
	@echo "        columns{{colon}} " >> $@
	@echo "            table{{colon}} The name of the table." >> $@
	@echo "            column{{colon}} The name of the column." >> $@
	@echo "            total_rows{{colon}} Total number of rows in the table." >> $@
	@echo "            num_null{{colon}} Count of NULL records in the column." >> $@
	@echo "            num_blank{{colon}} Count of empty records in the column." >> $@
	@echo "            num_distinct{{colon}} Count of distinct records in the column." >> $@
	@echo "            most_common{{colon}} JSON array of the most common values in the column." >> $@
	@echo "            least_common{{colon}} JSON array of the least common values in the column." >> $@
	@echo "    queries{{colon}}" >> $@
	@echo "        end_of_period_lookup{{colon}}" >> $@
	@echo "          title{{colon}} End of period date look-up" >> $@
	@echo "          description{{colon}} Look-up query to assist in aggregating data by the end of year, month, or week date." >> $@
	@echo "          sql{{colon}}  |-" >> $@
	@echo "            SELECT" >> $@
	@echo "              date," >> $@
	@echo "              date_end_of_week_smtwtfs AS date_end_of_week," >> $@
	@echo "              date_end_of_month," >> $@
	@echo "              date_end_of_year" >> $@
	@echo "            FROM" >> $@
	@echo "              REF_CALENDAR_001" >> $@
	@echo "            ORDER BY" >> $@
	@echo "              date_int ASC" >> $@
	@sed -i -e 's/{{colon}}/:/g' $@
	@rm -f $@-e
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

############################################################################
# Configure Database                                                       #
############################################################################
# Create the default project database 
init-tables: metric-REF_CALENDAR_001 META_TABLES_001 check-database

create-database: 
	$(create-database)

# Create database reference tables 
create-REF_CALENDAR_001: REF_CALENDAR_001_create.sql test-database
	$(execute-sql)

metric-REF_CALENDAR_001: TABLENAME=REF_CALENDAR_001
metric-REF_CALENDAR_001: test-REF_CALENDAR_001
	$(record-count-table)

META_TABLES_001: .FORCE
	$(metadata-tables)

############################################################################
# Collect Metrics                                                          #
# Append the record_count metric to the metric_sample csv file.            #
# provider_code,node_code,node_qualifier,metric_code,value_dts,metric_value#
############################################################################
calculate-metrics: test-metric_sample_001.csv record_count-REF_CALENDAR_001.csv

record_count-REF_CALENDAR_001.csv: TABLENAME=REF_CALENDAR_001
record_count-REF_CALENDAR_001.csv: metric_sample_001.csv
	$(metric-record_count)





field_count_check-metric_sample_001.csv: EXPECTED=6
field_count_check-metric_sample_001.csv: metric_sample_001.csv
	$(csv_field_count_check)

number_check-metric_sample_001.csv: COLUMN=6
number_check-metric_sample_001.csv: metric_sample_001.csv
	$(csv_number_check)

regex_check-metric_sample_001.csv-C3: COLUMN=3
regex_check-metric_sample_001.csv-C3: REGEX=^[[:space:]\"a-zA-Z0-9\/,.:_-]+$$
regex_check-metric_sample_001.csv-C3: metric_sample_001.csv
	$(csv_regex_check)

############################################################################
# Deployment                                                               #
############################################################################

# build/local: build/db/online_retail.db
# 	@echo $(DTS)     [INFO] - Executing $@
# 	@mkdir -p deploy/$(notdir $@)/static
# 	@cp -f config/app/metadata.yaml deploy/local/metadata.yaml
# 	@cp -f config/server/requirements.txt deploy/local/requirements.txt
# 	@cp -f config/server/settings.txt deploy/local/settings.txt
# 	@cp -f $< deploy/local/$(<F)

deploy-local: test-metadata.yaml test-database
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Starting server on http://$(strip $(LOCAL_ADDRESS)):$(LOCAL_PORT)\"
	$(DATASETTE) $(DATABASE-PATH) --host $(LOCAL_ADDRESS) --port $(LOCAL_PORT) --metadata metadata.yaml -o
#	@$(DATASETTE) serve deploy/local/ --host $(LOCAL_ADDRESS) --port $(LOCAL_PORT) -o
	