terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.46"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.8.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "tls" { }

provider "google" {
  project = "my_project"
  region  = "us-central1"
}

provider "helm" {
  kubernetes {
    host                   = google_container_cluster.dev.cluster_host
    token                  = module.gke_cluster_03.cluster_token
    cluster_ca_certificate = module.gke_cluster_03.cluster_ca_cert
  }
}
