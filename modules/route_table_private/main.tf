terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.67.0"
    }
  }
}


# Get the list of subnet_ids for public subnets
data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = [for key, value in var.subnet_id : key if length(regexall("private-1[abc]", key)) > 0]
  }
}


# Create a route table for the private subnets
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.private_route_table_name
  }
}


# Associate the private subnets with the private route table
resource "aws_route_table_association" "private" {
  count          = length(var.subnet_id)
  subnet_id      = element(data.aws_subnets.private.ids, count.index)
  route_table_id = aws_route_table.private.id
}

# Create a route for private subnets and associate the NGW
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id         = var.nat_gateway_id
}
