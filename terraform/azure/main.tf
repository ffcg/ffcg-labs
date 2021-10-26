module "static_site" {
  source      = "./modules/static_site"
  project     = var.project
  name        = "${var.prefix}storage"
  source_path = "../../public"
}