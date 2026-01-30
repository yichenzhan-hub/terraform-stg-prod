# 1. The Container (Dataset)
resource "google_bigquery_dataset" "observability" {
  dataset_id                  = "observability_logs"
  friendly_name               = "Observability Logs"
  description                 = "Stores raw logs exported from Cloud Logging"
  location                    = var.region
  
  # Optional: Auto-delete logs older than 30 days to save money in Sandbox
  default_table_expiration_ms = 2592000000 

  labels = {   
    env = var.environment
  }
}

# 2. The Connection (Log Sink)
# This resource automatically Creates Tables in the dataset above!
resource "google_logging_project_sink" "otel_to_bigquery" {
  name        = "otel-logs-sink"
  destination = "bigquery.googleapis.com/${google_bigquery_dataset.observability.id}"

  # Filter: Grab logs from your OTel Collector Container
  # This ensures we don't dump *everything* (like noisy system logs) into BigQuery, saving money.
  filter = "resource.type=\"k8s_container\" AND resource.labels.container_name=\"otel-collector\""
  
  # CRITICAL: This allows the sink to write to BQ without a dedicated Service Account key
  unique_writer_identity = true
}

# 3. Permissions
# We must give the Sink's "Service Account" permission to write to the Dataset
resource "google_bigquery_dataset_iam_member" "sink_writer" {
  dataset_id = google_bigquery_dataset.observability.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.otel_to_bigquery.writer_identity
}