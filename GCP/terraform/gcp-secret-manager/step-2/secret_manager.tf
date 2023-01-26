module "azal_secrets" {
  source = "./modules/secret_manager"

  for_each = toset([
    "azal-key",
    "azal-cert"
  ])

  id         = each.value
  project_id = local.project_id

  # ACG does not accept replication 'auto' because it is 'global'.
  replication = {
    "us-east1" = null
    "us-west1" = null
  } 

  accessors = [google_service_account.eso.member]

  depends_on = [
    google_service_account.eso,
    google_project_service.secretmanager
  ]
}

