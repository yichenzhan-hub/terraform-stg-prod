output "network_self_link" {
  value = local.network_self_link
}

output "connector_self_link" {
  value = module.vpc_connector.connector_self_link
}