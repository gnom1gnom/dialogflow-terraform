resource "google_storage_bucket" "functions-bucket" {
  name = "arctic-chatbot-functions-bucket"
  location = "EUROPE-WEST2"
}

resource "google_storage_bucket_object" "chatbot-source" {
  name = "chatbotAPI"
  bucket = google_storage_bucket.functions-bucket.name
  source = "../platform/chatbot/main.zip"
}

resource "google_cloudfunctions_function" "chatbot-function" {
  name  = "chatbot-function"
  description = "Chatbot REST API endpoint"
  runtime = "go113"

  available_memory_mb = 128
  source_archive_bucket = google_storage_bucket.functions-bucket.name
  source_archive_object = google_storage_bucket_object.chatbot-source.name
  trigger_http = true
  entry_point = "ChatBotHandler"
  environment_variables = {
    "GOOGLE_CLOUD_PROJECT" = var.google_cloud_project_id
    "ACCESS_ORIGIN" = "https://dialogflow.catley.me"
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.chatbot-function.project
  region         = google_cloudfunctions_function.chatbot-function.region
  cloud_function = google_cloudfunctions_function.chatbot-function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
