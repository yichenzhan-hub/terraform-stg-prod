variable "project" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The GCP Region"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., sandbox, prod)"
  type        = string
}

variable "tier" {
  description = "The service tier of the instance (BASIC or STANDARD_HA)"
  type        = string
}

variable "memory_size_gb" {
  description = "Redis memory size in GiB"
  type        = number
}

variable "redis_version" {
  description = "The version of Redis software"
  type        = string
}