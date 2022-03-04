
/* variable "az" {
  description = "aws availability zone"
  type        = string
} */

variable "instance_type" {
  type = string
}

variable "instance_tag" {
  type = string
}

variable "subnet_id" {
  type = map(any)
}

variable "security_group_ids" {
  type = string
}


variable "my_subnet" {
  type = string
}

variable "inline_cmd" {
  type = list(string)
}
