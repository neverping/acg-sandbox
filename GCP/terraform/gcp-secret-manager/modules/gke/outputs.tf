output "instance_group_urls" {
  value = google_container_cluster.k8s.node_pool[0].managed_instance_group_urls
}

output "cluster_host" {
  value = "https://${google_container_cluster.k8s.endpoint}"
}

output "cluster_token" {
  value = data.google_client_config.default.access_token
}

output "cluster_ca_cert" {
  value = base64decode(google_container_cluster.k8s.master_auth[0].cluster_ca_certificate)
}