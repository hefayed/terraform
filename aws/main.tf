terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source     = "../modules/vpc"
  for_each   = var.vpc
  cidr_block = each.value.cidr_block
  name       = each.value.name
}
module "vpc_subnets" {
  vpc_id                  = module.vpc[each.value.vpc].vpc_id
  source                  = "../modules/vpc_subnets"
  for_each                = var.vpc_subnets
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  subnet_tag              = each.value.tag
  ipv6_cidr_block         = cidrsubnet(module.vpc[each.value.vpc].ipv6_pool, 8, each.value.netnum)
  map_public_ip_on_launch = length(regexall("public-1[abc]", each.value.tag)) > 0 ? true : false
  depends_on              = [module.vpc]
}

module "igw" {
  source   = "../modules/igw"
  for_each = var.igw
  vpc_id   = module.vpc[each.value.vpc].vpc_id
  igw_name = each.value.igw_name
  depends_on = [
    module.vpc_subnets, module.vpc
  ]
}



module "route_table_public" {
  source                 = "../modules/route_table_public"
  route_table_id         = module.vpc["prod"].main_route_table_id
  subnet_id              = var.vpc_subnets
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.igw["prod"].igw_id
  depends_on = [
    module.vpc_subnets, module.vpc
  ]
}

module "route_table_private" {
  source                   = "../modules/route_table_private"
  vpc_id                   = module.vpc["prod"].vpc_id
  subnet_id                = var.vpc_subnets
  destination_cidr_block   = "0.0.0.0/0"
  private_route_table_name = "private"
  nat_gateway_id           = module.ngw.ngw_id
  depends_on = [
    module.vpc_subnets, module.vpc
  ]
}

module "ngw" {
  source    = "../modules/ngw"
  subnet_id = var.vpc_subnets
  depends_on = [
    module.vpc_subnets, module.vpc
  ]
}

module "security_group" {
  source                   = "../modules/security_group"
  vpc_id                   = module.vpc["prod"].vpc_id
  inbound_IPv4_CIDR_Blocks = "0.0.0.0/0"
  inbound_IPv6_CIDR_Blocks = "::/0"
}

module "ec2-public" {
  source             = "../modules/ec2"
  for_each           = var.ec2_public
  security_group_ids = module.security_group.aws_sg_allow_web
  subnet_id          = var.vpc_subnets
  my_subnet          = each.value.my_subnet
  instance_type      = each.value.instance_type
  instance_tag       = each.value.instance_tag
  inline_cmd         = each.value.inline_cmd
  depends_on = [
    module.vpc_subnets, module.vpc, module.route_table_public
  ]
}

/* module "ec2-private" {
  source             = "../modules/ec2"
  security_group_ids = module.security_group.aws_sg_internal_access
  subnet_id          = var.vpc_subnets
  instance_type      = "t2.micro"
  instance_tag       = "app"
  depends_on = [
    module.vpc_subnets, module.vpc, module.route_table_private
  ]
} */
