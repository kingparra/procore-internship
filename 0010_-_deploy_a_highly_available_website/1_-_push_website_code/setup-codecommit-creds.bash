#!/usr/bin/env bash

## Set up credentials for CodeCommit
ssh-keygen -t rsa -b 4096 -C codecommit -f ~/.ssh/codecommit
ssh-add ~/.ssh/codecommit
aws iam upload-ssh-public-key \
  --user-name Christopher \
  --ssh-public-key-body "file://$HOME/.ssh/codecommit.pub"

key_id="$(aws iam list-ssh-public-keys \
  --query "SSHPublicKeys[?UserName=='Christopher'].SSHPublicKeyId" \
  --output text)"

cat >> ~/.ssh/config << EOF

Host git-codecommit.*.amazonaws.com
  User $key_id
  IdentityFile ~/.ssh/codecommit

EOF

chmod 0600 ~/.ssh/config
ssh git-codecommit.us-east-2.amazonaws.com
