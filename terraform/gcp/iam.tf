// Enable notifications by giving the correct IAM permission to the service agent service account.
// see, https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_notification
data "google_storage_project_service_account" "gcs_account" {
}

resource "google_pubsub_topic_iam_binding" "gcs_service_agent_pubsub_publisher" {
  topic   = google_pubsub_topic.file_upload.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}
