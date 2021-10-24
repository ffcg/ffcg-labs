variable "project" {
  default = "serverless-labs-328806"
}

variable "initials" {
  type = string
  description = "The initials or similar of the student for the lab, e.g. ja for John Anderson. Will be used to prefix resources."
}
