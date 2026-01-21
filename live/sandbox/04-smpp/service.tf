resource "kubernetes_service_v1" "smpp_service" {
  metadata {
    name      = "smpp-server"
    namespace = "default"
    annotations = {
       "cloud.google.com/neg" = "{\"ingress\":true}"
    }
  }

  spec {
    selector = {
      app = "smpp-server"
    }
    
    # Critical for SMPP: Keeps the connection sticky to the single pod
    session_affinity = "ClientIP"
    session_affinity_config {
      client_ip {
        timeout_seconds = 3600
      }
    }

    port {
      name        = "smpp"
      port        = 2775
      target_port = 2775
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}