module "network" {
  # Only create if not importing existing resources
  count   = var.create_network ? 1 : 0
  source  = "../../modules/network"
  vpc_name = var.vpc_name
  region = var.region
  subnet_cidr = var.subnet_cidr
  secondary_ip_ranges = var.secondary_ip_ranges
}

# Reference existing network when importing
data "google_compute_network" "this" {
  count = var.create_network ? 0 : 1
  name  = var.vpc_name
}

# Use a local to abstract which network is being used
locals {
  network_self_link = var.create_network ? module.network[0].network_self_link : data.google_compute_network.this[0].self_link
}

# Reference existing subnet for Cloud NAT
data "google_compute_subnetwork" "this" {
  count  = var.create_network ? 0 : 1
  name   = var.vpc_name
  region = var.region
}

module "vpc_connector" {
  source = "../../modules/vpc_connector"
  name = var.connector_name
  region = var.run_region
  network_self_link = local.network_self_link
  cidr_range = var.connector_cidr
  project = var.project
}

resource "google_compute_address" "nat_ip" {
  name   = var.nat_ip_name
  region = var.region
}

module "cloud_nat" {
  source = "../../modules/cloud_nat"
  vpc_name = var.vpc_name
  network_self_link = local.network_self_link
  region = var.region
  nat_ip_self_links = [google_compute_address.nat_ip.self_link]
  enable_dynamic_port_allocation = false
  # Use the actual subnet self-link (not network) for the subnetwork.name field
  subnet_self_link = var.create_network ? module.network[0].subnet_self_link : data.google_compute_subnetwork.this[0].self_link
  subnet_ip_ranges = [var.subnet_cidr]
}