# ==============================================================================
# 1. OWNERS 
# ==============================================================================
resource "google_project_iam_member" "owners" {
  for_each = toset(var.iam_owners)
  project  = var.project_id
  role     = "roles/owner"
  member   = each.value
}

# ==============================================================================
# 2. ADMINS (The DevOps / Infra Team)
# ==============================================================================
# They get "Editor" (Modify most things)
resource "google_project_iam_member" "admins_editor" {
  for_each = toset(var.iam_admins)
  project  = var.project_id
  role     = "roles/editor"
  member   = each.value
}

# Give them Secret Manager Admin explicitly (Editor often can't manage secrets)
resource "google_project_iam_member" "admins_secrets" {
  for_each = toset(var.iam_admins)
  project  = var.project_id
  role     = "roles/secretmanager.admin"
  member   = each.value
}

# ==============================================================================
# 3. DEVELOPERS (The Application Team)
# ==============================================================================
# They can Deploy to Cloud Run
resource "google_project_iam_member" "devs_run" {
  for_each = toset(var.iam_developers)
  project  = var.project_id
  role     = "roles/run.developer"
  member   = each.value
}

# They can View Logs (Crucial for debugging)
resource "google_project_iam_member" "devs_logging" {
  for_each = toset(var.iam_developers)
  project  = var.project_id
  role     = "roles/logging.viewer"
  member   = each.value
}

# They can Pass the Service Account (Needed to deploy Cloud Run)
resource "google_project_iam_member" "devs_sa_user" {
  for_each = toset(var.iam_developers)
  project  = var.project_id
  role     = "roles/iam.serviceAccountUser"
  member   = each.value
}

# ==============================================================================
# 4. DATA & MONITORING (The Analysts)
# ==============================================================================
# READ DATA: View tables and data in BigQuery
resource "google_project_iam_member" "data_viewer" {
  for_each = toset(var.iam_data_viewers)
  project  = var.project_id
  role     = "roles/bigquery.dataViewer"
  member   = each.value
}

# RUN QUERIES: Required to actually execute SQL jobs
resource "google_project_iam_member" "data_job_user" {
  for_each = toset(var.iam_data_viewers)
  project  = var.project_id
  role     = "roles/bigquery.jobUser"
  member   = each.value
}

# DASHBOARDS: View Monitoring Graphs (CPU, Memory, Alerts)
resource "google_project_iam_member" "monitoring_viewer" {
  for_each = toset(var.iam_data_viewers)
  project  = var.project_id
  role     = "roles/monitoring.viewer"
  member   = each.value
}