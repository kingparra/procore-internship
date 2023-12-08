terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "0017-usecheckmktomonitortheservicelimitsinthecompanysacco-2e7be"
    key            = "terraform.tfstate"
    dynamodb_table = "0017-usecheckmktomonitortheservicelimitsinthecompanysaccount-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
