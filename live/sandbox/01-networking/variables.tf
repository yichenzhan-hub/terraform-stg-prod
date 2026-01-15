variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "run_region" {
  type = string
}



variable "vpc_name" { default = "yichen-vpc" } # Manually created VPC name
variable "subnet_cidr" { default = "10.55.0.0/24" } # Client's subnet range
variable "secondary_ip_ranges" { default = [] }
variable "subnet_name" {
  description = "The name of the subnet (used if using an existing network)"
  type        = string
  default     = "yichen-vpc-subnet" # Set this to your actual subnet name if known, or handle in tfvars
}

variable "connector_name" { default = "yichen-vpc-connector" }
variable "connector_cidr" { default = "10.8.0.0/28" }

variable "nat_ip_name" { default = "sms-gw-nat-ip" }

variable "create_network" { default = false }
