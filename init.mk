# ~/Documents/GitHub/makefile_analytics_project/config/make/init.mk
############################################################################
# Project initiation                                                       #
############################################################################

############################################################################
# Run once                                                                 #
############################################################################
# Utility commands to setup git for a user.
# git config --global user.name <name>
# git config --global user.email <email>
# git config --global color.ui auto
############################################################################
git-init: 
	@git init

############################################################################
# Installation                                                             #
############################################################################
install: installdirs .gitignore README-TEMPLATE.md config/homebrew/brew_packages_installed.txt install-pip-packages ## Run once when setting up a new project.

installdirs: ## Creates the project directories.
	@mkdir -p $(PROJECTLOGDIR) $(TEMPSTATEDIR) \
	$(SQLITE-SRCDIR) $(TEMPLATE-FILEDIR) $(UNIT-TESTSDIR) $(INTEGRATION-TESTSDIR) $(BREW-CONFIGDIR) \
	$(PYTHON-CONFIGDIR) $(APPSERVER-CONFIGDIR) $(VIZSERVER-CONFIGDIR) $(SCHEDULE-CONFIGDIR) \
	$(DATA_SOURCE-CONFIGDIR) $(SEED_DATA-CONFIGDIR) $(SQL_DLL-CONFIGDIR) $(SQL_DML-CONFIGDIR) \
	$(TUTORIAL-FILEDIR) $(HOWTO-FILEDIR) $(REFERENCE-FILEDIR) $(DISCUSSION-FILEDIR) \
	$(METRICS-FILEDIR) $(LOG-FILEDIR) $(ERROR-FILEDIR) $(STATIC-FILEDIR) $(METADATA-FILEDIR) \
	$(DATABASE-FILEDIR) $(SQL_DQL-FILEDIR) \
	$(LOCAL-DEPLOYMENTDIR) $(CLOUDRUN-DEPLOYMENTDIR) $(SQLITE3-DEPLOYMENTDIR)
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $@\" >> $(LOGFILE)

.gitignore: 
	@echo ".DS_Store" > $@
	@echo ".DS_Store?" >> $@
	@echo "*.DS_Store" >> $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created $@\" >> $(LOGFILE)

README-TEMPLATE.md: 
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

############################################################################
# Installation - Base Software                                             #
############################################################################
config/homebrew/brew_packages_base.txt: .FORCE
	$(base-brew-package-list)

config/homebrew/brew_packages_installed.txt: config/homebrew/brew_packages_base.txt .FORCE
	$(list-brew-packages)

# Python pip packages
# To upgrade - Edit requirements_base.txt with the new projects and/or versions
# then run 'make update-pip-packages'.
config/python/requirements_base.txt: .FORCE
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

config/python/requirements.txt: config/python/requirements_base.txt
	$(freeze-pip)

install-pip-packages: config/python/requirements_base.txt install-python-local-virtualenv
	$(install-pip-packages)

install-python-local-virtualenv: 
	$(install-python-local-virtualenv)

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

############################################################################
# Update                                                                   #
############################################################################
update: update-macos update-homebrew update-pip-packages ## Updates base software (OS, Homebrew, python, pip)

update-macos: 
	$(update-macos)

update-homebrew: config/homebrew/brew_packages_base.txt
	$(update-homebrew)

update-pip-packages: config/python/requirements_base.txt
	$(update-pip-packages)

############################################################################
# Uninstall                                                                #
############################################################################
uninstall-init-files: FILES=.gitignore README-TEMPLATE.md config/homebrew/* config/python/*
uninstall-init-files: 
	$(uninstall-file-list)

# WARNING: Uninstalling Homebrew *WILL* affect outher applications
# uninstall-homebrew: .FORCE
# 	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
# 	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Homebrew uninstalled\"