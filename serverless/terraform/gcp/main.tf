// publishes ./public to a publicly accessible bucket
// 
module "static_site" {
  name        = "${var.prefix}-${var.project}-static-site"
  source      = "./modules/static_site"
  project     = var.project
  source_path = "../public"
}

// deploys the hello-world cloud function on source change
module "http_function" {
  source               = "./modules/http_function"
  project              = var.project
  function_name        = "${var.prefix}-hello-world"
  function_entry_point = "helloWorld"
  source_path          = "../src/gcp/helloWorld"
}

// deploys the hello-event cloud function on source change
// hello event listens to the upload pubub topic
module "event_function" {
  source               = "./modules/event_function"
  project              = var.project
  function_name        = "${var.prefix}-hello-event"
  function_entry_point = "helloEvent"
  source_path          = "../src/gcp/helloEvent"
  event_type           = "google.pubsub.topic.publish"
  resource             = google_pubsub_topic.file_upload.name
}

// deploys the hello-ingest cloud function on source change
// hello event listens to the upload pubub topic
module "ingest_function" {
  source                = "./modules/event_function"
  project               = var.project
  function_name         = "${var.prefix}-hello-ingest"
  function_entry_point  = "helloIngest"
  source_path           = "../src/gcp/helloIngest"
  event_type            = "google.pubsub.topic.publish"
  resource              = google_pubsub_topic.file_upload.name
  environment_variables = {
    DATASET_ID = google_bigquery_dataset.hello_ingest.dataset_id
  }
}

// publish a pubsub event on file upload to cloud storage bucket
resource "google_storage_notification" "upload_bucket_upload_notification" {
  bucket         = google_storage_bucket.upload_bucket.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.file_upload.id
  event_types    = ["OBJECT_FINALIZE"]
  depends_on     = [google_pubsub_topic_iam_binding.gcs_service_agent_pubsub_publisher]
  custom_attributes = {
    prefix = var.prefix
  }
}

// create the upload bucket
resource "google_storage_bucket" "upload_bucket" {
  project       = var.project
  name          = "${var.prefix}-${var.project}-upload-bucket"
  location      = "EU"
  force_destroy = true

  uniform_bucket_level_access = true
}

// create the upload topic
resource "google_pubsub_topic" "file_upload" {
  project = var.project
  name    = "${var.prefix}-file-upload"
}

// Enable notifications by giving the correct IAM permission to the service agent service account.
// see, https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_notification
data "google_storage_project_service_account" "gcs_account" {
}

resource "google_pubsub_topic_iam_binding" "gcs_service_agent_pubsub_publisher" {
  topic   = google_pubsub_topic.file_upload.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

resource "google_bigquery_dataset" "hello_ingest" {
  dataset_id                  = "${var.prefix}_hello_ingest"
  friendly_name               = "hello_ingest"
  description                 = "event-driven ingested CSV data"
  location                    = "EU"
  default_table_expiration_ms = 3600000 // table is removed after 60 minutes
}