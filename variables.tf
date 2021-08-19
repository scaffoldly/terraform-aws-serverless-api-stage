variable "domain" {
  type        = string
  description = "The domain for the Serverless API"
}
variable "repository_name" {
  type        = string
  description = "The GitHub Repository Name"
}
variable "path" {
  type        = string
  description = "The name of the Serverless API"
}
variable "stage" {
  type        = string
  description = "The stage (e.g. live, nonlive)"
}

