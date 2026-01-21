# 1. Create GCP Service Account (The Identity)
resource "google_service_account" "smpp_sa" {
  account_id   = "smpp-server-sa"
  display_name = "SMPP Bridge Service Account"
}

# 2. Allow Kubernetes (KSA) to use this Identity (Workload Identity)
resource "google_service_account_iam_member" "workload_identity" {
  service_account_id = google_service_account.smpp_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project}.svc.id.goog[default/smpp-server-ksa]"
}

# 3. Grant Permission: The Bridge produces data (Publisher)
resource "google_project_iam_member" "pubsub_publisher" {
  project = var.project
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.smpp_sa.email}"
}