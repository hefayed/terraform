terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.67.0"
    }
  }
}


data "aws_subnets" "ngw-subnet" {
  filter {
    name   = "tag:Name"
    values = [for key, value in var.subnet_id : key if length(regexall("public-1a", key)) > 0]
  }
}

resource "aws_eip" "public" {
  vpc = true
}


# Create a nat gw
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.public.id
  subnet_id     = data.aws_subnets.ngw-subnet.ids[0]
  tags = {
    Name = "ngw-private"
  }
}
