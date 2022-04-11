output "https_trigger_url" {
  value = google_cloudfunctions_function.function.https_trigger_url
  description = "URL where the http function can be called"
}