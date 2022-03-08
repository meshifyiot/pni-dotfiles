#
# Makefile for dotfiles
#
# This file can be used to install individual dotfiles or 
# all of them at once. Each Makefile rule will clean the
# existing dotfile and creating a new symlink.
#


help:
	@echo 'Makefile for dotfiles'
	@echo ''
	@echo 'Usage:'
	@echo '     make all                    install everything (runs all of the below setups)'
	@echo '-------------------------------------------------------------------------------------'
	@echo '     make non-os-specific        install all non-os-specific programs'
	@echo '     make macos                  install macos programs'
	@echo '     make nodepackage-setup      install node packages'
	@echo '     make pythonpackage-setup    install python packages'
	@echo '     make dotfiles               link dotfiles (.functions, .aliases, motd)'
	@echo '     make hyper                  setup hyper (terminal emulator) and preferences'
	@echo '     make hyper-backup           make backup of hyper preferences'
	@echo '     make zsh                    set up preferences for the zsh shell'
	@echo '     make zsh-backup             make backup of zsh preferences'
	@echo '     make git                    set up git to use ssh and configure the git settings'
	@echo '     make git-backup             make backup of git settings'
	@echo '     make git-check-params       check that git parameters are set correctly'





# VARIABLES
GO_VERSION = 1.17.6
BREW := $(shell which brew > /dev/null)
OS := $(shell uname)
DOTFILE_FOLDER := ~/.dotfiles
DOTFILE_SOURCE := ~/github/pni-dotfiles



all:
ifeq ($(OS),Darwin)
	@echo "Running Makefile for MacOS"
	$(MAKE) macos
	$(MAKE) non-os-specific
else
	@echo "This will only work on a MacOS machine"
endif 
	

non-os-specific: nodepackage-setup pythonpackage-setup dotfiles git hyper zsh 

$(BREW):
	@echo "Installing Homebrew..."
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
	@echo "Installing Homebrew Bundle"
	brew tap Homebrew/bundle
	@echo "Installing applications via Homebrew and Cask..."

macos: $(BREW)
	@echo 'Updating brew'
	brew update
	brew bundle

nodepackage-setup: 
	@echo 'Setting up packages for node'
	npm install -g typescript prettier create-react-app create-react-native-app yarn spaceship-prompt

pythonpackage-setup:
	@echo 'Setting up packages for python'
	pip3 install speedtest-cli virtualenv
	pip3 install thefuck --user

dotfiles:
	@echo 'Setting up dotfiles directory'	
	mkdir -p $(DOTFILE_FOLDER)
	./insert.sh .aliases insert_aliases
	./insert.sh .functions insert_functions
	@echo 'symlinking $(DOTFILE_FOLDER)'
ifneq ($(wildcard $(DOTFILE_FOLDER)/.),)
	@echo 'dotfile folder already exists'
else
	ln -s $(DOTFILE_SOURCE) $(DOTFILE_FOLDER)
endif 

hyper: hyper-backup
	@echo 'Setting up hyper'
ifneq ($(wildcard $(DOTFILE_FOLDER)/.hyper.js),) 
	ln -s $(DOTFILE_FOLDER)/.hyper.js ~/.hyper.js
endif

hyper-backup:
	@echo 'Backing up hyper'
ifneq ($(wildcard ~/.hyper.js),) 
	mv ~/.hyper.js ~/.hyper.js.bak
endif 

zsh: zsh-backup 
	git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
	git clone --recurse-submodules https://github.com/belak/prezto-contrib ~/.zprezto/contrib
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
ifneq ($(wildcard $(DOTFILE_FOLDER)/.zshrc),) 
	ln -s $(DOTFILE_FOLDER)/.zshrc ~/.zshrc
endif
ifneq ($(wildcard $(DOTFILE_FOLDER)/.zpreztorc),) 
	ln -s $(DOTFILE_FOLDER)/.zpreztorc ~/.zpreztorc
endif 

zsh-backup:
	@echo 'Backing up zsh'
ifneq ($(wildcard ~/.zshrc),) 
	mv ~/.zshrc ~/.zshrc.bak
endif 
ifneq ($(wildcard ~/.zpreztorc),) 
	mv ~/.zpreztorc ~/.zpreztorc.bak
endif 
ifneq ($(wildcard ~/.zprezto/README.md),) 
	rm -rf ~/.zprezto
endif
ifneq ($(wildcard ~/.zsh/zsh-autosuggestions),) 
	rm -rf ~/.zsh/zsh-autosuggestions
endif

# set up git globabls
git: git-check-params git-backup
	@echo 'Setting up gitignore'
ifneq ($(wildcard $(DOTFILE_FOLDER)/.gitignore_global),) 
	ln -s $(DOTFILE_FOLDER)/.gitignore_global ~/.gitignore_global
endif 

	@echo 'Setting up github ssh'
	git config --global --add url."git@github.com:".insteadOf "https://github.com/"
	git config --global user.name "${GITHUB_NAME}"
	git config --global user.email ${GITHUB_EMAIL}
	git config --global core.excludesFile ~/.gitignore_global 
	./github_ssh.sh ${GITHUB_EMAIL}

git-backup:
	@echo 'Backing up gitignore'
ifneq ($(wildcard ~/.gitignore_global),) 
	mv ~/.gitignore_global ~/.gitignore_global.bak
endif 
	@echo 'Backing up gitconfig'
ifneq ($(wildcard ~/.gitconfig),) 
	mv ~/.gitconfig ~/.gitconfig.bak
endif

git-check-params:
	test -n "${GITHUB_EMAIL}" # $$GITHUB_EMAIL is required
	test -n "${GITHUB_NAME}" # $$GITHUB_NAME is required
