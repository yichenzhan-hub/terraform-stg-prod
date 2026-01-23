resource "kubernetes_deployment_v1" "smpp_server" {
  metadata {
    name      = "smpp-server"
    namespace = "default"
    labels = {
      app = "smpp-server"
    }
  }

  spec {
    replicas = 1 # Keep as 1 for TCP session stability
    selector {
      match_labels = {
        app = "smpp-server"
      }
    }
    strategy {
      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = {
          app = "smpp-server"
        }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.smpp_ksa.metadata[0].name
        
        container {
          name              = "smpp-server"
          image             = "gcr.io/munvo-sandbox/smpp-server:latest" # Ensure this image is correct
          image_pull_policy = "Always"

          port {
            container_port = 2775
            name           = "smpp"
            protocol       = "TCP"
          }

          # Environment Variables
          env {
            name = "PUBSUB_PROJECT_ID"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map_v1.smpp_config.metadata[0].name
                key  = "PUBSUB_PROJECT_ID"
              }
            }
          }
          # Add other ENV vars referencing the ConfigMap/Secret similarly...
          # NEW: Add the OTel Endpoint
          env {
            name  = "OTEL_EXPORTER_OTLP_ENDPOINT"
            value = var.otel_collector_url
          }
          
          # Optional: Add Resource Attributes to identify the service
          env {
            name  = "OTEL_RESOURCE_ATTRIBUTES"
            value = "service.name=smpp-bridge,service.namespace=sandbox"
          }
        }
      }
    }
  }
}