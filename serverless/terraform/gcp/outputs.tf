output "https_trigger_url" {
  description = "URL for the cloud function"
  value = module.http_function.https_trigger_url
}

output "public_url" {
  description = "URL for the website"
  value = module.static_site.public_url
}
