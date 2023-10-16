
module "terraform_state_backend" {
  source = "cloudposse/tfstate-backend/aws"
  version = "1.1.1"
  for_each = toset(var.ticket_names)
  name = each.value
  attributes = ["state"]

  terraform_backend_config_file_path = "${path.module}../backends"
  terraform_backend_config_file_name = "${each.value}_backend.tf"
  force_destroy = false
}
