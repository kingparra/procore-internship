output "private_key" {
  value = tls_private_key.key_contents.private_key_openssh
  sensitive = true
}
