terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "0011-improvethedeploymentoftheprocorepluswebsite-state"
    key            = "terraform.tfstate"
    dynamodb_table = "0011-improvethedeploymentoftheprocorepluswebsite-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
