terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "0009-createavpnconnection-state"
    key            = "terraform.tfstate"
    dynamodb_table = "0009-createavpnconnection-state-lock"
    profile        = ""
    encrypt        = "true"
  }
}
