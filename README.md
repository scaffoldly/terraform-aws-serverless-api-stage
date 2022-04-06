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
| <a name="module_bucket"></a> [bucket](#module\_bucket) | scaffoldly/s3-private-versioned/aws | 1.0.2 |
| <a name="module_health"></a> [health](#module\_health) | scaffoldly/api-gateway-static-endpoint/aws | 1.0.1 |
| <a name="module_iam"></a> [iam](#module\_iam) | scaffoldly/serverless-api-stage-iam/aws | 1.0.6 |
| <a name="module_websocket"></a> [websocket](#module\_websocket) | scaffoldly/serverless-api-stage-websocket/aws | 1.0.7 |

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
| [aws_sns_topic.topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | The domain for the Serverless API | `string` | `""` | no |
| <a name="input_path"></a> [path](#input\_path) | The name of the Serverless API | `string` | n/a | yes |
| <a name="input_regional"></a> [regional](#input\_regional) | If true, create a regional Serverless API | `bool` | `false` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The GitHub Repository Name | `string` | n/a | yes |
| <a name="input_root_principal"></a> [root\_principal](#input\_root\_principal) | The root prinicipal. In most cases leave this as 'root' | `string` | `"root"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | The stage (e.g. live, nonlive) | `string` | n/a | yes |
| <a name="input_stage_kms_key_id"></a> [stage\_kms\_key\_id](#input\_stage\_kms\_key\_id) | The KMS Key ID for the stage (optional) | `string` | `""` | no |
| <a name="input_websocket"></a> [websocket](#input\_websocket) | (Optional) Enable a websocket for this stage | `bool` | `false` | no |
| <a name="input_websocket_domain"></a> [websocket\_domain](#input\_websocket\_domain) | (Optional) The custom domain for the websocket (if using a custom domain) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | The Rest API ID |
| <a name="output_base_path"></a> [base\_path](#output\_base\_path) | Computed path for the service, below the domain (/{servicename}) |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | n/a |
| <a name="output_domain"></a> [domain](#output\_domain) | Computed domain name (https://{domain}) |
| <a name="output_name"></a> [name](#output\_name) | Re-output of the stage name |
| <a name="output_rest_url"></a> [rest\_url](#output\_rest\_url) | Full HTTP url to the service |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
| <a name="output_root_resource_id"></a> [root\_resource\_id](#output\_root\_resource\_id) | The Rest API Root Resource ID |
| <a name="output_s3_topic_arn"></a> [s3\_topic\_arn](#output\_s3\_topic\_arn) | n/a |
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | n/a |
| <a name="output_url"></a> [url](#output\_url) | Full HTTP url to the service (https://{domain}/{servicename}) |
| <a name="output_websocket_api_id"></a> [websocket\_api\_id](#output\_websocket\_api\_id) | The websocket API ID, if enabled, otherwise null |
| <a name="output_websocket_url"></a> [websocket\_url](#output\_websocket\_url) | The websocket URL, if enabled, otherwise null |
<!-- END_TF_DOCS -->
