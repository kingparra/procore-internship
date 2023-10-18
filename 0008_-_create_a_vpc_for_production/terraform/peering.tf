# Look up the id of DEV-VPC based on its CIDR and tags.
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

# Create a peering connection between the prod and dev vpcs.
resource "aws_vpc_peering_connection" "a_to_b_px" {
  vpc_id = module.vpc.vpc_id # requester
  peer_vpc_id = data.aws_vpc.dev_vpc.id # accepter
  # Since both VPCs are owned by the same account we can
  # set this to allow the peering request from DEV-VPC.
  auto_accept = true
}

# Add route to dev to all prods route tables
resource "aws_route" "prod_to_dev" {
  # Since the values for this for_each cannot be known until the vpc module has been created,
  # you have to run 'terraform apply -target module.vpc first, and then 'terraform apply' again.
  for_each = setunion(module.vpc.public_route_table_ids, module.vpc.private_route_table_ids)
  route_table_id = each.value
  destination_cidr_block = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.a_to_b_px.id
}

# List route tables for DEV-VPC
data "aws_route_tables" "dev_rts" {
  vpc_id = data.aws_vpc.dev_vpc.id
  filter {
    name = "tag:TicketName"
    values = [ "0007_-_create_a_vpc_for_development" ]
  }
}

# Create route to prod from all of devs route tables
resource "aws_route" "dev_to_prod" {
  for_each = toset(data.aws_route_tables.dev_rts.ids)
  route_table_id = each.value
  destination_cidr_block = "10.2.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.a_to_b_px.id
}