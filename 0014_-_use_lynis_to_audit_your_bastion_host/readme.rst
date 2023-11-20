*************************************************
 Ticket 14. Use Lynis to audit your bastion host
*************************************************




Requirements
------------
Update the userdata script on the Bastion to Install
Lynis and then use SSM to schedule a Lynis Scan the
Bastion.

Modify the userdata script to install lynis on your bastion host
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Install Lynis in your bastion host so you can scan your
host for vulnerabilities. Provide the path of the
binary you installed.

Manage your Bastion host with SSM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Configure the Bastion hosts to be managed by Systems
Manager.

Use run command and automate the process
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Scan your bastion host with Lynis using Run Command and
also automate the process.

The audit scan should be scheduled to run every 2 days
at 12:00 PM and the output should be sent to a
directory call /Audit_Reports in the EFS filesystem
mounted on the instance.

Provide screenshots of the steps to make this happen.




Implementation
--------------

Modify the userdata script to install lynis on your bastion host
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This line was added to the userdata script in the
``0012*/user_data`` directory.

::

  amazon-linux-extras install -y lynis

The binary was installed to ``/usr/bin/lynis``. You can
use the ``rpm -ql lynis`` command to list all files in
the package and where they were installed to.


Manage your Bastion host with SSM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A role with permissions for SSM to manage the hosts was
added to the bastion-hosts instance profile.

::

  data "aws_iam_role" "ssm_setup" {
    name = "AmazonSSMRoleForInstancesQuickSetup"
  }

  resource "aws_iam_instance_profile" "bastion_profile" {
    name = "bastion_host_instance_profile"
    role = data.aws_iam_role.ssm_setup.id
  }

Use run command and automate the process
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create an s3 bucket to store logs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Create an s3 bucket to store logs from the runCommand
  actions. Make a note of the bucket, you will need it
  when creating an association.

Create a change calendar
~~~~~~~~~~~~~~~~~~~~~~~~
* Go to Systems Manager > Change Management > Change Calendar.
* Click on Create Calendar.

Create a command document
~~~~~~~~~~~~~~~~~~~~~~~~~
The different types of documents are explained here:
https://docs.aws.amazon.com/systems-manager/latest/userguide/documents.html

* Go to Systems Manager > Shared Resources > Documents.
* Click on Create Document > Command or Session.
* Name: lynis_scan, 
  Target type: AWS::EC2::Instance,
  Document type: Command,
  Content: ... aws:runShellScript

Create an association in State Manager
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Go to Systems Manager > Node Management > State Manager.
* Click on Create Association.
* Under Specify schedule, choose Rate schedule builder,
  and set it to run the assocation every 2 days.

