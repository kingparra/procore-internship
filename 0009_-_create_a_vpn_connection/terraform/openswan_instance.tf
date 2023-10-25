#############################
# AMI for openswan instance
#############################
data "aws_ami" "amzlinux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  # Use Amazon Linux 2 rather than Amazon Linux 2023.
  filter {
    name = "description"
    values = ["Amazon Linux 2 AMI *"]
  }
}

###########################
# Openswan instance
###########################
resource "aws_instance" "openswan" {
  ami = data.aws_ami.amzlinux.id
  provider = aws.personal
  instance_type = "t2.micro"
  associate_public_ip_address = true
  source_dest_check = false # for ip forwarding
  vpc_security_group_ids = [ aws_security_group.openswansg.id ]
  subnet_id = module.onprem_vpc.public_subnets[0]
  user_data_replace_on_change = true # destroy and recreate when user_data changes
  user_data = templatefile(
    "${path.module}/templates/userdata.bash.tftpl",
    {
      tunnel1_address = aws_vpn_connection.vpn.tunnel1_address,
      tunnel2_address = aws_vpn_connection.vpn.tunnel2_address,
      onsite_cidr = module.onprem_vpc.vpc_cidr_block,
      offsite_cidr = module.cloud_vpc.vpc_cidr_block,
      tunnel_outside_address = aws_vpn_connection.vpn.outside_ip_address,
      tunnel1_preshared_key = aws_vpn_connection.vpn.tunnel1_preshared_key
    })
  key_name = "openswan_lab"
  tags = {
    Name = "openswan"
  }
}

#########################
# Openswan security group
#########################
resource "aws_security_group" "openswansg" {
  name = "openswansg"
  provider = aws.personal
  description = "Allow icmp and ssh inbound traffic"
  vpc_id = module.onprem_vpc.vpc_id
}

resource "aws_security_group_rule" "openswansg_allow_ssh_ingress" {
  security_group_id = aws_security_group.openswansg.id
  provider = aws.personal
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "openswansg_allow_icmp_ingress" {
  security_group_id = aws_security_group.openswansg.id
  provider = aws.personal
  # ICMP doesn't have ports, from_port maps to ICMP code fields.
  # https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
  type = "ingress"
  protocol = "icmp"
  from_port = 8 # echo
  to_port = 0
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "openswansg_allow_all_egress" {
  security_group_id = aws_security_group.openswansg.id
  provider = aws.personal
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}