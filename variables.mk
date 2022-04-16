# ~/Documents/GitHub/makefile_analytics_project/config/make/variables.mk
############################################################################
# VARIABLES                                                                #
############################################################################
# Application variables
HOMEBREW-PACKAGES := coreutils zlib openssl readline xz git tree gawk pyenv pyenv-virtualenv makefile2graph graphviz
PYTHON-VERSION := 3.10.2
PROJECT-PATH := $(shell pwd)
PROJECT-NAME := $(notdir $(shell pwd))
DATABASE := $(PROJECT-NAME).db
DATABASE-PATH := $(DATABASE-FILEDIR)/$(PROJECT-NAME).db

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
DATASETTE := $(PYENVDIR)/datasette

# Project directory structure
# Temporary application files
TEMPSTATEDIR := $(PROJECT-PATH)/tmp
PROJECTLOGDIR := $(PROJECT-PATH)/log
LOGFILE := $(PROJECTLOGDIR)/$(PROJECT-NAME).log

# Source code and templates
SQLITE-SRCDIR := $(PROJECT-PATH)/src/sqlite3
TEMPLATE-FILEDIR := $(PROJECT-PATH)/src/templates

# Tests
UNIT-TESTSDIR := $(PROJECT-PATH)/test/unit_tests/mocks
INTEGRATION-TESTSDIR := $(PROJECT-PATH)/test/integration_test

# Configuration
BREW-CONFIGDIR := $(PROJECT-PATH)/config/homebrew
PYTHON-CONFIGDIR := $(PROJECT-PATH)/config/python
APPSERVER-CONFIGDIR := $(PROJECT-PATH)/config/datasette
VIZSERVER-CONFIGDIR := $(PROJECT-PATH)/config/vega
SCHEDULE-CONFIGDIR := $(PROJECT-PATH)/config/cron
PIPELINE-CONFIGDIR := $(PROJECT-PATH)/config/make
DATA_SOURCE-CONFIGDIR := $(PROJECT-PATH)/config/data_sources
SEED_DATA-CONFIGDIR := $(PROJECT-PATH)/config/seed_data
SQL_DLL-CONFIGDIR := $(PROJECT-PATH)/config/sql_ddl
SQL_DML-CONFIGDIR := $(PROJECT-PATH)/config/sql_dml

# Documentation
TUTORIAL-FILEDIR := $(PROJECT-PATH)/doc/tutorial
HOWTO-FILEDIR := $(PROJECT-PATH)/doc/howto
REFERENCE-FILEDIR := $(PROJECT-PATH)/doc/reference
DISCUSSION-FILEDIR := $(PROJECT-PATH)/doc/discussion

# Application load files
LOAD-FILEDIR := $(PROJECT-PATH)/load
METRICS-FILEDIR := $(PROJECT-PATH)/load/metric
LOG-FILEDIR := $(PROJECT-PATH)/load/log
ERROR-FILEDIR := $(PROJECT-PATH)/load/error

# Application build files
STATIC-FILEDIR := $(PROJECT-PATH)/build/static
METADATA-FILEDIR := $(PROJECT-PATH)/build/metadata
DATABASE-FILEDIR := $(PROJECT-PATH)/build/db
SQL_DQL-FILEDIR := $(PROJECT-PATH)/build/adhoc_sql

# Deployment artifacts
LOCAL-DEPLOYMENTDIR := $(PROJECT-PATH)/deploy/local/static
CLOUDRUN-DEPLOYMENTDIR := $(PROJECT-PATH)/deploy/cloudrun/static
SQLITE3-DEPLOYMENTDIR := $(PROJECT-PATH)/deploy/sqlite3
