# provisioner "file" {
#   source = templatefile(
#     "${path.module}/templates/userdata.bash.tftpl",
#     {
#     tunnel1_address = aws_vpn_connection.vpn.tunnel1_address,
#     tunnel2_address = aws_vpn_connection.vpn.tunnel2_address,
#     onsite_cidr = module.onprem_vpc.vpc_cidr_block,
#     offsite_cidr = module.cloud_vpc.vpc_cidr_block,
#     tunnel_outside_address = aws_vpn_connection.vpn.outside_ip_address,
#     tunnel1_preshared_key = aws_vpn_connection.vpn.tunnel1_preshared_key
#   })
#   destination = "${path.module}/userdata/userdata.bash"
# }