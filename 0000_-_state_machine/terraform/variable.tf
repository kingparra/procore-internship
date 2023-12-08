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
    "0013_-_create_a_local_user_using_ssm",
    # 14 does not have any terraform code
    "0015_-_collect_custom_metrics_from_your_bastion_host",
    "0016_-_configure_lambda_function_to_auto_start_and_stop_ec2",
    "0017_-_use_checkmk_to_monitor_the_service_limits_in_the_companys_account",
    "0018_-_test_the_deployment_of_a_splunk_enterprise_server_and_universal_forwarder_agents",
    # 19 does not have any terraform code
    "0021_-_create_a_terraform_project",
 ]
}
