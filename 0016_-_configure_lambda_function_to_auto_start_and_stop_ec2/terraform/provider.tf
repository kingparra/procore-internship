terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23.1"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Client     = "procore"
      Env        = "prod"
      TicketName = var.ticket_name
    }
  }
}

provider "archive" {}
