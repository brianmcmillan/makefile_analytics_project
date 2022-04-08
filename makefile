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

############################################################################
# Macros                                                                   #
############################################################################
define help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | sort | \
	awk 'BEGIN {FS = ":.*?## "};\
	{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef

define test-file
	@# tests the file in the <target>
	@#<target>(colon)(space)<path/to/directory> 
	@[[ -f $@ ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $(NAME)     \"testing for $< did not find $@\" 
endef

define test-dependent-file
	@# tests the file in the <first dependency>
	@[[ -f $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [WARNING]    $@     \"testing for $< did not find $<\" 
endef

define uninstall-file
	@# <target>(colon)(space)<path/to/file(s)>
	@rm -f $^ || true
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Files removed - $^\"
endef

define uninstall-file-list
	@#<target>(colon)(space)FILE=<list of file(s)>
	@#<target>(colon)(space)
	@rm -f $(FILES)
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Files removed - $(FILES)\"
endef

define directory-listing
	@#<path/to/directory_listing.txt>(colon)(space).FORCE
	@$(TREE) --prune > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created directory list at $@\"
endef

define makefile-graph
	@$(NODEGRAPH) --direction LR | $(GRAPHVIZDOT) -Tpng > $(basename $@).png
	@$(NODEGRAPH) --direction LR | $(GRAPHVIZDOT) -Tplain > $(basename $@).txt
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created makefile diagram at $@\"
endef

define create-database
	@#create-database(colon)(space)
	@$(SQLITEUTILS) create-database $(DATABASE) --enable-wal
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created database in WAL mode - $(DATABASE)\"
endef

define test-database
	@[[ -f $(DATABASE-PATH) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [WARNING]    $@     \"testing for $(DATABASE) did not find $(DATABASE-PATH)\"
endef

define execute-sql
	@#<verb>-<table_name>(colon)(space)<path/to/<query_file>.sql> [<path/to/database.db> <dependent tables>]
	@$(shell $(SQLITE3) $(DATABASE-PATH) ".read $<" ".quit")
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $< on $(DATABASE)\"
endef

define test-table
	@#test-<table_name>(colon)(space)TABLENAME=<table_name>
	@#test-<table_name>(colon)(space)
	@[[ $(shell $(SQLITE3) $(DATABASE-PATH) ".tables $(TABLENAME)" ".quit") == $(TABLENAME) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"Table $(TABLENAME) not found\" 
endef

define record-count-table
	@#record-count-<table name>(colon)(space)TABLENAME=<table_name>
	@#record-count-<table name>(colon)(space)
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"$(shell $(SQLITE3) $(DATABASE-PATH) "SELECT COUNT(*) || ' records in $(DATABASE).$(TABLENAME)' FROM [$(TABLENAME)]" ".quit")\"
endef

define er-diagram
	@#<path/to/diagram.type>(colon)(space)<path/to/er_relationships.txt>"
	@#Types can be er, pdf, png, dot
	@$(ERALCHEMY) -i sqlite:///$(DATABASE-PATH) -o $(subst .,,$(notdir $(DATABASE-PATH))).er
	@cat $(subst .,,$(notdir $(DATABASE-PATH))).er $< > $(subst .,,$(notdir $(DATABASE-PATH)))_2.er || true
	@$(ERALCHEMY) -i $(subst .,,$(notdir $(DATABASE-PATH)))_2.er -o $@
	@rm -f $(subst .,,$(notdir $(DATABASE-PATH)))*.er
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed er-digram and exported to $@\"
endef

define metric-record_count
	@#record_count-<TABLE_NAME.CSV>(colon)(space)TABLENAME=<TABLE_NAME>
	@#record_count-<TABLE_NAME.CSV>(colon)(space)<path/to/metric_sample.csv>
	@echo $(PROJECT-PATH)/$(firstword $(MAKEFILE_LIST)).$@,$(DATABASE).$(TABLENAME),"COUNT",record_count,$(shell date -u +"%Y-%m-%dT%H:%M:%SZ"),$(shell $(SQLITE3) $(DATABASE-PATH) "SELECT COUNT(*) FROM [$(TABLENAME)]" ".quit") >> $<
endef	

define update-homebrew
	@#update-homebrew(colon)(space)
	@$(BREW) update
	@$(BREW) upgrade
	@$(BREW) install $(HOMEBREW-PACKAGES)
	@(echo "$(HOMEBREW-PACKAGES)" | sed -e 's/ /\n/g') > brew_packages_base.txt
	$(BREW) list --versions > brew_packages_installed.txt
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Homebrew software updated\"
endef

define update-pip-packages
	@#update-pip-packages(colon)(space)requirements_base.txt
	@$(shell pyenv which pip) install --upgrade pip
	@$(shell pyenv which pip) install -r $<
	@$(shell pyenv which pip) freeze > requirements.txt
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Python pip packages upgraded - requirements.txt\"
endef

define update-macos
	@#update-macos(colon)(space)
	@softwareupdate --all --install --force
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"macOS software updated\"
endef

define install-pip-packages
	@#install-pip-packages(colon)(space)requirements_base.txt install-python-local-virtualenv
	@$(shell pyenv which pip) install --upgrade pip
	@$(shell pyenv which pip) install -r $<
	@$(shell pyenv which pip) freeze > requirements.txt
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Python pip packages installed - requirements.txt\"
endef

define freeze-pip
	@#requirements.txt(colon)(space)requirements_base.txt
	@$(shell pyenv which pip) freeze > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Python pip packages installed - requirements.txt\"
endef

define install-python-local-virtualenv
	@#install-python-local-virtualenv(colon)(space)
	@pyenv virtualenv $(PYTHON-VERSION) $(PROJECT-NAME) || true
	@pyenv local $(PROJECT-NAME)
	@cd ..
	@cd $(PROJECT-PATH)
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Python location - $(shell pyenv which python)\" 
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"PIP location - $(shell pyenv which pip)\"
endef

define list-brew-packages
	@#brew_packages_installed.txt(colon)(space)brew_packages_base.txt .FORCE
	@$(BREW) list --versions > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\"
endef

define base-brew-package-list
	@#brew_packages_base.txt(colon)(space).FORCE
	@(echo "$(HOMEBREW-PACKAGES)" | sed -e 's/ /\n/g') > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" 
endef	

define uninstall-virtualenv
	@#uninstall-virtualenv(colon)(space)
	@pyenv virtualenv-delete $(PROJECT-NAME) || true
	@rm -f .python-version
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Virtual environment removed - $(PROJECT-NAME)\"
endef

define metadata-tables
	@#META_TABLES_001(colon)(space)
	@$(SQLITE3) $(DATABASE-PATH) "DROP TABLE IF EXISTS '_analyze_tables_';" ".quit"
	@$(SQLITE3) $(DATABASE-PATH) "DROP TABLE IF EXISTS 'META_TABLES_001';" ".quit"
	@$(SQLITEUTILS) analyze-tables $(DATABASE-PATH) --save
	@$(SQLITE3) $(DATABASE-PATH) "ALTER TABLE '_analyze_tables_' RENAME TO 'META_TABLES_001';" ".quit"
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"$(shell $(SQLITE3) $(DATABASE-PATH) "SELECT COUNT(*) || ' records in $(DATABASE).META_TABLES_001' FROM META_TABLES_001" ".quit")\"
endef

define csv_field_count_check
	@#field_count_check-<file_name.csv>(colon)(space)EXPECTED=<number_of_columns>
	@#field_count_check-<file_name.csv>(colon)(space)<path/to/file.csv>
	@[[ $$(datamash -t, check $(EXPECTED) fields < $<) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"Expected fields not equal to $(EXPECTED)\"
endef

define csv_number_check
	@#number_check-<file_name.csv>(colon)(space)COLUMN=<column_number>
	@#number_check-<file_name.csv>(colon)(space)<path/to/file.csv>
	@[[ $$(datamash -t, --header-in sum $(COLUMN) < metric_sample_001.csv) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"Expected numeric data in column $(COLUMN)\"
endef

define csv_regex_check
	@#regex_check-<file_name.csv>(colon)(space)COLUMN=<column_number>
	@#regex_check-<file_name.csv>(colon)(space)REGEX=<^[[:space:]\"a-zA-Z0-9\/,.:_-]+$$>
	@#regex_check-<file_name.csv>(colon)(space)<path/to/file.csv>
	@[[ $$(datamash -t, --header-in unique $(COLUMN) < metric_sample_001.csv) =~ $(REGEX) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"Column $(COLUMN) - $(REGEX) not matched\"
endef

############################################################################
# Variables                                                                #
############################################################################
# Application variables
HOMEBREW-PACKAGES := coreutils zlib openssl readline xz git tree gawk pyenv pyenv-virtualenv makefile2graph graphviz
PYTHON-VERSION := 3.10.2
PROJECT-PATH := $(shell pwd)
PROJECT-NAME := $(notdir $(shell pwd))
PROJECT-CONTACT := "brian mcmillan - brian[at]minimumviablearchitecture[dot]com"
DATABASE := $(PROJECT-NAME).db
DATABASE-PATH :=$(PROJECT-PATH)/$(PROJECT-NAME).db

# Program locations (which <utility>)
SHELL := /bin/bash
BREW := /usr/local/bin/brew
TREE := /usr/local/bin/tree
GRAPHVIZDOT := /usr/local/bin/dot
SQLITE3 := /usr/local/bin/sqlite3
PYENVDIR := ~/.pyenv/versions/$(PYTHON-VERSION)/envs/$(PROJECT-NAME)/bin
PYTHON := $(PYENVDIR)/python
PIP := $(PYENVDIR)/pip
NODEGRAPH := $(PYENVDIR)/makefile2dot
SQLITEUTILS := $(PYENVDIR)/sqlite-utils
NODEGRAPH := $(PYENVDIR)/makefile2dot
ERALCHEMY := $(PYENVDIR)/eralchemy

#######################################
all: installcheck initial-documentation ## Executes the default make task.

.FORCE: 

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
makefile_graph.png requirements_base.txt requirements.txt brew_packages_* metric_sample_001.csv
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
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\"

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
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\"

LICENSE.md:
	@echo "# MIT License" >> $@
	@echo "Copyright (c) $(shell date -u +"%Y") $(PROJECT-CONTACT)" >> $@
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
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\"

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
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\"

er_relationships.txt: .FORCE
	@echo "REF_CALENDAR_001 1--1 REF_CALENDAR_001" > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\"

metric_sample_001.csv: 
	@echo provider_code,node_code,node_qualifier,metric_code,value_dts,metric_value > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\"	

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

META_TABLES_001:
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

