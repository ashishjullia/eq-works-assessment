terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "kubernetes_namespace" "eq-works" {
  metadata {
    name = "eq"
  }
}

#####################################################################################
# Create volume
resource "kubernetes_persistent_volume" "eq-works" {
  metadata {
    name = "postgres-pv-volume"
    labels = {
      type = "local"
      app  = "postgresql-db"
    }
  }
  spec {
    storage_class_name = "manual"
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      host_path {
        path = "/mnt/data"
      }
    }
  }
}
#####################################################################################
# Persistent volume claim
resource "kubernetes_persistent_volume_claim" "eq-works" {
  metadata {
    name      = "postgres-pv-claim"
    namespace = kubernetes_namespace.eq-works.metadata.0.name
    labels = {
      app = "postgresql-db"
    }
  }
  spec {
    storage_class_name = "manual"
    access_modes       = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
#####################################################################################
# Deploying Kubernetes Service for Postgres
resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgresql-db-lb"
    namespace = kubernetes_namespace.eq-works.metadata.0.name
    labels = {
      app = "postgresql-db"
    }
  }
  spec {
    selector = {
      app = "postgresql-db"
    }
    type = "NodePort"
    port {
      port        = var.postgres_container_port
      target_port = var.postgres_target_port
    }
  }
}
#####################################################################################
# Deploying Postgres
resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgresql-db"
    namespace = kubernetes_namespace.eq-works.metadata.0.name
  }
  spec {
    replicas = var.postgres_replicas
    selector {
      match_labels = {
        app = "postgresql-db"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgresql-db"
        }
      }
      spec {
        volume {
          name = "postgresql-db-disk"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.eq-works.metadata.0.name
          }
        }
        init_container {
          name    = "init-db"
          image   = "postgres:latest"
          command = ["sh", "-c"]
          #args    = ["/usr/bin/pg_dump -O -x -h ", var.aws_rds_hostname, " -U ", var.aws_rds_db_username, var.aws_rds_db_name, " > /data/backup.sql; exit 0"]
          args    = ["/usr/bin/pg_dump -O -x -h ${var.aws_rds_hostname} -U ${var.aws_rds_db_username} ${var.aws_rds_db_name} > /data/backup.sql; exit 0"]
          volume_mount {
            mount_path = "/data"
            name       = "postgresql-db-disk"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }
          env {
            name  = "PGDATA"
            value = "/data/pgdata"
          }
          env {
            name  = "PGPASSWORD"
            value = var.pgpassword
          }
        }
        container {
          name  = "postgresql-db"
          image = "postgres:latest"
          resources {
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          volume_mount {
            mount_path = "/docker-entrypoint-initdb.d"
            name       = "postgresql-db-disk"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }
          env {
            name  = "PGDATA"
            value = "/data/pgdata"
          }
          port {
            container_port = var.postgres_container_port
          }
        }
      }
    }
  }
}
#####################################################################################
#Deploying Kubernetes Service for API
resource "kubernetes_service" "api" {
  metadata {
    name      = "nodeapp"
    namespace = kubernetes_namespace.eq-works.metadata.0.name
    labels = {
      app = "nodeapp"
    }
  }
  spec {
    selector = {
      app = "nodeapp"
    }
    type = "NodePort"
    port {
      port        = var.api_service_port
      target_port = var.api_container_port
    }
  }
}
#####################################################################################
# Deploying Node App
resource "kubernetes_deployment" "api" {
  metadata {
    name      = "nodeapp"
    namespace = kubernetes_namespace.eq-works.metadata.0.name
  }
  spec {
    replicas = var.api_replicas
    selector {
      match_labels = {
        app = "nodeapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "nodeapp"
        }
      }
      spec {
        container {
          name  = "nodeapp"
          image = var.api_image
          resources {
            limits = {
              cpu    = "150m"
              memory = "200Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "128Mi"
            }
          }
          env {
            name  = "DB_PGHOST"
            value = "postgresql-db-lb.eq.svc.cluster.local"
          }
          env {
            name  = "DB_PGUSER"
            value = "postgres"
          }
          env {
            name  = "DB_PGNAME"
            value = "postgres"
          }
          env {
            name  = "DB_PGPASS"
            value = var.postgres_password
          }
          env {
            name  = "DB_PGPORT"
            value = var.postgres_container_port
          }
          env {
            name  = "PORT"
            value = var.api_service_port
          }
          port {
            container_port = var.api_container_port
          }
        }
      }
    }
  }
}
#####################################################################################
