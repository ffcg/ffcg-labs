locals {
	root_dir = "../${var.source_path}"
  services = [
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
}

resource "google_storage_bucket_object" "static_site" {
  for_each = fileset(local.root_dir, "**")
  name     = each.key
  source   = "${local.root_dir}/${each.key}"
  bucket   = google_storage_bucket.static_site.name
  cache_control = "no-store"
}

resource "google_storage_bucket" "static_site" {
  name          = var.name
  location      = "EU"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.static_site.name
  role = "roles/storage.objectViewer"
  member = "allUsers"
}