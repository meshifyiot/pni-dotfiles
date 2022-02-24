#!/bin/bash

if [ -z "$GITHUB_EMAIL" ]
then
    echo Please enter the email address you use for Github:
    read email
    export GITHUB_EMAIL=$email
fi

if [ -z "$GITHUB_NAME" ]
then
    echo Please enter the FirstName and LastName you use for Github:
    read name
    export GITHUB_NAME=$name
fi

make print-email