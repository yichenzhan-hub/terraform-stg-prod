variable "project" {
  type = string
}

variable "region" {
  type = string
}

# Cloud SQL: import mode defaults (create_instance = false)
variable "create_instance" { default = false }
variable "instance_name" { default = "cloud-sql-yichen" } # Manually created instance
variable "database_flags" { default = { "cloudsql.enable_pgaudit" = "on" } }
variable "databases" { default = ["dgilbertpostgres","postgres"] } # Client's databases
variable "deletion_protection" { default = false }