data "aws_vpc" "dev_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    "Name"       = "DEV-VPC"
    "TicketName" = "0007_-_create_a_vpc_for_development"
    "Env"        = "dev"
  }
}

data "aws_subnets" "dev_vpc_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dev_vpc.id]
  }
  filter {
    name = "tag:Name"
    values = [
      "DEV-VPC-public-us-east-1a",
      "DEV-VPC-public-us-east-1b"
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
