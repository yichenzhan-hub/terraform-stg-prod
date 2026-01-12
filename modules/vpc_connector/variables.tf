variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "network_self_link" {
  type = string
}

variable "cidr_range" {
  type = string
}

variable "min_instances" {
  type    = number
  default = 2
}

variable "max_instances" {
  type    = number
  default = 10
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "project" {
  type = string
}
