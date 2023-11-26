Readme
******
These files will dynamically get a list of all instances named ``bastion-host``,
create an inventory of instance ids, and then use SSM to connect to them to execute the playbook.

In order to run the code:

* Install ansible, aws cli, and set up a profile named procore.

* Install session manager pluging for aws cli `link <https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html>`_

* Run ``ansible-galaxy collection install community.aws``

* Execute the playbook by running ``ansible-playbook -i inventory.aws_ec2.yaml playbook.yaml``

