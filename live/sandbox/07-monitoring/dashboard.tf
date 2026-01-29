resource "google_monitoring_dashboard" "smsgw_dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "SMS Gateway Unified Dashboard (Cloud Monitoring)",
  "gridLayout": {
    "columns": "2",
    "widgets": [
      {
        "title": "Cloud Run Request Count (OTel)",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "resource.type=\"cloud_run_revision\" metric.type=\"run.googleapis.com/request_count\"",
                "aggregation": { "perSeriesAligner": "ALIGN_RATE" }
              }
            }
          }]
        }
      },
      {
        "title": "SMPP App Transactions (OTel Push)",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "resource.type=\"global\" metric.type=\"custom.googleapis.com/opentelemetry/smpp_requests\"",
                "aggregation": { "perSeriesAligner": "ALIGN_RATE" }
              }
            }
          }]
        }
      },
      {
        "title": "SMPP CPU Usage (Standard GKE)",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "resource.type=\"k8s_container\" metric.type=\"kubernetes.io/container/cpu/core_usage_time\" resource.label.container_name=\"smpp-server\"",
                "aggregation": { "perSeriesAligner": "ALIGN_RATE" }
              }
            }
          }]
        }
      },
      {
        "title": "SMPP Memory Usage (Standard GKE)",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "resource.type=\"k8s_container\" metric.type=\"kubernetes.io/container/memory/used_bytes\" resource.label.container_name=\"smpp-server\""
              }
            }
          }]
        }
      }
    ]
  }
}
EOF
}