# 1. Notification Channel (Email)
resource "google_monitoring_notification_channel" "email" {
  display_name = "DevOps Team Email"
  type         = "email"
  labels = {
    email_address = var.email_notification_address
  }
}

# ------------------------------------------------------------------------------
# APPLICATION ALERTS (Source: OTel Collector & GKE System)
# ------------------------------------------------------------------------------

# 2. Alert: Cloud Run High Error Rate (OTel Data)
resource "google_monitoring_alert_policy" "cloudrun_errors" {
  display_name = "Cloud Run - High Error Rate"
  combiner     = "OR"
  conditions {
    display_name = "Error rate > 5%"
    condition_threshold {
      # Filter for Cloud Run 5xx errors via OTel
      filter     = "resource.type = \"cloud_run_revision\" AND metric.type = \"run.googleapis.com/request_count\" AND metric.label.response_code_class = \"5xx\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
      trigger { count = 1 }
      threshold_value = 0.05
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
}

# 3. Alert: SMPP Server Down (GKE System Data)
# Checks if the container is running. No OTel needed for "uptime".
resource "google_monitoring_alert_policy" "smpp_down" {
  display_name = "SMPP Server - Container Down"
  combiner     = "OR"
  conditions {
    display_name = "Active Containers < 1"
    condition_threshold {
      filter     = "resource.type = \"k8s_container\" AND metric.type = \"kubernetes.io/container/uptime\" AND resource.label.container_name = \"smpp-server\""
      duration   = "60s"
      comparison = "COMPARISON_LT"
      threshold_value = 1
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
}

# ------------------------------------------------------------------------------
# INFRASTRUCTURE ALERTS (Source: Native GCP Metrics - No OTel needed)
# ------------------------------------------------------------------------------

# 4. Alert: Cloud SQL CPU High
resource "google_monitoring_alert_policy" "db_cpu_high" {
  display_name = "Cloud SQL - High CPU"
  combiner     = "OR"
  conditions {
    display_name = "CPU > 80%"
    condition_threshold {
      # Native Metric: cloudsql.googleapis.com
      filter     = "resource.type = \"cloudsql_database\" AND metric.type = \"cloudsql.googleapis.com/database/cpu/utilization\""
      duration   = "300s" # Alert only if high for 5 minutes
      comparison = "COMPARISON_GT"
      threshold_value = 0.8
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
}

# 5. Alert: Pub/Sub Stuck Messages (Backlog)
resource "google_monitoring_alert_policy" "pubsub_backlog" {
  display_name = "Pub/Sub - Messages Stuck"
  combiner     = "OR"
  conditions {
    display_name = "Oldest Message > 10m"
    condition_threshold {
      # Native Metric: pubsub.googleapis.com
      filter     = "resource.type = \"pubsub_subscription\" AND metric.type = \"pubsub.googleapis.com/subscription/oldest_unacked_message_age\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 600 # 600 seconds = 10 minutes
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MAX"
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
}