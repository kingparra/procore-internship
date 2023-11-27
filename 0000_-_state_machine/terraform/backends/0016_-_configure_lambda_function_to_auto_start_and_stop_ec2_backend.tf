terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "0016-configurelambdafunctiontoautostartandstopec2-state"
    key            = "terraform.tfstate"
    dynamodb_table = "0016-configurelambdafunctiontoautostartandstopec2-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
