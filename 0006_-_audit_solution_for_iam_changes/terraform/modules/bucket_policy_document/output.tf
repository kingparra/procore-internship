output "policy_document_json" {
  description = "The policy document object."
  value = data.aws_iam_policy_document.bucket_policy.json
}