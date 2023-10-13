output "policy_document_json" {
  value = data.aws_iam_policy_document.bucket_policy.json
  description = "The policy document object."
}