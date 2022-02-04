variable "google_cloud_project_id" {
  type        = string
  description = "The google cloud project id"
}

variable "credentials_location" {
  type        = string
  description = "The location of the GCP crednentials file"
}

variable "domain" {
  type        = string
  description = "The domain where all resources will be accessible"
}

variable "cors_access_origin" {
  type        = string
  description = "ip/domain of local development environment"
}
