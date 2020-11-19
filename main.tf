provider "kubernetes" {
  config_context = "kubernetes-admin@kubernetes"
}

resource "kubernetes_service" "pyweb-service" {
  metadata {
    name = "pyweb-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.pyweb-deployment.metadata.0.labels.app
    }
    port {
      port        = 5000
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "pyweb-deployment" {
  metadata {
    name = "pyweb-deployment"
    labels = {
      app = "pyweb"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "pyweb"
      }
    }

    template {
      metadata {
        labels = {
          app = "pyweb"
        }
      }

      spec {
        container {
          image = "smehta26/pyweb:1.0"
          name  = "pyweb"
          port {
            container_port = 5000
          }
        }
        container {
          image = "redis:alpine"
          name  = "redis"
        }
      }
    }
  }
}
