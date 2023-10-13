terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.20"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
