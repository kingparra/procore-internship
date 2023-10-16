terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Client = "procore"
      Env = "dev"
      TicketName = "0007_-_create_a_vpc_for_development"
    }
  }
}