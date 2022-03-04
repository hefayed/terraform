variable "aws_region" {
  type      = string
  sensitive = true
}

variable "vpc" {
  description = "VPC lets you provision a logically isolated section of the Amazon Web Servces (AWS) cloud "
  type = map(object({
    cidr_block = string
    name       = string
  }))
}


variable "vpc_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    tag               = string
    vpc               = string
    netnum            = number
  }))
}

variable "igw" {
  type = map(object({
    vpc                    = string
    igw_name               = string
    destination_cidr_block = string
  }))
}

variable "ec2_public" {
  type = map(object({
    my_subnet     = string
    instance_type = string
    instance_tag  = string
    inline_cmd    = list(string)
  }))
}
