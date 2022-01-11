locals {
  services = [
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
}

# Compress source code
data "archive_file" "source" {
  type        = "zip"
  source_dir  = abspath("../${var.source_path}")
  output_path = "/tmp/${var.function_entry_point}-source.zip"
}

# Only compress if sha changes
resource "null_resource" "source" {
  triggers = {
    src_hash = "${data.archive_file.source.output_sha}"
  }
}

# Create bucket that will host the source code
resource "google_storage_bucket" "bucket" {
  location = "eu"
  name     = "${var.project}-${lower(var.function_name)}-function"
}

# Add source code zip to bucket
resource "google_storage_bucket_object" "zip" {

  name   = "${var.function_entry_point}-${data.archive_file.source.output_sha}-source.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.source.output_path
}

# Enable APIs
resource "google_project_service" "default" {
  project  = var.project
  for_each = toset(local.services)
  service  = each.key

  disable_dependent_services = true
  disable_on_destroy         = false
}

# Create Cloud Function
resource "google_cloudfunctions_function" "function" {
  name    = var.function_name
  runtime = "nodejs14" # Switch to a different runtime if needed

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.zip.name
  event_trigger {
    event_type = var.event_type
    resource   = var.resource
  }
  entry_point = var.function_entry_point
}
