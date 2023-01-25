locals {
  # GCP Essentials
  project_id = "my_project"
  gcp_region = "us-central1"
  gcp_zone   = format("%s-f", local.gcp_region)

  # HINT: Aztec Alpaca -> https://wiki.ubuntu.com/DevelopmentCodeNames
  code_name  = "azal"

  # External Secrets
  eso_sa_name   = "external-secrets"
  eso_sa_e-mail = "external-secrets"

  # HINT: gcloud container get-server-config --flatten="channels" --filter="channels.channel=STABLE" --region="us-central1" --format="yaml(channels.channel,channels.defaultVersion)"
  # GKE - Kubernetes
  k8s_min_release = "1.24"
  k8s_channel     = "STABLE"

}

