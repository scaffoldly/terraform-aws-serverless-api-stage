variable "domain" {
  type        = string
  description = "The domain for the Serverless API"
  default     = ""
}
variable "repository_name" {
  type        = string
  description = "The GitHub Repository Name"
}
variable "path" {
  type        = string
  description = "The name of the Serverless API"
  default     = ""
}
variable "stage" {
  type        = string
  description = "The stage (e.g. live, nonlive)"
}
variable "regional" {
  type        = bool
  description = "If true, create a regional Serverless API"
  default     = false
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
variable "root_principal" {
  type        = string
  default     = "root"
  description = "The root prinicipal. In most cases leave this as 'root'"
}
variable "stage_kms_key_id" {
  type        = string
  default     = ""
  description = "The KMS Key ID for the stage (optional)"
}
variable "create_bucket" {
  type        = bool
  default     = true
  description = "Create an S3 Bucket for the Service"
}
variable "bucket_allow_public_access" {
  type        = bool
  default     = false
  description = "Allow Objects in the bucket with a Public ACL"
}
variable "bucket_name" {
  type        = string
  default     = ""
  description = "Set the bucket name, default: var.repository_name"
}
variable "create_topic" {
  type        = bool
  default     = true
  description = "Create SNS Topics for the service"
}
