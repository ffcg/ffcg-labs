module "http_function" {
  source               = "./modules/http_function"
  project              = var.project
  function_name        = "hello-world"
  function_entry_point = "helloWorld"
  source_path = "./src"
}

module "static_site" {
  source      = "./modules/static_site"
  project     = var.project
  source_path = "./public"
}