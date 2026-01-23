output "otel_collector_url" {
  description = "URL to use for OTEL_EXPORTER_OTLP_ENDPOINT"
  value       = google_cloud_run_v2_service.otel_collector.uri
}