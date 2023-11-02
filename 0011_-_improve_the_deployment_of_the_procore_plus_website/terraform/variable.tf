variable "ticket_name" {
  default = "0010_-_deploy_a_highly_available_website"
}

variable "ticket_name_2" {
  default = "0011_-_improve_the_deployment_of_the_procore_plus_website"
}

variable "key_pair_name" {
  default = "precision-procore"
}

variable "pipeline_name" {
  default = "procore-website"
}

variable "application_name" {
  description = "The name of the CodeBuild appilcation"
  default = "procore-website"
}

variable "deployment_group_name" {
  default = "procore-website-instances"
}