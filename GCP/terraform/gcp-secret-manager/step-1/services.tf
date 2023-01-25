resource "google_project_service" "secretmanager" {
  service = "secretmanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = false
  disable_on_destroy         = true
}

resource "google_project_service" "kms" {
  service = "cloudkms.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = false
  disable_on_destroy         = true
}

resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = false
  disable_on_destroy         = true
}

# HINT: GKE
resource "google_project_service" "container" {
  service = "container.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = false
  disable_on_destroy         = true
}
