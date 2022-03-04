terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Create a VPC
resource "aws_vpc" "custom" {
  cidr_block                       = var.cidr_block
  assign_generated_ipv6_cidr_block = true
  instance_tenancy                 = "default"

  tags = {
    Name = var.name
  }
}
