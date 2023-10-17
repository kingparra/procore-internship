# Create the vpc without a ngw.
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
  name = var.vpc_name_prefix
  cidr = var.vpc_cidr
  azs = var.azs
  private_subnets = var.private_subnets_cidrs
  map_public_ip_on_launch = true # public subnets will assign public IP addrs
  public_subnets = var.public_subnets_cidrs
  enable_nat_gateway = false
}

# Create the nat instance in a public subnet and add routes to private RTs.
module "nat" {
  source = "dacut/nat-instance/aws"
  version = "2.2.1"
  name = "main"
  instance_types = ["t2.micro"]
  vpc_id = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnets[0]
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  private_route_table_ids = module.vpc.private_route_table_ids
  use_spot_instance = false
}
