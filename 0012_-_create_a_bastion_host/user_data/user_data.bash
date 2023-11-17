#!/usr/bin/env bash
yum install -y nfs-utils amazon-efs-utils

cat << EOF >> /etc/fstab
fs-0f865ea3fe6476af2.efs.us-east-1.amazonaws.com:/ /home efs _netdev,noresvport,tls 0 0
EOF

mount -a

cat << EOF > /etc/motd
* * * * * * * * W A R N I N G * * * * * * * * * *
This computer system is the property of ProCore Plus.
It is for authorized use only. By using this system,
all users acknowledge notice of, and agree to comply
with, the Acceptable Use of Information Technology
Resources Policy ("AUP").  Unauthorized or improper
use of this system may result in administrative
disciplinary action, civil charges/criminal penalties,
and/or other sanctions as set forth in the AUP. By
continuing to use this system you indicate your
awareness of and consent to these terms and conditions
of use.  LOG OFF IMMEDIATELY if you do not agree to
the conditions stated in this warning.
* * * * * * * * * * * * * * * * * * * * * * * * *
EOF
