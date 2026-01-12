variable "vpc_name" {
  type = string
}

variable "region" {
  type = string
}

variable "subnet_name" {
  type    = string
  default = null
}

variable "subnet_cidr" {
  type = string
}

variable "secondary_ip_ranges" {
  type = list(object({
    name = string
    cidr = string
  }))
  default = []
}

variable "routing_mode" {
  type    = string
  default = "GLOBAL"
}

variable "private_google_access" {
  type    = bool
  default = true
}

variable "description" {
  type    = string
  default = null
}
