terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "0017-testthedeploymentofasplunkenterpriseserverandunivers-0438b"
    key            = "terraform.tfstate"
    dynamodb_table = "0017-testthedeploymentofasplunkenterpriseserveranduniversalforwarderagents-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
