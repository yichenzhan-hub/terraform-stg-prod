output "network_self_link" {
  value = local.network_self_link
}

# output "connector_self_link" {
#  value = module.vpc_connector.connector_self_link
# }

output "network_name" {
  value = var.vpc_name
}

# Parse the subnet name from the self_link since the module doesn't output the name directly
output "subnet_name" {
  description = "Name of the subnetwork"
  # Logic: If create_network is true, parse the self_link from the module.
  #        If create_network is false, simply use the variable var.subnet_name.
  value = var.create_network ? element(split("/", module.network[0].subnet_self_link), length(split("/", module.network[0].subnet_self_link)) - 1) : var.subnet_name
}