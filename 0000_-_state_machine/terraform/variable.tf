variable "ticket_names" {
  type = list(string)
  description = "A list of ticket number and name combinations like 0000_-_ticket_title format. Will be used to generate a bucket."
  default = [ 
    "0007_-_create_a_vpc_for_development",
  ]
}