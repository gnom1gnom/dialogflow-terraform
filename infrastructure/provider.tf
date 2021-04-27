provider "google" {
  project = var.google_cloud_project_id
  region  = "europe-west2"
}

# GCP beta provider
provider "google-beta" {
  project      = var.google_cloud_project_id
  region       = "europe-west2"
}
