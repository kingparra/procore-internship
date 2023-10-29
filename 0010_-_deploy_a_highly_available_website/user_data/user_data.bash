#!/usr/bin/env bash

# You need the AWSCodeCommitPowerUser policy to clone with git-remote-codecommit.

yum install -y python3-pip git httpd

python3 -m venv .venv-procore-website

source .venv-procore-website/bin/activate

pip install git-remote-codecommit

git clone codecommit::us-east-1://procore-website /var/www/html/

systemctl enable --now httpd