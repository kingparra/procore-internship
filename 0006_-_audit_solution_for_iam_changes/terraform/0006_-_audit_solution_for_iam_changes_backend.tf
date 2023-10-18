terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "0006-auditsolutionforiamchanges-state"
    key            = "terraform.tfstate"
    dynamodb_table = "0006-auditsolutionforiamchanges-state-lock"
    profile        = ""
    encrypt        = "true"
  }
}
