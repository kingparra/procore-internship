## rds db, db subnet group, db security group, db option group
module "rds_instance" {
  source               = "cloudposse/rds/aws"
  version              = "1.1.0"
  name                 = "wordpress-db"
  vpc_id               = var.vpc_id
  subnet_ids           = [var.private_subnet_1, var.private_subnet_2]
  # The IDs of the security groups from which to allow ingress traffic to the DB instance
  security_group_ids = [ module.wordpress_instance.security_group_id ]
  publicly_accessible  = false
  database_name        = var.db_name
  database_user        = var.db_username
  database_password    = var.db_user_password
  database_port        = 3306
  multi_az             = false
  storage_type         = "gp2"
  allocated_storage    = 20
  storage_encrypted    = false
  engine               = "mysql"
  engine_version       = "8.0.35"
  major_engine_version = "8.0"
  instance_class       = "db.t2.micro"
  db_parameter_group   = "mysql8.0"
}


## instance
data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  # Use Amazon Linux 2 rather than Amazon Linux 2023.
  filter {
    name   = "description"
    values = ["Amazon Linux 2 AMI *"]
  }
}

module "wordpress_instance" {
  source                      = "cloudposse/ec2-instance/aws"
  version                     = "1.1.1"
  name                        = "wordpress"
  ami                         = data.aws_ami.amzlinux.id
  vpc_id                      = var.vpc_id
  subnet                      = var.public_subnet_1
  associate_public_ip_address = true
  assign_eip_address = false
  ssh_key_pair                = var.key_pair_name

  user_data = templatefile(
      "${path.module}/templates/user_data.sh.tftpl",
      {
        db_username      = var.db_username
        db_user_password = var.db_user_password
        db_name          = var.db_name
        db_RDS           = module.rds_instance.instance_endpoint
      }
    )

  security_group_rules = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}
