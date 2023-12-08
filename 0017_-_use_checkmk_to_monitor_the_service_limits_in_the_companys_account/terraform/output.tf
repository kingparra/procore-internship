output "access_key_id" {
  value = aws_iam_access_key.key.id
}

output "access_key_secret" {
  value = aws_iam_access_key.key.secret
  sensitive = true
}
