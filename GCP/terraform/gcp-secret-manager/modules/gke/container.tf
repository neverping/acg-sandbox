# Required for outputs.tf
data "google_client_config" "default" {}

resource "google_container_cluster" "k8s" {
  name               = var.name
  project            = var.project_id
  location           = var.location
  initial_node_count = var.node_count
  min_master_version = var.k8s_version
  node_version       = var.k8s_version

  release_channel {
    channel = var.release_channel
  }

  cluster_autoscaling {
    enabled = false
  }

  # HINT: Required for GCP GKE + GCP Secret Manager
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  node_config {
    service_account = var.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
