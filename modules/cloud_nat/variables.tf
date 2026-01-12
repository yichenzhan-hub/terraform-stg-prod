variable "vpc_name" { type = string }
variable "network_self_link" { type = string }
variable "subnet_self_link" { type = string }
variable "region" { type = string }
variable "nat_ip_names" {
  type    = list(string)
  default = []
}

variable "nat_ip_addresses" {
  type    = list(string)
  default = []
}

variable "nat_ip_allocate_option" {
  type    = string
  default = "MANUAL_ONLY"
}

# variable "source_subnetwork_ip_ranges_to_nat" {
#   type    = string
#   default = "ALL_SUBNETWORKS_ALL_IP_RANGES"
# }

variable "enable_logging" {
  type    = bool
  default = true
}

variable "log_filter" {
  type    = string
  default = "ALL"
}

variable "enable_dynamic_port_allocation" {
  type    = bool
  default = true
}

variable "nat_ip_self_links" {
  type = list(string)
}

variable "subnet_ip_ranges" {
  type = list(string)
}

