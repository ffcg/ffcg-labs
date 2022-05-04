output "public_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.static_site.name}/${google_storage_bucket.static_site.website[0].main_page_suffix}"
}
