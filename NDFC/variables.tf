
variable "inventory" {
  type = map(object({
    fabric_name : string
    switch_name : list(string)
  }))
}

variable "username" {
  type      = string
  sensitive = true
}

variable "password" {
  type      = string
  sensitive = true
}

variable "url" {
  type = string
}




