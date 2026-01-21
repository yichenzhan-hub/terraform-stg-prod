# The Kubernetes Service Account
resource "kubernetes_service_account_v1" "smpp_ksa" {
  metadata {
    name      = "smpp-server-ksa"
    namespace = "default"
    annotations = {
      # Bind KSA to GSA
      "iam.gke.io/gcp-service-account" = google_service_account.smpp_sa.email
    }
  }
}

# The ConfigMap (Non-sensitive Env Vars)
resource "kubernetes_config_map_v1" "smpp_config" {
  metadata {
    name      = "smpp-config"
    namespace = "default"
  }

  data = {
    "DEBUG"               = "true"
    "PUBSUB_PROJECT_ID"   = var.project
    "BATCH_TOPIC_NAME"    = "batch"    # Matches Layer 3 topic name
    "PRIORITY_TOPIC_NAME" = "priority" # Matches Layer 3 topic name
  }
}

# The Secrets (Sensitive Env Vars)
resource "kubernetes_secret_v1" "smpp_secrets" {
  metadata {
    name      = "smpp-secrets"
    namespace = "default"
  }
  type = "Opaque"
  
  # IMPORTANT: Replace these placeholders with real values or import existing
  data = {
    "SERVER_USER"      = "ignored"       # Placeholder
    "SERVER_PASS"      = "ignored" # Placeholder
    "FIREBASE_API_KEY" = "ignored"     # Placeholder
  }
  
  lifecycle {
    ignore_changes = [data] # Use this if you want to manage secrets manually/outside Terraform
  }
}