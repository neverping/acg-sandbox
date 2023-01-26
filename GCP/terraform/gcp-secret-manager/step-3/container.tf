data "google_container_engine_versions" "k8s" {
  location       = local.gcp_region
  version_prefix = format("%s.", local.k8s_min_release)
}

module "dev" {
  source = "./modules/gke"

  name               = "dev"
  project_id         = local.project_id
  location           = local.gcp_region
  k8s_version        = data.google_container_engine_versions.k8s.release_channel_default_version[local.k8s_channel]
  release_channel    = local.k8s_channel
  service_account    = google_service_account.eso.email 
}
