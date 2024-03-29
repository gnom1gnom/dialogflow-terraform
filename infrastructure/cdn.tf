# Bucket to store website
resource "google_storage_bucket" "website" {
  provider      = google
  name          = "dialogflow-website-340213"
  location      = "EUROPE-WEST2"
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}

# Make new objects public
resource "google_storage_default_object_access_control" "website_read" {
  bucket = google_storage_bucket.website.name
  role   = "READER"
  entity = "allUsers"
}

# Reserve an external IP
resource "google_compute_global_address" "website" {
  provider = google
  name     = "website-lb-ip"
}

# Create the managed DNS zone
resource "google_dns_managed_zone" "gcp_dialogflow_dev" {
  provider = google-beta
  name     = "gcp-dialogflow-dev"
  dns_name = "${var.domain}."
}

# Add the IP to the DNS
resource "google_dns_record_set" "website" {
  provider     = google
  name         = google_dns_managed_zone.gcp_dialogflow_dev.dns_name
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.gcp_dialogflow_dev.name
  rrdatas      = [google_compute_global_address.website.address]
}

# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "website" {
  provider    = google
  name        = "website-backend"
  description = "Contains files needed by the website"
  bucket_name = google_storage_bucket.website.name
  enable_cdn  = true
}

# Create HTTPS certificate
resource "google_compute_managed_ssl_certificate" "website" {
  provider = google-beta
  name     = "website-cert"
  managed {
    domains = [google_dns_record_set.website.name]
  }
}

# GCP URL MAP
resource "google_compute_url_map" "website" {
  provider        = google
  name            = "website-url-map"
  default_service = google_compute_backend_bucket.website.self_link
}

#GCP HTTP proxy
resource "google_compute_target_http_proxy" "website" {
  name    = "https-redirect-proxy"
  url_map = google_compute_url_map.website.self_link
}

# GCP target proxy
resource "google_compute_target_https_proxy" "website" {
  provider         = google
  name             = "website-target-proxy"
  url_map          = google_compute_url_map.website.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.website.self_link]
}

# GCP forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  provider              = google
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.website.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.website.self_link
}
