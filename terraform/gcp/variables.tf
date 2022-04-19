variable "project" {
  default = "serverless-labs-328806"
}

variable "region" {
  default = "europe-west1"
}


variable "prefix" {
  type        = string
  description = "The initials or similar of the student for the lab, e.g. ja for John Anderson. Will be used to prefix resources."
}
