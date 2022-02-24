#!/bin/bash

GREEN='\033[1;32m'
NC='\033[0m' # No Color

SSH_FILE=~/.ssh/github_ssh
if [ ! -f "$SSH_FILE" ]; then
    ssh-keygen -t ed25519 -C "$1" -f $SSH_FILE
    ./insert.ssh .ssh/config insert_ssh_config
    echo -e "${GREEN}Add the key to your github account: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent${NC}"
else
    echo -e "Github SSH key already exists"
fi

