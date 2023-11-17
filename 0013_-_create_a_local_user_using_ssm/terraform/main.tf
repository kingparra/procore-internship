resource "aws_ssm_document" "create_linux_user" {
  name = "create_linux_user"
  document_type = "Command"
  document_format = "YAML"
  content = file("${module.path}../ssm_doc/doc.yaml")
}