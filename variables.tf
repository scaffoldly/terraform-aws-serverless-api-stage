variable "domain" {
  type        = string
  description = "The domain for the Serverless API"
}
variable "name" {
  type        = string
  description = "The name of the Serverless API"
}
variable "stage" {
  type        = string
  description = "The stage (e.g. live, nonlive)"
}
variable "stage_env_vars" {
  type        = map(string)
  description = "The Key-Value Pairs for all environment variables for a Service's Stage"
}
variable "repository_name" {
  type        = string
  description = "The GitHub Repository Name"
}
