# ~/Documents/GitHub/makefile_analytics_project/config/make/macros.mk
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
	@#<target>{{colon}}{{space}}<path/to/directory> 
	@[[ -f $@ ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $(NAME)     \"testing for $< did not find $@\" >> $(LOGFILE)
endef

define test-dependent-file
	@# tests the file in the <first dependency>
	@[[ -f $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [WARNING]    $@     \"testing for $< did not find $<\" >> $(LOGFILE)
endef

define test-dir
	@# tests the directory in the <dependency>
	@#<target>(colon)(space)<path/to/directory>
	@[[ -d $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"testing for $< did not find $?\" >> $(LOGFILE)
endef

define uninstall-file
	@# <target>{{colon}}{{space}}<path/to/file(s)>
	@rm -f $^ || true
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Files removed - $^\" >> $(LOGFILE)
endef

define uninstall-file-list
	@#<target>{{colon}}{{space}}FILES=<list of file(s)>
	@#<target>{{colon}}{{space}}
	@rm -f $(FILES)
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Files removed - $(FILES)\" >> $(LOGFILE)
endef

define directory-listing
	@#<path/to/directory_listing.txt>{{colon}}{{space}}.FORCE
	@$(TREE) --prune > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created directory list at $@\" >> $(LOGFILE)
endef

define makefile-graph
	@$(NODEGRAPH) --direction LR | $(GRAPHVIZDOT) -Tpng > $(basename $@).png
	@$(NODEGRAPH) --direction LR | $(GRAPHVIZDOT) -Tplain > $(basename $@).txt
	@#echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created makefile diagram at $@\" >> $(LOGFILE)
endef

define create-database
	@#create-database{{colon}}{{space}}
	@$(SQLITEUTILS) create-database $(DATABASE) --enable-wal
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created database in WAL mode - $(DATABASE)\" >> $(LOGFILE)
endef

define test-database
	@#test-database{{colon}}{{space}}
	@[[ -f $(DATABASE-PATH) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [WARNING]    $@     \"testing for $(DATABASE) did not find $(DATABASE-PATH)\" >> $(LOGFILE)
endef

define execute-sql
	@#<verb>-<table_name>{{colon}}{{space}}<path/to/<query_file>.sql> [<path/to/database.db> <dependent tables>]
	@$(shell $(SQLITE3) $(DATABASE-PATH) ".read $<" ".quit")
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $< on $(DATABASE)\" >> $(LOGFILE)
endef

define test-table
	@#test-<table_name>{{colon}}{{space}}TABLENAME=<table_name>
	@#test-<table_name>{{colon}}{{space}}
	@[[ $(shell $(SQLITE3) $(DATABASE-PATH) ".tables $(TABLENAME)" ".quit") == $(TABLENAME) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"Table $(TABLENAME) not found\" >> $(LOGFILE)
endef

define record-count-table
	@#record-count-<table name>{{colon}}{{space}}TABLENAME=<table_name>
	@#record-count-<table name>{{colon}}{{space}}
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"$(shell $(SQLITE3) $(DATABASE-PATH) "SELECT COUNT(*) || ' records in $(DATABASE).$(TABLENAME)' FROM [$(TABLENAME)]" ".quit")\" >> $(LOGFILE)
endef

define er-diagram
	@#<path/to/diagram.type>{{colon}}{{space}}<path/to/er_relationships.txt>"
	@#Types can be er, pdf, png, dot
	@$(ERALCHEMY) -i sqlite:///$(DATABASE-PATH) -o tmp/$(subst .,,$(notdir $(DATABASE-PATH))).er
	@cat tmp/$(subst .,,$(notdir $(DATABASE-PATH))).er $< > tmp/$(subst .,,$(notdir $(DATABASE-PATH)))_2.er || true
	@$(ERALCHEMY) -i tmp/$(subst .,,$(notdir $(DATABASE-PATH)))_2.er -o $@
	@rm -f tmp/$(subst .,,$(notdir $(DATABASE-PATH)))*.er
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed er-digram and exported to $@\" >> $(LOGFILE)
endef

define metric-record_count
	@#record_count-<TABLE_NAME.CSV>{{colon}}{{space}}TABLENAME=<TABLE_NAME>
	@#record_count-<TABLE_NAME.CSV>{{colon}}{{space}}<path/to/metric_sample.csv>
	@echo $(PROJECT-PATH)/$(firstword $(MAKEFILE_LIST)).$@,$(DATABASE).$(TABLENAME),"COUNT",record_count,$(shell date -u +"%Y-%m-%dT%H:%M:%SZ"),$(shell $(SQLITE3) $(DATABASE-PATH) "SELECT COUNT(*) FROM [$(TABLENAME)]" ".quit") >> $<
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Record count in $(DATABASE).$(TABLENAME) - $(shell $(SQLITE3) $(DATABASE-PATH) "SELECT COUNT(*) FROM [$(TABLENAME)]" ".quit")\" >> $(LOGFILE)
endef	

define update-homebrew
	@#update-homebrew{{colon}}{{space}}<path/to/brew_packages_base.txt>
	@$(BREW) update
	@$(BREW) upgrade
	@$(BREW) install $(HOMEBREW-PACKAGES)
	@(echo "$(HOMEBREW-PACKAGES)" | sed -e 's/ /\n/g') > $<
	$(BREW) list --versions > config/homebrew/brew_packages_installed.txt
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Homebrew software updated\" >> $(LOGFILE)
endef

define update-pip-packages
	@#update-pip-packages{{colon}}{{space}}<path/to/requirements_base.txt>
	@$(shell pyenv which pip) install --upgrade pip
	@$(shell pyenv which pip) install -r $<
	@$(shell pyenv which pip) freeze > config/python/requirements.txt
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Python pip packages upgraded - requirements.txt\" >> $(LOGFILE)
endef

define update-macos
	@#update-macos{{colon}}{{space}}
	@softwareupdate --all --install --force
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"macOS software updated\" >> $(LOGFILE)
endef

define install-pip-packages
	@#install-pip-packages{{colon}}{{space}}requirements_base.txt install-python-local-virtualenv
	@$(shell pyenv which pip) install --upgrade pip
	@$(shell pyenv which pip) install -r $<
	@$(shell pyenv which pip) freeze > requirements.txt
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Python pip packages installed - requirements.txt\" >> $(LOGFILE)
endef

define freeze-pip
	@#<path/to/requirements.txt>{{colon}}{{space}}
	@$(shell pyenv which pip) freeze > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Python pip packages installed - requirements.txt\" >> $(LOGFILE)
endef

define install-python-local-virtualenv
	@#install-python-local-virtualenv{{colon}}{{space}}
	@pyenv virtualenv $(PYTHON-VERSION) $(PROJECT-NAME) || true
	@pyenv local $(PROJECT-NAME)
	@cd ..
	@cd $(PROJECT-PATH)
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Python location - $(shell pyenv which python)\"  >> $(LOGFILE)
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"PIP location - $(shell pyenv which pip)\" >> $(LOGFILE)
endef

define list-brew-packages
	@#<path/to/brew_packages_installed.txt>{{colon}}{{space}}<path/to/brew_packages_base.txt> .FORCE
	@$(BREW) list --versions > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)
endef

define base-brew-package-list
	@#<<path/to/brew_packages_base.txt>{{colon}}{{space}}.FORCE
	@(echo "$(HOMEBREW-PACKAGES)" | sed -e 's/ /\n/g') > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\"  >> $(LOGFILE)
endef	

define uninstall-virtualenv
	@#uninstall-virtualenv{{colon}}{{space}}
	@pyenv virtualenv-delete $(PROJECT-NAME) || true
	@rm -f .python-version
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Virtual environment removed - $(PROJECT-NAME)\" >> $(LOGFILE)
endef

define metadata-tables
	@#META_TABLES_001{{colon}}{{space}}
	@$(SQLITE3) $(DATABASE-PATH) "DROP TABLE IF EXISTS '_analyze_tables_';" ".quit"
	@$(SQLITE3) $(DATABASE-PATH) "DROP TABLE IF EXISTS 'META_TABLES_001';" ".quit"
	@$(SQLITEUTILS) analyze-tables $(DATABASE-PATH) --save
	@$(SQLITE3) $(DATABASE-PATH) "ALTER TABLE '_analyze_tables_' RENAME TO 'META_TABLES_001';" ".quit"
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"$(shell $(SQLITE3) $(DATABASE-PATH) "SELECT COUNT(*) || ' records in $(DATABASE).META_TABLES_001' FROM META_TABLES_001" ".quit")\" >> $(LOGFILE)
endef

define csv_field_count_check
	@#field_count_check-<file_name.csv>{{colon}}{{space}}EXPECTED=<number_of_columns>
	@#field_count_check-<file_name.csv>{{colon}}{{space}}<path/to/file.csv>
	@[[ $$(datamash -t, check $(EXPECTED) fields < $<) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"Expected fields not equal to $(EXPECTED)\" >> $(LOGFILE)
endef

define csv_number_check
	@#number_check-<file_name.csv>{{colon}}{{space}}COLUMN=<column_number>
	@#number_check-<file_name.csv>{{colon}}{{space}}<path/to/file.csv>
	@[[ $$(datamash -t, --header-in sum $(COLUMN) < metric_sample_001.csv) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"Expected numeric data in column $(COLUMN)\" >> $(LOGFILE)
endef

define csv_regex_check
	@#regex_check-<file_name.csv>{{colon}}{{space}}COLUMN=<column_number>
	@#regex_check-<file_name.csv>{{colon}}{{space}}REGEX=<^[[:space:]\"a-zA-Z0-9\/,.:_-]+$$>
	@#regex_check-<file_name.csv>{{colon}}{{space}}<path/to/file.csv>
	@[[ $$(datamash -t, --header-in unique $(COLUMN) < metric_sample_001.csv) =~ $(REGEX) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"Column $(COLUMN) - $(REGEX) not matched\" >> $(LOGFILE)
endef

define compact-database
	@#compact-database{{colon}}{{space}}<path/to/database.db>
	@$(SQLITE3) $< "PRAGMA optimize;" && echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Optimized $<\" >> $(LOGFILE)
	@$(SQLITE3) $< "PRAGMA auto_vacuum = FULL;" && $(SQLITE3) $< "VACUUM;" && echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Vacuumed $<\" >> $(LOGFILE)
	@$(SQLITE3) $< "PRAGMA integrity_check;" && echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Performed integrity check on $<\" >> $(LOGFILE)
endef

define backup-database
	@#backup-database{{colon}}{{space}}BACKUPFILEPATH=<path/to/database.bak>
	@#backup-database{{colon}}{{space}}<path/to/database.db>
	@$(SQLITE3) $< ".backup $(BACKUPFILEPATH)"
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Backed up $< into $(BACKUPFILEPATH)\" >> $(LOGFILE)
endef

define log-rotate
	@#log-rotate{{colon}}{{space}}LOGFILEPATH=<path/to/logfile>
	@#log-rotate{{colon}}{{space}}<dependencies>
	@mv $(LOGFILEPATH) $(basename $(LOGFILEPATH))_$(shell date +%Y-%m-%d).log
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Rotated $(LOGFILEPATH) into $(basename $(LOGFILEPATH))_$(shell date +%Y-%m-%d).txt\" >> $(LOGFILE)
endef