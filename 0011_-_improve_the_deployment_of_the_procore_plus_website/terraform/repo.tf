resource "aws_codecommit_repository" "procore_website" {
  repository_name = var.repo_name
}