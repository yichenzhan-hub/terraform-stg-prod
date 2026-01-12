module "cloudsql" {
  source = "../../modules/cloudsql"
  project = var.project
  create_instance = var.create_instance
  instance_name = var.instance_name
  region = var.region
  private_network_self_link = local.network_self_link
  ip_v4_enabled = true
  database_flags = var.database_flags
  databases = var.databases
  deletion_protection = true
}