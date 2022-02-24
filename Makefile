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
	@echo '     make all					install everything'

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
	$(MAKE) non_os_specific
else
	@echo "This will only work on a MacOS machine"
endif 
	

non_os_specific: nodepackage_setup pythonpackage_setup dotfiles git hyper zsh 

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

nodepackage_setup: 
	@echo 'Setting up packages for node'
	npm install -g typescript prettier create-react-app create-react-native-app yarn spaceship-prompt

pythonpackage_setup:
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

hyper_backup:
	@echo 'Backing up hyper'
ifneq ($(wildcard ~/.hyper.js),) 
	mv ~/.hyper.js ~/.hyper.js.bak
endif 

hyper: hyper_backup
	@echo 'Setting up hyper'
ifneq ($(wildcard $(DOTFILE_FOLDER)/.hyper.js),) 
	ln -s $(DOTFILE_FOLDER)/.hyper.js ~/.hyper.js
endif

zsh_backup:
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

zsh: zsh_backup 
	git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
	git clone --recurse-submodules https://github.com/belak/prezto-contrib ~/.zprezto/contrib
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
ifneq ($(wildcard $(DOTFILE_FOLDER)/.zshrc),) 
	ln -s $(DOTFILE_FOLDER)/.zshrc ~/.zshrc
endif
ifneq ($(wildcard $(DOTFILE_FOLDER)/.zpreztorc),) 
	ln -s $(DOTFILE_FOLDER)/.zpreztorc ~/.zpreztorc
endif 

# set up git globabls
git: check-git-params git-backup
	@echo 'Setting up gitignore'
ifneq ($(wildcard $(DOTFILE_FOLDER)/.gitignore_global),) 
	ln -s $(DOTFILE_FOLDER)/.gitignore_global ~/.gitignore_global
endif 

	@echo 'Setting up github ssh'
	git config --global --add url."git@github.com:".insteadOf "https://github.com/"
	git config --global user.name "${GITHUB_NAME}"
	git config --global user.email ${GITHUB_EMAIL}
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

check-git-params:
	test -n "${GITHUB_EMAIL}" # $$GITHUB_EMAIL is required
	test -n "${GITHUB_NAME}" # $$GITHUB_NAME is required
