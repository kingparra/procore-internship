terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "0010-deployahighlyavailablewebsite-state"
    key            = "terraform.tfstate"
    dynamodb_table = "0010-deployahighlyavailablewebsite-state-lock"
    profile        = ""
    encrypt        = "true"
  }
}
