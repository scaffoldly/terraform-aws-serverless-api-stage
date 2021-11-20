[![Maintained by Scaffoldly](https://img.shields.io/badge/maintained%20by-scaffoldly-blueviolet)](https://github.com/scaffoldly)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/scaffoldly/terraform-aws-serverless-api-stage)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.15.0-blue.svg)

## Description

Configure API Gateway for a Serverless API on a given stage:

- Rest API
- Cloudwatch Log Group
- Generalized CORS Response Templates
- Health Endpoint
- First deployment for the Health Endpoint
- A Stage with Logging Configuration
- The Base Path Mapping
- IAM Roles

## Usage

```hcl
module "stage" {
  source = "scaffoldly/serverless-api-stage/aws"

  for_each = var.stage_domains

  domain         = lookup(each.value, "serverless_api_domain", "unknown-domain")
  stage_env_vars = lookup(each.value, "stage_env_vars", {})

  name  = var.name
  stage = each.key

  repository_name = module.repository.name

  depends_on = [
    module.repository
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0, < 1.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.55.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_health"></a> [health](#module\_health) | scaffoldly/api-gateway-static-endpoint/aws | 1.0.1 |
| <a name="module_iam"></a> [iam](#module\_iam) | scaffoldly/serverless-api-stage-iam/aws | 1.0.2 |
| <a name="module_websocket"></a> [websocket](#module\_websocket) | scaffoldly/serverless-api-stage-websocket/aws | 1.0.6 |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_base_path_mapping.mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_deployment.deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_gateway_response.cors_responses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_gateway_response) | resource |
| [aws_api_gateway_method_settings.settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_rest_api.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_cloudwatch_log_group.execution_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | The domain for the Serverless API | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | The name of the Serverless API | `string` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The GitHub Repository Name | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | The stage (e.g. live, nonlive) | `string` | n/a | yes |
| <a name="input_websocket"></a> [websocket](#input\_websocket) | (Optional) Enable a websocket for this stage | `bool` | `false` | no |
| <a name="input_websocket_domain"></a> [websocket\_domain](#input\_websocket\_domain) | (Optional) The custom domain for the websocket (if using a custom domain) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | The Rest API ID |
| <a name="output_base_path"></a> [base\_path](#output\_base\_path) | Computed path for the service, below the domain (/{servicename}) |
| <a name="output_domain"></a> [domain](#output\_domain) | Computed domain name (https://{domain}) |
| <a name="output_name"></a> [name](#output\_name) | Re-output of the stage name |
| <a name="output_root_resource_id"></a> [root\_resource\_id](#output\_root\_resource\_id) | The Rest API Root Resource ID |
| <a name="output_url"></a> [url](#output\_url) | Full HTTP url to the service (https://{domain}/{servicename}) |
| <a name="output_websocket_api_id"></a> [websocket\_api\_id](#output\_websocket\_api\_id) | The websocket API ID, if enabled, otherwise null |
| <a name="output_websocket_url"></a> [websocket\_url](#output\_websocket\_url) | The websocket URL, if enabled, otherwise null |
<!-- END_TF_DOCS -->
