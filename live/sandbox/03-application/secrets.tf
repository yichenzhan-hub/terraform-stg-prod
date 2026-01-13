# Secret Manager secrets for SMS Gateway database connection
# These secrets are used as environment variables in the Cloud Run deployment

resource "google_secret_manager_secret" "datasource_psql_url" {
  secret_id = "DATASOURCE_PSQL_URL"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "datasource_psql_database_name" {
  secret_id = "DATASOURCE_PSQL_DATABASE_NAME"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "datasource_psql_password" {
  secret_id = "DATASOURCE_PSQL_PASSWORD"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "datasource_psql_username" {
  secret_id = "DATASOURCE_PSQL_USERNAME"
  replication {
    auto {}
  }
}

# -----------------------------------------------------------------------------
# IAM PERMISSIONS
# -----------------------------------------------------------------------------

locals {
  # Map static keys to the actual Secret Resources
  secret_map = {
    "DATASOURCE_PSQL_URL"           = google_secret_manager_secret.datasource_psql_url
    "DATASOURCE_PSQL_DATABASE_NAME" = google_secret_manager_secret.datasource_psql_database_name
    "DATASOURCE_PSQL_PASSWORD"      = google_secret_manager_secret.datasource_psql_password
    "DATASOURCE_PSQL_USERNAME"      = google_secret_manager_secret.datasource_psql_username
  }

  # CHANGE: Use a Map so we have STATIC keys ("app", "robot") for the loop
  accessor_map = {
    "app"   = "serviceAccount:${google_service_account.cloudrun.email}"
    "robot" = "serviceAccount:service-618425665876@serverless-robot-prod.iam.gserviceaccount.com"
  }
}

resource "google_secret_manager_secret_iam_member" "secret_access" {
  # Loop over the KEYS of both maps (Strings like "DATASOURCE_PSQL_URL" and "app")
  # These are known immediately, so the Plan will succeed.
  for_each = {
    for pair in setproduct(keys(local.secret_map), keys(local.accessor_map)) : "${pair[0]}-${pair[1]}" => {
      secret_key   = pair[0]  # e.g. "DATASOURCE_PSQL_URL"
      accessor_key = pair[1]  # e.g. "app"
    }
  }

  # Lookup the actual resources/values inside the body (Allowed to be computed here!)
  secret_id = local.secret_map[each.value.secret_key].secret_id
  member    = local.accessor_map[each.value.accessor_key]
  
  role = "roles/secretmanager.secretAccessor"
}

# CRITICAL: Propagation Delay
# IAM changes can take up to 2 minutes to propagate globally. 
# Without this, Cloud Run will fail immediately upon deployment.
resource "time_sleep" "wait_for_secret_iam" {
  depends_on = [
    google_secret_manager_secret_iam_member.secret_access
  ]
  create_duration = "120s"
}