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
variable "event_type" {
  description = "Type of event to trigger on, see https://cloud.google.com/functions/docs/calling/"
}
variable "resource" {
  description = "The name or partial URI of the resource from which to observe events. For example, 'myBucket' or 'projects/my-project/topics/my-topic'"
  type = string
}

variable "environment_variables" {
  description = "Environment variables to pass to the cloud function"
  type    = map(string)
  default = {}
}