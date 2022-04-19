locals {
  services = [
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "eventarc.googleapis.com",
    "artifactregistry.googleapis.com",
  ]
  pubsub_svc_account_email = "service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

data "google_project" "project" {
  project_id = var.project
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
resource "google_cloudfunctions2_function" "function" {
  name    = var.function_name
  provider = google-beta
  location   = var.region
  project  = var.project
  
  build_config {
    runtime = "nodejs14"
    entry_point = var.function_entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.zip.name
      }
    }
  }

  service_config {
    max_instance_count  = 1
    available_memory    = "128Mi"
    timeout_seconds     = 60
    # https://github.com/hashicorp/terraform-provider-google/issues/11388
    # service_account_email = google_service_account.eventarc.email
    ingress_settings = "ALLOW_INTERNAL_ONLY"
    environment_variables = var.environment_variables
  }

}

#TODO: to run as a cloud function trigger, SA needs event trigger, but SA can't be set due to issue below
#This trigger needs the role roles/eventarc.eventReceiver granted to service account to receive events via Cloud Audit Logs.
#https://github.com/hashicorp/terraform-provider-google/issues/11388 
resource "google_project_iam_member" "function_eventReceiver" {
  project = var.project
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_cloudfunctions2_function.function.service_config[0].service_account_email}"
}

resource "google_service_account" "eventarc" {
  account_id   = "${var.function_name}"
}

#This trigger needs the role roles/eventarc.eventReceiver granted to service account to receive events via Cloud Audit Logs.
resource "google_project_iam_member" "eventarc_eventReceiver" {
  project = var.project
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.eventarc.email}"
}

#Cloud Pub/Sub needs the role roles/iam.serviceAccountTokenCreator granted to service account on this project to create identity tokens.
resource "google_project_iam_member" "pubsub_serice_account_token_creator" {
  project = var.project
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${local.pubsub_svc_account_email}"
}

resource "google_eventarc_trigger" "trigger" {
  name = "${var.function_name}-trigger"
  location = var.region
  service_account = google_service_account.eventarc.email
  destination {
    cloud_run_service {
      path    = "/"
      region  = var.region
      service = google_cloudfunctions2_function.function.name
    }
    # cloud_function = google_cloudfunctions2_function.function.id
  }
  matching_criteria {
    attribute = "methodName"
    value     = "google.cloud.bigquery.v2.JobService.Query" #"google.cloud.bigquery.v2.JobService.InsertJob"
  }
  # matching_criteria {
  #   attribute = "resourceName"
  #   operator  = "match-path-pattern"
  #   value     = "/projects/_/datasets/${var.dataset_id}/*"
  # }
  matching_criteria {
    attribute = "serviceName"
    value     = "bigquery.googleapis.com"
  }
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.audit.log.v1.written"
  }
}