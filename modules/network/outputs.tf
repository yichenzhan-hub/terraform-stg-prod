output "network_self_link" { value = google_compute_network.this.self_link }
output "subnet_self_link" { value = google_compute_subnetwork.primary.self_link }
output "subnet_cidr" { value = google_compute_subnetwork.primary.ip_cidr_range }
