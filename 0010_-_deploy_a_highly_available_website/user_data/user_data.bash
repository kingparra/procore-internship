#!/usr/bin/env bash

## In order to clone the repo from the
## instances, set up an instance profile
## with a role that has the 
## AWSCodeCommitPowerUser policy attached.

yum install -y python3-pip git httpd

# remote-codecommit will not work when run as root
sudo -u ec2-user python3 -m pip install --user git-remote-codecommit
sudo -u ec2-user git clone codecommit::us-east-1://procore-website ~ec2-user/procore-website

mv ~ec2-user/procore-website/* /var/www/html/
rm -rf ~ec2-user/procore-website