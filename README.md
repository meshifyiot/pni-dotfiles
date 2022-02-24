# Prototyping and Integration Dotfiles

An opinionated configuration for programs and configurations used by the P&I team.

## Usage

```Shell
curl -L https://raw.githubusercontent.com/meshifyiot/pni-dotfiles/install.sh | /bin/bash
```

## What this does

This script will download the `install.sh` file and run it on your local machine to set up your development environment.

It clones the github repository and runs `make all` on the makefile in the repository.

This will set up:

- Brew, a MacOS package manager, and a set of recommended MacOS applications (see `Brewfile` for a list of packages)
- Node packages
- Python Packages
- Some good aliases and functions to have at your disposal on the command line
- A common Hyper config (terminal emulator)
- ZSH settings and autocomplete stuff
- Git settings, including SSH and configuration

Make sure you read through the entire makefile to be sure you're ready for what it's about to do to you.
