variable "project" {}
variable "function_name" {}
variable "function_entry_point" {}
variable "source_path" {}
variable "event_type" {
  description = "type of event to trigger on, see https://cloud.google.com/functions/docs/calling/"
}
variable "resource" {
  description = "The name or partial URI of the resource from which to observe events. For example, \"myBucket\" or \"projects/my-project/topics/my-topic\""
}