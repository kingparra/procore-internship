Readme
******
Here are some example commands to get you started with running
the template from the cli:

::

  aws cloudformation create-stack \
    --stack-name deployProcoreWebsite \
    --template-body file://main.yaml \
    --capabilities CAPABILITY_NAMED_IAM

  aws cloudformation create-change-set \
   --stack-name deployProcoreWebsite \
   --change-set-name target-group-arn \
   --template-body file://main.yaml \
   --capabilities CAPABILITY_NAMED_IAM

  aws cloudformation describe-change-set --change-set-name target-group-arn

  aws cloudformation execute-change-set --change-set-name target-group-arn

  aws cloudformation describe-stack-events --stack-name deployProcoreWebsite

  # This displays the outputs.
  aws cloudformation describe-stacks --stack-name deployProcoreWebsite
