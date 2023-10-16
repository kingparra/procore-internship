terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "0007-createavpcfordevelopment-state"
    key            = "terraform.tfstate"
    dynamodb_table = "0007-createavpcfordevelopment-state-lock"
    profile        = ""
    encrypt        = "true"
  }
}
