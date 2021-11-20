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

variable "websocket" {
  type        = bool
  description = "(Optional) Enable a websocket for this stage"
  default     = false
}

variable "websocket_domain" {
  type        = string
  description = "(Optional) The custom domain for the websocket (if using a custom domain)"
  default     = ""
}

