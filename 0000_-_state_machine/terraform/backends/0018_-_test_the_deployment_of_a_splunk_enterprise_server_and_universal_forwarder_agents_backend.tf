terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "0018-testthedeploymentofasplunkenterpriseserverandunivers-af71e"
    key            = "terraform.tfstate"
    dynamodb_table = "0018-testthedeploymentofasplunkenterpriseserveranduniversalforwarderagents-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
