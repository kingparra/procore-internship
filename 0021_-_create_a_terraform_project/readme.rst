Ticket 21. Create a terraform project
*************************************
Create a terraform project that will deploy a
Wordpress website with a RDS Mysql database
in the backend.

Requirements:

* Setup a S3 backend for terraform. Follow
  the process describe in this link:
  https://technology.doximity.com/articles/terraform-s3-backend-best-practices

* The EC2 instance should always use the
  latest amazon 2 linux ami.

* Everything should be done in the prod VPC.

* EC2 should allow SSH traffic from
  everywhere.

* Ec2 and RDS connectivity.

* The RDS security group should only allow
  communication from the EC2 SG.

* The output of the terraform deployment
  should be the public IP of the instance.

The dev team did supply us with the userdata
script that is ready to use, which you can
view in ``./user_data/user_data.bash``.

For the previous userdata script to work, use
this block to call your script in terraform.

::

  data "template_file" "user_data" {
    template = file("userdata.sh")
    vars = {
      db_username      = var.database_user
      db_user_password = var.database_password
      db_name          = var.database_name
      db_RDS           = aws_db_instance.wordpressdb.endpoint
    }
  }

Dont forget to reference this file using this
line in your EC2 instance code.

::

  user_data = data.template_file.user_data.rendered

Provide  URL of the Wordpress for verification.

After upload your code to your GitLab Repo.
