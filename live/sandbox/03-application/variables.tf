variable "sa_name" { default = "sms-gw-sa" }
variable "sa_display" { default = "SMS Gateway service account" }

variable "cloudrun_service_name" { default = "poc" }
variable "cloudrun_image" { default = "us-central1-docker.pkg.dev/munvo-sandbox/smsgw-docker/poc@sha256:6683376fa7eef91ec912e4190fe531469221272a05a4dfcf325aa96893c5f4d6" }
variable "container_port" { default = 8080 }
variable "cloudrun_env" {
	description = "Environment variables for Cloud Run. Items may reference secrets using 'secret' and optional 'secret_version'."
	default = [
		{ name = "DB_HOST", value = "10.53.96.5" },
		{ name = "DATASOURCE_PSQL_URL", secret = "DATASOURCE_PSQL_URL" },
		{ name = "DATASOURCE_PSQL_DATABASE_NAME", secret = "DATASOURCE_PSQL_DATABASE_NAME" },
		{ name = "DATASOURCE_PSQL_USERNAME", secret = "DATASOURCE_PSQL_USERNAME" },
		{ name = "DATASOURCE_PSQL_PASSWORD", secret = "DATASOURCE_PSQL_PASSWORD" },
	]
}
variable "vpc_egress" { default = "all-traffic" }
variable "allow_unauthenticated" { default = true }