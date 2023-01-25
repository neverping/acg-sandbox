terraform {
  required_version = ">= 1.2.2"
  required_providers {
    google = ">= 4.36"
  }
}

resource "google_secret_manager_secret" "this" {
  project   = var.project_id
  secret_id = var.id
  labels    = var.labels
  replication {
    dynamic "user_managed" {
      for_each = length(var.replication) > 0 ? [1] : []
      content {
        dynamic "replicas" {
          for_each = var.replication
          content {
            location = replicas.key
            dynamic "customer_managed_encryption" {
              for_each = toset(compact([replicas.value != null ? lookup(replicas.value, "kms_key_name") : null]))
              content {
                kms_key_name = customer_managed_encryption.value
              }
            }
          }
        }
      }
    }
    automatic = length(var.replication) > 0 ? null : true
  }
}

# Allow the supplied entities to read the secret value from Secret Manager
# Note: This is an authoritative resource.
#
# This means it sets the IAM policy for the secret and replaces any existing
# policy already attached to a resource.
#
# This is by module design in order to prevent misusage outside of this module.
resource "google_secret_manager_secret_iam_binding" "this" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.this.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members   = var.accessors
}
