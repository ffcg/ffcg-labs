module "http_function" {
  source               = "./modules/http_function"
  project              = var.project
  function_name        = "hello-world"
  function_entry_point = "helloWorld"
  source_path = "../src/gcp/helloWorld"
}

resource "google_pubsub_topic" "file_upload" {
  name = "file-upload"
}

module "event_function" {
  source               = "./modules/event_function"
  project              = var.project
  function_name        = "hello-event"
  function_entry_point = "helloEvent"
  source_path = "../src/gcp/helloEvent"
  event_type = "google.pubsub.topic.publish"
  resource = google_pubsub_topic.file_upload.name
}

module "static_site" {
  source      = "./modules/static_site"
  project     = var.project
  source_path = "../public"
}