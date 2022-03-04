terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.67.0"
    }
  }
}

# Get the list of subnet_ids for public subnets
data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = [for key, value in var.subnet_id : key if length(regexall("public-1[abc]", key)) > 0]
  }
}

# Create a route for public subnets and associate the IGW
resource "aws_route" "public" {
  route_table_id         = var.route_table_id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = var.gateway_id
}


# Associate the public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(var.subnet_id)
  subnet_id      = element(data.aws_subnets.public.ids, count.index)
  route_table_id = var.route_table_id
}
