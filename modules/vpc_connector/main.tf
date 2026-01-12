resource "google_vpc_access_connector" "this" {
  name          = var.name
  region        = var.region
  network       = var.network_self_link
  ip_cidr_range = var.cidr_range

  min_instances = var.min_instances
  max_instances = var.max_instances
  machine_type  = var.machine_type
  project       = var.project
}

