#!/bin/bash
set -x
repo_url="https://github.com/appychipDevOps/CICD-demo.git"
repo_folder="app"
branch="develop"
cd ~
# Check if the repository folder already exists
if [ -d "$repo_folder" ]; then
    # If it exists, perform a git pull to get the latest changes
    cd "$repo_folder"
    git pull origin "$branch"
    npm install
    pm2 restart all
    cd ..
else
    # If it doesn't exist, clone the repository
    git clone -b "$branch" "$repo_url" "$repo_folder"
    cd "$repo_folder"
    npm install
    pm2 start "npm start"
fi