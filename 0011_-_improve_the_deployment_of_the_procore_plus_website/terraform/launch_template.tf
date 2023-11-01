resource "aws_security_group" "web" {
  name        = "procore-website-sg"
  description = "Allow HTTP(S) inbound traffic"
  vpc_id      = data.aws_vpc.dev_vpc.id
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

resource "aws_launch_template" "lt" {
  name          = "procore-website-lt"
  image_id      = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  user_data     = filebase64("${path.module}/../user_data/user_data.bash")
  key_name      = var.key_pair_name
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
    security_groups             = [aws_security_group.web.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "procore-website"
    }
  }
}
