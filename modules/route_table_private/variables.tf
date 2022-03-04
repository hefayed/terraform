variable "vpc_id" {
  type = string
}

variable "private_route_table_name" {
  type = string
}

variable "subnet_id" {
  type = map(any)
}

variable "nat_gateway_id" {
  type = string
}

variable "destination_cidr_block" {
  type = string
}
