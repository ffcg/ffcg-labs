# Enable app engine, cannot be deleted and location cannot be changed #legacycrap :)
resource "google_app_engine_application" "app" {
  project     = var.project
  location_id = "europe-west"
  database_type = "CLOUD_DATASTORE_COMPATIBILITY"
}