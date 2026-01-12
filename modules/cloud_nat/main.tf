

resource "google_compute_router" "router" {
  name    = "${var.vpc_name}-router"
  region  = var.region
  network = var.network_self_link
}

resource "google_compute_router_nat" "nat" {
  name   = "${var.vpc_name}-nat"
  router = google_compute_router.router.name
  region = var.region

  nat_ip_allocate_option = var.nat_ip_allocate_option
  nat_ips                = var.nat_ip_self_links

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
  name                    = var.subnet_self_link
  source_ip_ranges_to_nat = var.subnet_ip_ranges
}

  log_config {
    enable = var.enable_logging
    filter = var.log_filter
  }

  enable_dynamic_port_allocation = var.enable_dynamic_port_allocation
}
