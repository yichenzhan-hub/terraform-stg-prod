resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image
        ports {
          container_port = var.container_port
        }

        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.value.name
            value = lookup(env.value, "value", null)

            dynamic "value_from" {
              for_each = contains(keys(env.value), "secret") ? [env.value] : []
              content {
                secret_key_ref {
                  name = env.value.secret
                  key  = lookup(env.value, "secret_version", "latest")
                }
              }
            }
          }
        }
      }

      service_account_name = var.service_account
      timeout_seconds      = var.timeout_seconds
    }

    metadata {
      annotations = merge(
        var.annotations,
        var.vpc_connector != "" ? {"run.googleapis.com/vpc-access-connector" = var.vpc_connector} : {},
        var.vpc_egress    != "" ? {"run.googleapis.com/vpc-access-egress"    = var.vpc_egress}    : {}
      )
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  count    = var.allow_unauthenticated ? 1 : 0
  service  = google_cloud_run_service.service.name
  location = google_cloud_run_service.service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
