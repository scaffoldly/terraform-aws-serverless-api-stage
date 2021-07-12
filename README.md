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

## Providers

## Modules

## Resources

## Inputs

## Outputs

<!-- END_TF_DOCS -->
