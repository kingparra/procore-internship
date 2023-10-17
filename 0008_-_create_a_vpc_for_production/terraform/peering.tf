data "aws_vpc" "dev_vpc" {
  filter {
    name = "cidr"
    values = [ "10.1.0.0/16" ]
  }
  filter {
    name = "tag:Name"
    values = [ "DEV-VPC" ]
  }
  filter {
    name = "tag:Client"
    values = [ "procore" ]
  }
  filter {
    name = "tag:Env"
    values = [ "dev" ]
  } 
  filter {
    name = "tag:TicketName"
    values = [ "0007_-_create_a_vpc_for_development" ]
  }
}


resource "aws_vpc_peering_connection" "a_to_b_px" {
  peer_vpc_id = data.aws_vpc.dev_vpc.id 
  vpc_id = module.vpc.vpc_id
  auto_accept = true
}
