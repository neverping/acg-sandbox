resource "google_service_account" "eso" {
  account_id   = local.eso_sa_name
  display_name = "Service Account used by External Secrets in Kubernetes"
}
