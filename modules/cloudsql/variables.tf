variable "project" {
  type = string
}

variable "create_instance" {
  type    = bool
  default = false
}

variable "instance_name" {
  type = string
}

variable "region" {
  type = string
}

variable "database_version" {
  type    = string
  default = "POSTGRES_15"
}

variable "tier" {
  type    = string
  default = "db-custom-2-8192" 
}

variable "disk_size" {
  type    = number
  default = 100
}

variable "disk_type" {
  type    = string
  default = "PD_SSD"
}

variable "activation_policy" {
  type    = string
  default = "ALWAYS"
}

variable "availability_type" {
  type    = string
  default = "ZONAL"
}

variable "backup_enabled" {
  type    = bool
  default = false
}

variable "backup_start_time" {
  type    = string
  default = "02:00"
}

variable "ip_v4_enabled" {
  type    = bool
  default = false
}

variable "private_network_self_link" {
  type    = string
  default = ""
}

variable "require_ssl" {
  type    = bool
  default = true
}

variable "database_flags" {
  type    = map(string)
  default = {}
}

variable "databases" {
  type    = list(string)
  default = []
}

variable "deletion_protection" {
  type    = bool
  default = false
}
