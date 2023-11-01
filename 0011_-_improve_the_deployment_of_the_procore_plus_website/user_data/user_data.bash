#!/usr/bin/env bash
set -x # use journalctl -u cloud-final to see the logs
yum install -y python3-pip git httpd wget ruby

# Install the CodeDeploy agent
wget 'https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install'
chmod u+x install
./install auto # this enables codedeploy-agent.service
systemctl is-active codedeploy-agent.service

# You need the AWSCodeCommitPowerUser policy to clone with git-remote-codecommit.
python3 -m venv .venv-procore-website
source .venv-procore-website/bin/activate
pip install git-remote-codecommit
git clone codecommit::us-east-1://procore-website /var/www/html/

systemctl enable --now httpd