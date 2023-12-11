Worklog
*******
Relevant links:

  * Run ansible with terraform
    https://registry.terraform.io/providers/ansible/ansible/latest/docs

  * Create a new Packer channel in HCP Packer Registry
    https://developer.hashicorp.com/packer/tutorials/hcp-get-started/hcp-image-channels

  * Run packer with terraform
    https://registry.terraform.io/providers/toowoxx/packer/latest/docs/resources/image

  * WordPress AMI on AWS Marketplace
    image: https://aws.amazon.com/marketplace/pp/prodview-bzstv3wbn5wkq?sr=0-17&ref_=beagle&applicationId=AWS-EC2-Console
    docs: https://docs.bitnami.com/aws/apps/wordpress/

  * Ansible wordpress_docker on galaxy
    https://galaxy.ansible.com/ui/repo/published/chrissayon/wordpress_docker/

  * Best practices for WordPress on AWS
    https://docs.aws.amazon.com/whitepapers/latest/best-practices-wordpress/welcome.html

  * Reference architecture for WordPress on AWS
    https://github.com/aws-samples/aws-refarch-wordpress

How will the the instance be updated?
-------------------------------------
The ticket does not require the use of a load balancer, but I don't see how you can do updates without downtime.

Review of user_data script
--------------------------
The user_data script looks functional, but messy.

Some questions:

* Do I understand the installation process of WordPress, in general? (No.)

* What does the ImageMagick extension do? Why are we installing it?

* If we're using RDS, why are we installing mysql? (Maybe for the client, to connect?)

* What is a phar file?

  https://en.wikipedia.org/wiki/PHAR_(file_format)

Should I use user_data or bake an AMI?
--------------------------------------
Should I bake an AMI instead of applying the script as user_data at instance creation time?

