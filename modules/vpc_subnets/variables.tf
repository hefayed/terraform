variable "vpc_id" {
  type      = string
  sensitive = true
}

variable "cidr_block" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "subnet_tag" {
  type = string
}

variable "map_public_ip_on_launch" {
  type = bool
}

variable "ipv6_cidr_block" {
  type = string
}
