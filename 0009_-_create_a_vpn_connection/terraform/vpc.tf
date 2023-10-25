## AWS cloud VPC
module "cloud_vpc" {
  name = "tf_vpn_test_cloud_vpc"
  source = "terraform-aws-modules/vpc/aws"
  cidr = "10.3.0.0/16"
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.3.101.0/24", "10.3.102.0/24"]
  private_subnets = ["10.3.1.0/24", "10.3.2.0/24"]
   # Default behaviour is one nat gateway per subnet.
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  # Control the default NACL associated with every subnet
  manage_default_network_acl = true
  # Use seperate NACLs for the public subnets
  public_dedicated_network_acl = true
  # Use seperate NACLs for the private subnets
  private_dedicated_network_acl = true
  # Assign public ips to new instance launched into public subnets
  map_public_ip_on_launch = true
}

## On-prem VPC
module "onprem_vpc" {
  name = "tf_vpn_test_onprem_vpc"
  source = "terraform-aws-modules/vpc/aws"
  providers = {
    aws = aws.personal
  }
  cidr = "10.4.0.0/16"
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.4.101.0/24", "10.4.102.0/24"]
  private_subnets = ["10.4.1.0/24", "10.4.2.0/24"]
 # Default behaviour is one nat gateway per subnet.
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  # Control the default NACL associated with every subnet
  manage_default_network_acl = true
  # Use seperate NACLs for the public subnets
  public_dedicated_network_acl = true
  # Use seperate NACLs for the private subnets
  private_dedicated_network_acl = true
  # Assign public ips to new instance launched into public subnets
  map_public_ip_on_launch = true
}
