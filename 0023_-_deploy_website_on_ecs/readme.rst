**********************************
 Ticket 23. Deploy website on ECS
**********************************
Deploy a clients website using a container in ECS using  code stored on a EFS file system.
The client is requesting a container for their website, so for this we would use ECS to deploy the website.

* Use ECS to host the website
* Use existing EFS filesystem you created for the bastion hosts
* Use the provided json document to create the task description

`Tutorial: Using Amazon EFS file systems with Amazon ECS using the console - Amazon Elastic Container Service
<https://docs.aws.amazon.com/AmazonECS/latest/developerguide/tutorial-efs-volumes.html>`_

Sub Task 1. Download the website code from s3
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Download the code from the s3 bucket below and then copy it to the efs filesystem you created for the bastion host.
The website code is in this zip file:

https://ariclaw-website.s3.amazonaws.com/ariclaw-master.zip
Unzip it and move to the EFS filesystem you created before under a directory called efs-html.

Sub Task 2. Deploy a ec2 cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Create a EC2 cluster with one ec2 instance (t2.micro).
Navigate to the ECS console and create a EC2 cluster with one EC2 instance that will host the clients website. Try to always use the classic console experience.

Sub Task 3. Use the prod-vpc (use the default settings) for the cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Configure the VPC for your container instances to use. A VPC is an isolated portion of the AWS cloud populated by AWS objects, such as Amazon EC2 instances. Use only two subnets.
For this you just need to select the option create new vpc from the ECS console.

Sub Task 4. Create a task definition
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Create a Task Definition for the EC2 cluster using the following json code below.
Task definitions specify the container information for your application, such as how many containers are part of your task, what resources they will use, how they are linked together, and which host ports they will use.

Use the EC2 option. On the Configure task and container definitions screen, look for the Configure with json button, click on it and replace the json information with the on provided here.

USE CLASSIC CONSOLE EXPERIENCE TO SEE OPTION TO USE JSON

::

  {
    "containerDefinitions": [
      {
        "memory": 128,
        "portMappings": [
          {
            "hostPort": 80,
            "containerPort": 80,
            "protocol": "tcp"
          }
        ],
        "essential": true,
        "mountPoints": [
          {
            "containerPath": "/usr/share/nginx/html",
            "sourceVolume": "efs-html"
          }
        ],
        "name": "nginx",
        "image": "nginx"
      }
    ],
    "volumes": [
      {
        "name": "efs-html",
        "efsVolumeConfiguration": {
          "fileSystemId": "fs-1324abcd",
          "transitEncryption": "ENABLED"
        }
      }
    ],
    "family": "efs-tutorial"
  }

NOTE: replace the fileSystemId with the ID of your Amazon EFS file system.

Sub Task 5. Test your website.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Run the task definition and locate the public ip of the container to test the new website thats running on ECS.
Provide screenshot of the website.

