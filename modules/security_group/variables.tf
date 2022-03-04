
variable "vpc_id" {
  type      = string
  sensitive = true
}

variable "inbound_IPv4_CIDR_Blocks" {
  type = string
}

variable "inbound_IPv6_CIDR_Blocks" {
  type = string
}
