# 1. Enable the Redis API
resource "google_project_service" "redis_api" {
  project = var.project
  service = "redis.googleapis.com"

  # Recommended: Don't disable the API if you destroy the Terraform resource
  # to prevent breaking other things that might rely on it.
  disable_on_destroy = false
}

resource "google_redis_instance" "cache" {
  name           = "smsgw-redis-${var.environment}"
  tier           = var.tier
  memory_size_gb = var.memory_size_gb

  region      = var.region
  # Optional: Pick a specific zone if needed, or let GCP choose
  # location_id = "northamerica-northeast2-a"

  # NETWORK CONNECTION
  # This connects Redis to your "yichen-vpc" via Private Service Access
  authorized_network = data.terraform_remote_state.network.outputs.network_self_link

  redis_version = var.redis_version
  display_name  = "SMS Gateway Cache (${var.environment})"

  labels = {
    env = var.environment
  }
  # CRITICAL: Tell Terraform to wait for the API to be enabled first
  depends_on = [
    google_project_service.redis_api
  ]

  # Maintenance window (Optional: Good practice for Prod)
  # maintenance_policy {
  #   weekly_maintenance_window {
  #     day = "SUNDAY"
  #     start_time {
  #       hours = 2
  #       minutes = 0
  #       nanos = 0
  #       seconds = 0
  #     }
  #   }
  # }
}