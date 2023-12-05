data "aws_vpcs" "prod_vpc_ids" {
  tags = {
    "Name"       = "PROD-VPC"
    "TicketName" = "0008_-_create_a_vpc_for_production"
    "Client"     = "procore"
    "Env"        = "prod"
  }
}

data "aws_subnets" "prod_vpc_public_subnets" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.prod_vpc_ids.ids
  }
  filter {
    name = "tag:Name"
    values = [
      "PROD-VPC-public-subnet-1",
    ]
  }
}

locals {
  vpc_id          = data.aws_vpcs.prod_vpc_ids.ids[0]
  public_subnet_1 = data.aws_subnets.prod_vpc_public_subnets.ids[0]
}

data "aws_ami" "splunk_enterprise" {
  most_recent = true
  owners      = ["679593333241"]
  filter {
    name   = "name"
    values = ["splunk_AMI_9.1.1_*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "description"
    values = ["Splunk Enterprise 9.1.1 AMI"]
  }
}

data "aws_security_groups" "bastion_host_sgs" {
  tags = {
    Env        = "prod"
    TicketName = "0012_-_create_a_bastion_host"
    Name       = "bastion-host-sg"
  }
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

locals {
  bastion_host_sg = data.aws_security_groups.bastion_host_sgs.ids[0]
}

resource "aws_security_group" "splunk_sg" {
  tags        = { "Name" = "splunk-sg" }
  name        = "splunk-sg"
  vpc_id      = local.vpc_id
  description = "Allow internet access on splunk ports, and access to ssh only from bastion-host-sg."
}

resource "aws_security_group_rule" "splunk-webui-http" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP over port 8000 for Splunk Enterprise web ui."
  security_group_id = aws_security_group.splunk_sg.id
}

resource "aws_security_group_rule" "splunk-api" {
  type              = "ingress"
  from_port         = 8089
  to_port           = 8089
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow API access to the Splunk Enterprise server."
  security_group_id = aws_security_group.splunk_sg.id
}

resource "aws_security_group_rule" "splunk-forwarder-to-data-pipeline" {
  type              = "ingress"
  from_port         = 9997
  to_port           = 9997
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  self              = null
  description       = "Used to send data from a Splunk forwarder to a data pipeline."
  security_group_id = aws_security_group.splunk_sg.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  self              = null
  description       = "Allow HTTPS ingress."
  security_group_id = aws_security_group.splunk_sg.id
}

resource "aws_security_group_rule" "ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  self                     = null
  description              = "Allow SSH ingress only from bstion-host-sg."
  source_security_group_id = local.bastion_host_sg
  security_group_id        = aws_security_group.splunk_sg.id
}

data "aws_iam_instance_profile" "ssm" {
  name = "AmazonSSMRoleForInstancesQuickSetup"
}

resource "aws_instance" "splunk_server" {
  tags = { "Name" = "splunk-enterprise-server" }
  instance_type = "t2.micro"
  ami = data.aws_ami.splunk_enterprise.image_id
  key_name = "precision-procore"
  iam_instance_profile = data.aws_iam_instance_profile.ssm.role_name
  vpc_security_group_ids = [
    aws_security_group.splunk_sg.id,
  ]
  subnet_id = local.public_subnet_1
}
