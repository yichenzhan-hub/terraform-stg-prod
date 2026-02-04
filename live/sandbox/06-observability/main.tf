terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Enable APIs (Just in case they aren't on)
resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "monitoring.googleapis.com",
    "cloudtrace.googleapis.com"
  ])
  service            = each.key
  disable_on_destroy = false
}

# 2. Store Config in Secret Manager
resource "google_secret_manager_secret" "otel_config" {
  secret_id = "otel-collector-config"
  replication {
    auto {}
  }
  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_version" "otel_config_data" {
  secret      = google_secret_manager_secret.otel_config.id
  secret_data = file("${path.module}/otel-config.yaml") 
}

# 3. Service Account & IAM
resource "google_service_account" "otel_sa" {
  account_id   = "otel-collector-sa"
  display_name = "OTel Collector Service Account"
}

resource "google_project_iam_member" "metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.otel_sa.email}"
}

resource "google_project_iam_member" "trace_agent" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.otel_sa.email}"
}

resource "google_project_iam_member" "secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.otel_sa.email}"
}

resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.otel_sa.email}"
}

# 4. Cloud Run Service (The Collector)
resource "google_cloud_run_v2_service" "otel_collector" {
  name     = "otel-collector"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false # Allows Terraform to destroy/replace it easily

  template {
    service_account = google_service_account.otel_sa.email
    
    containers {
      image = "otel/opentelemetry-collector-contrib:0.86.0" 
      
      args = ["--config=/etc/otel/config.yaml"]
      
      volume_mounts {
        name       = "config-volume"
        mount_path = "/etc/otel"
      }
      
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }

    volumes {
      name = "config-volume"
      secret {
        secret = google_secret_manager_secret.otel_config.secret_id
        items {
          version = "latest"
          path    = "config.yaml"
        }
      }
    }
  }
  depends_on = [google_project_service.apis]
}

# 5. Allow Public Access (So Layer 3 & 4 can reach it)
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.otel_collector.name
  location = google_cloud_run_v2_service.otel_collector.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_logging_project_exclusion" "gke_noise" {
  name        = "exclude-gke-system-noise"
  description = "Excludes noisy K8s system audit logs, node scaling errors, and 404s"

  # UPDATED FILTER:
  # 1. Block "CreateServiceTimeSeries" (Metric Uploads)
  # 2. Block ANY log touching "leases" (Heartbeats) - This is the fix for your "update" logs
  # 3. Block ANY log touching "kube-system" (Internal namespace)
  # 4. Block "gce_instance" noise (The ansi color code errors)
  # 5. Block "compute.googleapis.com" 404s (Autoscaling noise)
  filter = <<EOF
(protoPayload.methodName:"CreateServiceTimeSeries") OR
(protoPayload.resourceName:"leases") OR
(protoPayload.resourceName:"kube-system") OR
(resource.type="gce_instance" AND textPayload:"cri-containerd") OR
(protoPayload.serviceName="compute.googleapis.com" AND protoPayload.status.message:"was not found")
EOF
}