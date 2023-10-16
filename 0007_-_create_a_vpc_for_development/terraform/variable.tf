variable "vpc_name_prefix" {
  type = string
  default = "dev-vpc"
}

variable "vpc_cidr" {
  type = string
  default = "10.1.0.0/16"
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


variable "public_subnets_cidrs" {
  type = list(string)
  description = "CIDRs for each public subnet."
  # at least 200 hosts per subnet
  default = [
    "10.1.0.0/20",
    "10.1.16.0/20",
    # "10.1.32.0/20",
    # "10.1.48.0/20",
    # "10.1.64.0/20",
    # "10.1.80.0/20",
  ]
}

variable "private_subnets_cidrs" {
  type = list(string)
  description = "CIDRs for each private subnet."
  # no more than 62 hosts per subnet
  default = [
    "10.1.254.128/26",
    "10.1.254.192/26",
    # "10.1.255.0/26",
    # "10.1.255.64/26",
    # "10.1.255.128/26",
    # "10.1.255.192/26",
  ]
}