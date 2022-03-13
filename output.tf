output "api_id" {
  value       = aws_api_gateway_rest_api.api.id
  description = "The Rest API ID"
}

output "root_resource_id" {
  value       = aws_api_gateway_rest_api.api.root_resource_id
  description = "The Rest API Root Resource ID"
}

output "name" {
  value       = var.stage
  description = "Re-output of the stage name"
}

output "domain" {
  value       = "https://${var.domain}"
  description = "Computed domain name (https://{domain})"
}

output "base_path" {
  value       = "/${var.path}"
  description = "Computed path for the service, below the domain (/{servicename})"
}

output "url" {
  value       = "https://${var.domain}/${var.path}"
  description = "Full HTTP url to the service (https://{domain}/{servicename})"
}

output "rest_url" {
  value       = var.domain ? "https://${var.domain}/${var.path}" : aws_api_gateway_stage.stage.invoke_url
  description = "Full HTTP url to the service (https://{domain}/{servicename})"
}

output "websocket_api_id" {
  value       = var.websocket ? module.websocket[0].api_id : null
  description = "The websocket API ID, if enabled, otherwise null"
}

output "websocket_url" {
  value       = var.websocket ? module.websocket[0].url : null
  description = "The websocket URL, if enabled, otherwise null"
}

output "role_arn" {
  value = module.iam.role_arn
}

output "topic_arn" {
  value = aws_sns_topic.topic.arn
}
