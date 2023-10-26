# 1 Create the customer gateway
# Resource which provides information to AWS about your customer gateway device -- the on-prem openswan server.
resource "aws_customer_gateway" "cgw" {
  type = "ipsec.1"
  bgp_asn = 65000
  ip_address = aws_instance.openswan.public_ip
  tags = {
    Name = "onprem_openswan"
  }
}

# 2 Create the virtual private gateway
# The VPN endpoint on the AWS side of your site-to-site VPN.
resource "aws_vpn_gateway" "vpg" {
  vpc_id = module.cloud_vpc.vpc_id
  tags = {
    Name = "onprem_endpoint"
  }
}

# 3 Create the VPN connection
# The connection provides 
resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id = aws_vpn_gateway.vpg.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type = "ipsec.1"
  static_routes_only = true
  tags = {
    Name = "onprem_conn"
  }
}

# 4 Attach the virtual private gateway to the vpc.
# What does attaching the vpg to the vpc actually do?
# This makes it possible to allow route prop on rtbs in the vpc.
resource "aws_vpn_gateway_attachment" "vgw_attach" {
  vpc_id = module.cloud_vpc.vpc_id
  vpn_gateway_id = aws_vpn_gateway.vpg.id
}

# 5 Enable route propagation on all of the rtbs in the offsite vpc.
# This means we can get routes from the vpn endpoint.
resource "aws_vpn_gateway_route_propagation" "prop" {
  for_each = setunion(
    toset([module.cloud_vpc.vpc_main_route_table_id]), # string
    toset(module.cloud_vpc.public_route_table_ids),
    toset(module.cloud_vpc.private_route_table_ids)
  )
  vpn_gateway_id = aws_vpn_gateway.vpg.id
  route_table_id = each.value
}

# 6 Download the configuration from the VPN connection, onprem_conn.
# Actually, get the following inputs and generate a template for the openswan instances user_data.


# # 7 In the onprem vpc, create routes to the cloud vpc.
# resource "aws_route" "rt_to_cloud" {
#   provider = aws.personal
#   # for_each = setunion(
#   #   toset([module.onprem_vpc.vpc_main_route_table_id]),
#   #   toset(module.onprem_vpc.public_route_table_ids),
#   #   toset(module.onprem_vpc.private_route_table_ids)
#   # )
#   route_table_id = module.onprem_vpc.vpc_main_route_table_id
#   destination_cidr_block = module.cloud_vpc.vpc_cidr_block
#   instance_id = aws_instance.openswan.id
# }