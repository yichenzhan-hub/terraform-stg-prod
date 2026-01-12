module "iam" {
  source = "../../modules/iam"
  sa_name = var.sa_name
  sa_display = var.sa_display
  project = var.project
}

module "cloudrun" {
  source = "../../modules/cloudrun"
  service_name = var.cloudrun_service_name
  region = var.run_region
  image = var.cloudrun_image
  vpc_connector = module.vpc_connector.connector_self_link
  container_port = var.container_port
  env_vars = var.cloudrun_env
  service_account = google_service_account.cloudrun.email
  vpc_egress = var.vpc_egress
  allow_unauthenticated = var.allow_unauthenticated
    # FIX: Force module to wait for Secret Manager permissions to propagate
  depends_on = [
    time_sleep.wait_for_secret_iam,
    google_project_iam_member.cloudsql_client
  ]
}

resource "google_service_account" "cloudrun" {
  # Define a unique ID for the service account. This will be the prefix of the email.
  account_id   = "cloudrun-sa" 
  display_name = "Service Account for Cloud Run"
  project      = var.project # Use the project variable from the root module
}

# Grant the custom SA permissions to connect to Cloud SQL
resource "google_project_iam_member" "cloudsql_client" {
  project = var.project
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun.email}"
}