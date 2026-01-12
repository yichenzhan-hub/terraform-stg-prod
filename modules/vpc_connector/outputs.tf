output "connector_name" { value = google_vpc_access_connector.this.name }
output "connector_self_link" { value = google_vpc_access_connector.this.self_link }

# output "subnet_self_link" {
#   value = google_compute_subnetwork.connector_subnet.self_link
# }