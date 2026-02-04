output "redis_host" {
  description = "The IP address of the Redis instance"
  value       = google_redis_instance.cache.host
}

output "redis_port" {
  description = "The port number of the Redis instance"
  value       = google_redis_instance.cache.port
}

output "redis_id" {
  description = "The full resource ID"
  value       = google_redis_instance.cache.id
}

# This output is SENSITIVE, so Terraform masks it in the console
output "redis_auth_string" {
  description = "The automatically generated Redis password"
  value       = google_redis_instance.cache.auth_string
  sensitive   = true
}