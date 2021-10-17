module "static_site" {
  source      = "./modules/static_site"
  project     = var.project
  prefix      = var.initials
  source_path = "../../public"
}