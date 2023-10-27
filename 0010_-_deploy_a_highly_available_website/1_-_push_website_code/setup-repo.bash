#!/usr/bin/env bash

## Create a repo and upload the files from s3
aws codecommit create-repository --repository-name procore-website
mkdir -p ~/Projects && cd ~/Projects
git clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/procore-website
cd procore-website
wget 'https://procoreplusproductwebsite.s3.amazonaws.com/procore-website-master.zip'
unzip procore-website-master.zip
mv procore-website-master/* .
rm -rf procore-website-master.zip procore-website-master/
git add .
fatal: bad revision 'HEAD'
git commit -m 'Init repo with existing files'
git push -u origin master
