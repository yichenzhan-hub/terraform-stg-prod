resource "google_compute_network" "this" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
  description             = coalesce(var.description, "VPC created by Terraform")
  lifecycle {
    ignore_changes = [
      auto_create_subnetworks,
      description,
      routing_mode,
      # Add any other attributes that force replacement but are safe to drift:
      # mtu,
    ]
  }
}

resource "google_compute_subnetwork" "primary" {
  name                     = coalesce(var.subnet_name, "${var.vpc_name}-subnet")
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.this.id
  private_ip_google_access = var.private_google_access
  dynamic "secondary_ip_range" {
    for_each = var.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.name
      ip_cidr_range = secondary_ip_range.value.cidr
    }
  }
}
