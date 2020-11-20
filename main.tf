#2.0
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

data "external" "pyweb-ip" {
  program = ["/bin/sh", "${path.module}/getip.sh" ]
  depends_on = [kubernetes_service.pyweb-service]
}

output "public-ip" {
  value = data.external.pyweb-ip.result
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
          image = "smehta26/pyweb:2.0"
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
