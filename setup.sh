#!/bin/bash
echo "Setting everything up from the Github Repo"
mkdir -p ~/github/patrickjmcd
git clone https://github.com/meshifyiot/pni-dotfiles ~/github/pni-dotfiles
cd ~/github/pni-dotfiles

# setup github email address
if [ -z "$GITHUB_EMAIL" ]
then
    echo Please enter the email address you use for Github:
    read email
    export GITHUB_EMAIL=$email
fi

# setup github name
if [ -z "$GITHUB_NAME" ]
then
    echo Please enter the FirstName and LastName you use for Github:
    read name
    export GITHUB_NAME=$name
fi

# run the makefile
make all
