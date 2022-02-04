provider "google" {
  credentials = file(var.credentials_location)
  project     = var.google_cloud_project_id
  region      = "europe-west2"
}

# GCP beta provider
provider "google-beta" {
  credentials = file(var.credentials_location)
  project     = var.google_cloud_project_id
  region      = "europe-west2"
}
