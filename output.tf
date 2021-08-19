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
