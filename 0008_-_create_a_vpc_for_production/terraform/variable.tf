variable "ticket_name" {
  default = "0008_-_create_a_vpc_for_production"
}

variable "vpc_name_prefix" {
  type = string
  default = "PROD-VPC"
  description = "All resources created by this module will be be prepended with prefix, in this form: {prefix}-{resource_name}."
}


variable "labname" {
  type = string
  default = "Mod8.5Project2"
  description = "A name used for the Lab = $val tag."
  validation {
    condition = length(var.labname) > 3  && can(regex("^[0-9A-Za-z\\.]+$", var.labname))
    error_message = "Must be longer than 3 characters, and only alphanumeric characters or dots. PascalCase is preferred."
  }
}

variable "vpc_cidr" {
  type = string
  default = "10.2.0.0/16"
}

variable "azs" {
  type = list(string)
  description = "The list of AZs that each subnet will reside in."
  default = [
    "us-east-1a",
    "us-east-1b",
    # "us-east-1c",
    # "us-east-1d",
    # "us-east-1e",
    # "us-east-1f"
    ]
}

# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.2.0.0&mask=16&division=39.f46455d231
variable "public_subnets_cidrs" {
  type = list(string)
  description = "CIDRs for each public subnet."
  # at least 200 hosts per subnet
  default = [
    "10.2.0.0/20",
    "10.2.16.0/20",
    # "10.2.32.0/20",
    # "10.2.48.0/20",
    # "10.2.64.0/20",
    # "10.2.80.0/20",
  ]
}

variable "private_subnets_cidrs" {
  type = list(string)
  description = "CIDRs for each private subnet."
  # no more than 62 hosts per subnet
  default = [
    "10.2.254.128/26",
    "10.2.254.192/26",
    # "10.2.255.0/26",
    # "10.2.255.64/26",
    # "10.2.255.128/26",
    # "10.2.255.192/26",
  ]
}