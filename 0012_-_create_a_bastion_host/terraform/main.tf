data "aws_vpcs" "prod_vpc_ids" {
  tags = {
    "Name"       = "PROD-VPC"
    "TicketName" = "0008_-_create_a_vpc_for_production"
    "Env"        = "prod"
  }
}

locals {
  vpc_id = data.aws_vpcs.prod_vpc_ids.ids[0]
}

data "aws_subnets" "prod_vpc_private_subnets" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.prod_vpc_ids.ids
  }
  filter {
    name = "tag:Name"
    values = [
      "PROD-VPC-private-subnet-1",
      "PROD-VPC-private-subnet-2",
    ]
  }
}

# elb, tg, listner
resource "aws_lb_target_group" "tg" {
  name     = "bastion-host-tg"
  port     = 22
  protocol = "TCP"
  vpc_id   = local.vpc_id
}

resource "aws_security_group" "nlb" {
  name        = "bastion-host-nlb-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = local.vpc_id
  tags        = { Name = "bastion-host-nlb-sg" }
  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
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

resource "aws_lb" "nlb" {
  name               = "bastion-host-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnets.prod_vpc_private_subnets.ids
  security_groups    = [aws_security_group.nlb.id]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port = "22"
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# efs
module "efs" {
  source  = "cloudposse/efs/aws"
  version = "0.34.0"

  name                       = "bastion-host-efs"
  region                     = "us-east-1"
  vpc_id                     = local.vpc_id
  subnets                    = data.aws_subnets.prod_vpc_private_subnets.ids
  allowed_security_group_ids = [aws_security_group.instances.id]
}

# asg
resource "aws_autoscaling_group" "asg" {
  name = "bastion-host-asg"
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = data.aws_subnets.prod_vpc_private_subnets.ids
  desired_capacity    = 2
  min_size            = 2
  max_size            = 2
  # warmup time of 2560 seconds
  default_instance_warmup = 250
  # attach the alb
  target_group_arns = [aws_lb_target_group.tg.arn ]
  health_check_type = "ELB"
  # This corresponds to checking "enable group metrics collection" in the web ui.
  metrics_granularity = "1Minute"
  enabled_metrics = [
    "GroupPendingInstances",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "WarmPoolPendingCapacity",
    "WarmPoolTerminatingCapacity",
    "GroupTerminatingCapacity",
    "WarmPoolTotalCapacity",
    "GroupPendingCapacity",
    "GroupTerminatingInstances",
    "WarmPoolMinSize",
    "GroupAndWarmPoolDesiredCapacity",
    "GroupTotalInstances",
    "WarmPoolDesiredCapacity",
    "WarmPoolWarmedCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupStandbyCapacity",
    "GroupTotalCapacity",
    "GroupMinSize",
    "GroupStandbyInstances",
  ]
}

# lt
resource "aws_security_group" "instances" {
  name        = "bastion-host-sg"
  description = "Allow SSH and NFS inbound traffic"
  vpc_id      = local.vpc_id
  tags        = { Name = "bastion-host-sg" }
  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "NFS from anywhere"
    from_port        = 2049
    to_port          = 2049
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

resource "aws_launch_template" "lt" {
  name          = "bastion-host-lt"
  image_id      = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  user_data     = filebase64("${path.module}/../user_data/user_data.bash")
  key_name      = var.key_pair_name
  # Set the version of the lt to use to latest
  update_default_version = true
  # iam_instance_profile {
  #   name = aws_iam_instance_profile.deploy.name
  # }
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instances.id]
  }
  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "bastion-host"
    }
  }
}
