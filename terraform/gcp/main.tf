// publishes ./public to a publicly accessible bucket
module "static_site" {
  source      = "./modules/static_site"
  project     = var.project
  source_path = "../public"
}

// deploys the hello-world cloud function on source change
module "http_function" {
  source               = "./modules/http_function"
  project              = var.project
  function_name        = "hello-world"
  function_entry_point = "helloWorld"
  source_path = "../src/gcp/helloWorld"
}

// deploys the hello-event cloud function on source change
// hello event listens to the upload pubub topic
module "event_function" {
  source               = "./modules/event_function"
  project              = var.project
  function_name        = "hello-event"
  function_entry_point = "helloEvent"
  source_path = "../src/gcp/helloEvent"
  event_type = "google.pubsub.topic.publish"
  resource = google_pubsub_topic.file_upload.name
}

// publishes a pubsub event on file upload to cloud storage bucket
resource "google_storage_notification" "upload_bucket_upload_notification" {
  bucket         = google_storage_bucket.upload_bucket.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.file_upload.id
  event_types    = ["OBJECT_FINALIZE"]
  depends_on = [google_pubsub_topic_iam_binding.gcs_service_agent_pubsub_publisher]
}

// create the upload bucket
resource "google_storage_bucket" "upload_bucket" {
  name = "${var.project}-upload-bucket"
}

// create the upload topic
resource "google_pubsub_topic" "file_upload" {
  name = "file-upload"
}
