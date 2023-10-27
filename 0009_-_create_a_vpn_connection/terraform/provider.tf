terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
}

provider "aws" {
  profile = "procore"
  region = "us-east-1"
  default_tags {
    tags = {
      Client = "procore"
      Env = "test"
      TicketName = var.ticket_name
    }
  }
}

# The on-prem account uses my personal account.
provider "aws" {
  alias = "personal"
  profile = "personal"
  region = "us-east-1"
  shared_credentials_files = [ "/var/home/chris/.aws/credentials" ]
  shared_config_files = [ "/var/home/chris/.aws/config" ]
  default_tags {
    tags = {
      Client = "procore"
      Env = "test"
      TicketName = var.ticket_name
    }
  }
}

# To create a key material for the openswan keypair
provider "tls" {}

# To create user-data script for the openswan instance
provider "template" {}