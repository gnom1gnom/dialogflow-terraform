resource "google_dialogflow_agent" "full_agent" {
  display_name = "dialogflow-example-agent"
  default_language_code = "en"
  time_zone = "Europe/London"
  description = "This is the agent that acts like a human"
  enable_logging = true
  match_mode = "MATCH_MODE_HYBRID"
  tier = "TIER_STANDARD"
  project = var.google_cloud_project_id
}
