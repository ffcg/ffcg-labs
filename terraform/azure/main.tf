module "static_site" {
  source      = "./modules/static_site"
  project     = var.project
  name        = "${var.prefix}serverlesslab"
  source_path = "../../public"
}