variable "ticket_names" {
  type = list(string)
  description = "A list of ticket number and name combinations like 0000_-_ticket_title format. Will be used to generate a bucket."
  default = [ 
    "0006_-_audit_solution_for_iam_changes",
    "0007_-_create_a_vpc_for_development",
    "0008_-_create_a_vpc_for_production",
    "0009_-_create_a_vpn_connection",
    "0010_-_deploy_a_highly_available_website",
    # 11 uses the same backend as 10
    "0012_-_create_a_bastion_host",
  ]
}
