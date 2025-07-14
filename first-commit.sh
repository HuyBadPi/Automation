#!/bin/bash
YourName="Tran Huy"
YourEmail="tranhuylqd@gmail.com"
YourRepo="https://github.com/HuyBadPi/Automation.git"
Directory=~/automatique

cd $Directory
echo "# Automation" >> README.md
git init
git add README.md
git config --global user.email "$YourEmail"
git config --global user.name "$YourName"
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin "$YourRepo"
git push -u origin main

echo "First commit completed successfully!"