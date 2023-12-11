variable "ticket_name" {
  default = "0021_-_create_a_terraform_project"
}

variable "vpc_id" {
  default = "vpc-0c4a10f9e59a1c7e1"
}

variable "public_subnet_1" {
  default = "subnet-039bbc950d4729739"
}

variable "private_subnet_1" {
  default = "subnet-0fd025195ace63cb0"
}

variable "private_subnet_2" {
  default = "subnet-0c84d40fc4ae6670a"
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default = "wordpress"
}

variable "db_username" {
  description = "The administrative MySQL DB user name."
  type        = string
  default = "admin"
}

variable "db_user_password" {
  description = "Password for the MySQL user."
  type        = string
  sensitive   = true
}

variable "key_pair_name" {
  default = "precision-procore"
}
