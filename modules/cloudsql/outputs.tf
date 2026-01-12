output "instance_name" {
  value = var.create_instance ? google_sql_database_instance.this[0].name : var.instance_name
}

output "private_ip" {
  value = var.create_instance ? try(google_sql_database_instance.this[0].ip_address[0].ip_address, "") : ""
}
