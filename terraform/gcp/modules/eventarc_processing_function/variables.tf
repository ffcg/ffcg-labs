variable "project" {
  description = "Google gcloud project ID to deploy function to"
  type = string
}

variable "function_name" {
  description = "Name of the function to deploy"
  type = string
}
variable "function_entry_point" {
  description = "Method name in the source file that should be called on event"
  type = string
}
variable "source_path" {
  description = "Path to the source to deploy in the cloud function"
  type = string
}

variable "environment_variables" {
  description = "Environment variables to pass to the cloud function"
  type    = map(string)
  default = {}
}

variable "region" {
  description = "Region to run the variable in"
}
