# data "aws_vpcs" "dev_vpc_ids" {
#   tags = {
#     "Name"       = "DEV-VPC"
#     "TicketName" = "0007_-_create_a_vpc_for_development"
#     "Env"        = "dev"
#   }
# }

# locals {
#   vpc_id = data.aws_vpcs.dev_vpc_ids.ids[0]
#   public_subnet_1 =  data.aws_subnets.dev_vpc_public_subnets.ids[0]
# }

# data "aws_subnets" "dev_vpc_public_subnets" {
#   filter {
#     name   = "vpc-id"
#     values = data.aws_vpcs.dev_vpc_ids.ids
#   }
#   filter {
#     name = "tag:Name"
#     values = [
#       "DEV-VPC-public-us-east-1a",
#     ]
#   }
# }

# data "aws_ami" "amzlinux" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm*"]
#   }
#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
#   # Use Amazon Linux 2 rather than Amazon Linux 2023.
#   filter {
#     name   = "description"
#     values = ["Amazon Linux 2 AMI *"]
#   }
# }

# resource "aws_security_group" "instances" {
#   name        = "lambda-test-instance-sg"
#   description = "Allow SSH and NFS inbound traffic"
#   vpc_id      = local.vpc_id
#   tags        = { Name = "bastion-host-sg" }
#   ingress {
#     description      = "SSH from anywhere"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_instance" "test_instance" {
#   count = 3
#   ami = data.aws_ami.amzlinux.id
#   vpc_security_group_ids = [
#     aws_security_group.instances.id
#   ]
#   instance_type = "t2.micro"
#   subnet_id = local.public_subnet_1
#   tags = {
#     Name = "lambda-test-instance"
#     AutoOff = "True"
#     AutoOn = "True"
#   }
# }

# resource "aws_resourcegroups_group" "instances" {
#   name = "lambda-test-instances"
#   resource_query {
#     query = <<-JSON
#       {
#         "ResourceTypeFilters": [
#           "AWS::EC2::Instance"
#         ],
#         "TagFilters": [
#           {
#             "Key": "Name",
#             "Values": ["lambda-test-instance"]
#           },
#           {
#             "Key": "AutoOff", "Values": ["True"]
#           },
#           {
#             "Key": "AutoOn", "Values": ["True"]
#           }
#         ]
#       }
#       JSON
#   }
# }
