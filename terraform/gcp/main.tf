module "http_function" {
  source               = "./modules/http_function"
  project              = var.project
  function_name        = "hello-world"
  function_entry_point = "helloWorld"
  function_source_path = "./src"
}