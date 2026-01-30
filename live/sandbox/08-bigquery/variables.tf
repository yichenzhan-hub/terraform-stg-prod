variable "project" {
  type = string
}

variable "region" {
  type = string
}

# NEW: Dynamic Environment Variable
variable "environment" {
  description = "The environment name (e.g., sandbox, staging, prod)"
  type        = string
}