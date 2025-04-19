module "vpc" {
  source  = "aws-ia/vpc/aws"
  version = ">= 4.2.0"

  name       = "alb-example"
  cidr_block = var.vpc_cidr
  az_count   = 2

  subnets = {
    public = { netmask = 24 }
  }
}