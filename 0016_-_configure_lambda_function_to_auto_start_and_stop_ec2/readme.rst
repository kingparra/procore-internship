*****************************************************************
 Ticket 16. Configure lambda function to auto start and stop EC2
*****************************************************************


Requirements
------------
Configure a Lambda Function that Starts & Stops EC2
Instances in your account (script provided)

Problem Statement: Procore Plus management is looking
into ways to cut operations costs. They are aware that
most of ProCore Lab environments are only used during
work hours. They’d like to use a tag to “mark” the
instances that can be shutdown.

Tags for automation: Automation tags are used to opt in
or opt out of automated tasks or to identify specific
versions of resources to archive, update, or delete.
For example, you can run automated start or stop
scripts that turn off development environments during
nonbusiness hours to reduce costs. In this scenario,
Amazon Elastic Compute Cloud (Amazon EC2) instance tags
are a simple way to identify instances to opt out of
this action.


Sub task 1. Create a role that allows Lambda to stop and start the instances
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Lambda needs a role that will allow it to stop and
start EC2 instances in your account. Make sure your
Role does not allow Lambda to perform other activities.

Provide role name and copy of the policy.


Sub task 2. Tag the instances
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Tag the instances that could be turn off during the
specified time period. The tag should be AutoOff=True

Provide screenshot of the tag when applied.


Sub task 3. Configure the auto off lambda functions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Configure the lambda functions with the code below.

::

  #!/usr/bin/env python3
  import boto3
  import logging

  #setup simple logging for INFO
  logger = logging.getLogger()
  logger.setLevel(logging.INFO)

  #define the connection
  ec2 = boto3.resource('ec2')

  def lambda_handler(event, context):
      # Use the filter() method of the instances collection to retrieve
      # all running EC2 instances.
      filters = [{
              'Name': 'tag:AutoOff',
              'Values': ['True']
          },
          {
              'Name': 'instance-state-name',
              'Values': ['running']
          }
      ]

      #filter the instances
      instances = ec2.instances.filter(Filters=filters)

      #locate all running instances
      RunningInstances = [instance.id for instance in instances]

      #print the instances for logging purposes
      #print RunningInstances

      #make sure there are actually instances to shut down.
      if len(RunningInstances) > 0:
          #perform the shutdown
          shuttingDown = ec2.instances.filter(InstanceIds=RunningInstances).stop()
          print("shuttingDown")
      else:
          print("Nothing to see here")

Sub Task 4. Configure the auto on lambda functions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Configure the lambda functions with the code below.

::

  #!/usr/bin/env python3
  import boto3
  import logging

  #setup simple logging for INFO
  logger = logging.getLogger()
  logger.setLevel(logging.INFO)

  #define the connection
  ec2 = boto3.resource('ec2')

  def lambda_handler(event, context):
      # Use the filter() method of the instances collection to retrieve
      # all running EC2 instances.
      filters = [{
              'Name': 'tag:AutoOn',
              'Values': ['True']
          },
          {
              'Name': 'instance-state-name',
              'Values': ['stopped']
          }
      ]

      #filter the instances
      instances = ec2.instances.filter(Filters=filters)

      #locate all stopped instances
      StoppedInstances = [instance.id for instance in instances]

      #print the instances for logging purposes
      #print StoppedInstances

      #make sure there are actually instances to start.
      if len(StoppedInstances) > 0:
          #perform the startup
          startingUp = ec2.instances.filter(InstanceIds=StoppedInstances).start()
          print("startingUp")
      else:
          print("Nothing to see here")

Sub Task 5. Submit proof that the instances are being powered off with Lambda
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Provide proof that the lambda function is working how
it is supposed to. You can check the lambda log and
provide screenshot.


Implementation
--------------
