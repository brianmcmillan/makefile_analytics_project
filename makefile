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

include macros.mk
include variables.mk
include init.mk
include templates.mk
include init_database.mk

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

############################################################################
all: initial-documentation ## Executes the default make task.

.FORCE: 

.PHONY: 

foo:
	echo $(LOGFILE)

############################################################################
# Tests                                                                    #
############################################################################
check: ## Executes all test suites.


############################################################################
# Documentation                                                            #
############################################################################
documentation: build/metadata/makefile_graph.png build/metadata/database_schema.png build/metadata/database_schema.er build/metadata/directory_listing.txt  ## Builds the documentation files for the build. (e.g. schema docs, data flow diagrams)

initial-documentation: build/metadata/directory_listing.txt help

help: ## List of all makefile tasks.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | sort | \
	awk 'BEGIN {FS = ":.*?## "};\
	{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' 

build/metadata/directory_listing.txt: .FORCE
	$(directory-listing)

build/metadata/makefile_graph.png: .FORCE
	$(makefile-graph)

build/metadata/er_relationships.txt: 
	@echo "REF_CALENDAR_001 1--1 REF_CALENDAR_001" > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

build/metadata/database_schema.png: build/metadata/er_relationships.txt .FORCE
	$(er-diagram)

build/metadata/database_schema.er: build/metadata/er_relationships.txt .FORCE
	$(er-diagram)

build/metadata/META_TABLES_001: .FORCE
	$(metadata-tables)

# list-variables: 
# 	@echo PYENVDIR - $(PYENVDIR)
# 	@echo PYTHON - $(PYTHON)
# 	@echo PIP - $(PIP)

############################################################################
# Utilities                                                                #
############################################################################

compact-database: $(DATABASE-PATH) ## Database maintenance scripts.
	$(compact-database)

backup-database: BACKUPFILEPATH=$(DATABASE-PATH).bak
backup-database: $(DATABASE-PATH)
	$(backup-database)

log-rotate: LOGFILEPATH=$(LOGFILE)
log-rotate: 
	$(log-rotate)


# ############################################################################
# # Uninstall                                                                #
# ############################################################################
# uninstall: uninstall-files uninstall-database ## Uninstalls the project files.

# uninstall-all: uninstall uninstall-virtualenv

# uninstall-files: FILES=.gitignore README-TEMPLATE.md LICENSE.md brew_packages_*.txt directory_listing.txt \
# makefile_graph.png requirements_base.txt requirements.txt brew_packages_* metric_sample_001.csv test-metadata.yaml
# uninstall-files: 
# 	$(uninstall-file-list)

# # uninstall-database: FILES=*.db *.db-* database_schema.* er_relationships.txt *.er REF_CALENDAR_001_create.sql
# # uninstall-database: 
# # 	$(uninstall-file-list)

# # uninstall-virtualenv: 
# # 	$(uninstall-virtualenv)

############################################################################
# Collect Metrics                                                          #
# Append the record_count metric to the metric_sample csv file.            #
# provider_code,node_code,node_qualifier,metric_code,value_dts,metric_value#
############################################################################
calculate-metrics: test-metric_sample_001.csv record_count-REF_CALENDAR_001.csv

record_count-REF_CALENDAR_001.csv: TABLENAME=REF_CALENDAR_001
record_count-REF_CALENDAR_001.csv: metric_sample_001.csv
	$(metric-record_count)

# field_count_check-metric_sample_001.csv: EXPECTED=6
# field_count_check-metric_sample_001.csv: metric_sample_001.csv
# 	$(csv_field_count_check)

# number_check-metric_sample_001.csv: COLUMN=6
# number_check-metric_sample_001.csv: metric_sample_001.csv
# 	$(csv_number_check)

# regex_check-metric_sample_001.csv-C3: COLUMN=3
# regex_check-metric_sample_001.csv-C3: REGEX=^[[:space:]\"a-zA-Z0-9\/,.:_-]+$$
# regex_check-metric_sample_001.csv-C3: metric_sample_001.csv
# 	$(csv_regex_check)

# ############################################################################
# # Deployment                                                               #
# ############################################################################

# # build/local: build/db/online_retail.db
# # 	@echo $(DTS)     [INFO] - Executing $@
# # 	@mkdir -p deploy/$(notdir $@)/static
# # 	@cp -f config/app/metadata.yaml deploy/local/metadata.yaml
# # 	@cp -f config/server/requirements.txt deploy/local/requirements.txt
# # 	@cp -f config/server/settings.txt deploy/local/settings.txt
# # 	@cp -f $< deploy/local/$(<F)

deploy-local: test-database
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Starting server on http://$(strip $(LOCAL_ADDRESS)):$(LOCAL_PORT)\"
	$(DATASETTE) $(DATABASE-PATH) --host $(LOCAL_ADDRESS) --port $(LOCAL_PORT) --metadata build/metadata/metadata.yaml -o
	