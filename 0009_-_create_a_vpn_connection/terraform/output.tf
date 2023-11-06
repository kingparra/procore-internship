output "private_key" {
  value = tls_private_key.key_contents.private_key_openssh
  sensitive = true
}

output "openswan_ip" {
  value = aws_instance.openswan.public_ip
}

output "cloud_vpc_cidr" {
  value = module.cloud_vpc.vpc_cidr_block
}

output "onprem_vpc_cidr" {
  value = module.onprem_vpc.vpc_cidr_block
}