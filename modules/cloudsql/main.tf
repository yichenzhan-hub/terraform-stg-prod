# Cloud SQL instance - import-safe module (users management disabled)
resource "google_sql_database_instance" "this" {
  count            = var.create_instance ? 1 : 0
  name             = var.instance_name
  database_version = var.database_version
  region           = var.region
  project          = var.project

  lifecycle {
    prevent_destroy = true
  }

  settings {
    tier              = var.tier
    disk_size         = var.disk_size
    disk_type         = var.disk_type
    activation_policy = var.activation_policy
    availability_type = var.availability_type

    backup_configuration {
      enabled    = var.backup_enabled
      start_time = var.backup_start_time
    }

    ip_configuration {
      ipv4_enabled    = var.ip_v4_enabled
      private_network = var.private_network_self_link

      # `require_ssl` was removed here because the provider/version in use did not accept that argument.
      # If you need Terraform to manage SSL enforcement:
      #  - Upgrade to a provider version or use the google-beta provider that exposes this attribute,
      #    then re-introduce: require_ssl = var.require_ssl
      #  - Or enforce it outside Terraform (example):
      #      gcloud sql instances patch <INSTANCE> --project=<PROJECT> --require-ssl
      # To inspect current instance setting:
      #      gcloud sql instances describe <INSTANCE> --project=<PROJECT> --format="value(settings.ipConfiguration.requireSsl)"
    }

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }
  }

  deletion_protection = var.deletion_protection
}

resource "google_sql_database" "databases" {
  count    = var.create_instance ? length(var.databases) : 0
  name     = var.databases[count.index]
  instance = google_sql_database_instance.this[0].name
  charset  = "UTF8"
}


