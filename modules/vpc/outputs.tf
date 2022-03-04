output "vpc_id" {
  value = aws_vpc.custom.id
}

output "main_route_table_id" {
  value = aws_vpc.custom.main_route_table_id
}

output "ipv6_pool" {
  value = aws_vpc.custom.ipv6_cidr_block
}

