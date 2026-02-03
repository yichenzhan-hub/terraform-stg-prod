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