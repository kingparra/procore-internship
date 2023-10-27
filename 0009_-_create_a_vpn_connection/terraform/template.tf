locals {
  outside_object = tolist(aws_vpn_connection.vpn.vgw_telemetry)[1]
}

data "template_file" "user_data" {
  template = file(
    "${path.module}/templates/userdata.bash.tftpl")
  vars = {
    leftid = aws_vpn_connection.vpn.tunnel1_vgw_inside_address
    right = aws_vpn_connection.vpn.tunnel1_address
    onsite_cidr = module.onprem_vpc.vpc_cidr_block
    offsite_cidr = module.cloud_vpc.vpc_cidr_block
    tunnel_outside_address = local.outside_object.outside_ip_address
    tunnel1_preshared_key = aws_vpn_connection.vpn.tunnel1_preshared_key
  }
}

output "user_data" {
  value = data.template_file.user_data.rendered
}