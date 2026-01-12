variable "service_name" {
  type = string
}

variable "region" {
  type = string
}

variable "image" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "env_vars" {
  description = "List of env var objects. Each item should be { name=string, value=optional(string), secret=optional(string), secret_version=optional(string) }"
  type        = list(any)
  default     = []
}

variable "vpc_connector" {
  type = string
}

variable "vpc_egress" {
  type    = string
  default = "PRIVATE_RANGES_ONLY"
}

variable "service_account" {
  type    = string
  default = null
}

variable "timeout_seconds" {
  type    = number
  default = 300
}

variable "annotations" {
  type    = map(string)
  default = {}
}

variable "allow_unauthenticated" {
  type    = bool
  default = true
}
