locals {
  # Pull the network link from the remote state data source
  network_self_link = data.terraform_remote_state.network.outputs.network_self_link
}

module "cloudsql" {
  source = "../../../modules/cloudsql"
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