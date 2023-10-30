data "aws_vpc" "prod_vpc" {
  cidr_block = "10.2.0.0/16"
  tags = {
    "Name"       = "PROD-VPC"
    "TicketName" = "0008_-_create_a_vpc_for_production"
    "Env"        = "prod"
  }
}

data "aws_subnets" "prod_vpc_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.prod_vpc.id]
  }
  filter {
    name = "tag:Name"
    values = [
      "PROD-VPC-public-subnet-1",
      "PROD-VPC-public-subnet-2"
    ]
  }
}

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

resource "aws_security_group" "web" {
  name        = "procore-website-sg"
  description = "Allow HTTP(S) inbound traffic"
  vpc_id      = data.aws_vpc.prod_vpc.id
  tags        = { Name = "procore-website-sg" }
  ingress {
    description      = "TLS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_launch_template" "lt" {
  name                   = "procore-website-lt"
  image_id               = data.aws_ami.amzlinux.id
  instance_type          = "t2.micro"
  user_data              = filebase64("${path.module}/../user_data/user_data.bash")
  key_name               = var.key_pair_name
  # Set the version of the lt to use to latest
  update_default_version = true
  iam_instance_profile {
    name = aws_iam_instance_profile.deploy.name
  }
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.web.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "procore-website"
    }
  }
}

resource "aws_lb" "alb" {
  name = "procore-website-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.web.id ]
  subnets = data.aws_subnets.prod_vpc_public_subnets.ids
  ip_address_type = "ipv4"
}

