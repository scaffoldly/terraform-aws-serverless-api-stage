
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  cors_response_types = {
    ACCESS_DENIED = {
      status_code = 403
    }
    API_CONFIGURATION_ERROR = {
      status_code = 500
    }
    AUTHORIZER_CONFIGURATION_ERROR = {
      status_code = 500
    }
    AUTHORIZER_FAILURE = {
      status_code = 500
    }
    BAD_REQUEST_PARAMETERS = {
      status_code = 400
    }
    BAD_REQUEST_BODY = {
      status_code = 400
    }
    DEFAULT_4XX = {
      status_code = null
    }
    DEFAULT_5XX = {
      status_code = null
    }
    EXPIRED_TOKEN = {
      status_code = 403
    }
    INTEGRATION_FAILURE = {
      status_code = 504
    }
    INTEGRATION_TIMEOUT = {
      status_code = 504
    }
    INVALID_API_KEY = {
      status_code = 403
    }
    INVALID_SIGNATURE = {
      status_code = 403
    }
    MISSING_AUTHENTICATION_TOKEN = {
      status_code = 403
    }
    QUOTA_EXCEEDED = {
      status_code = 429
    }
    REQUEST_TOO_LARGE = {
      status_code = 413
    }
    RESOURCE_NOT_FOUND = {
      status_code = 404
    }
    THROTTLED = {
      status_code = 429
    }
    UNAUTHORIZED = {
      status_code = 401
    }
    UNSUPPORTED_MEDIA_TYPE = {
      status_code = 415
    }
    WAF_FILTERED = {
      status_code = 403
    }
  }

  root_arn = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:${var.root_principal}"
}

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.repository_name}-${var.stage}"
  tags = {}

  endpoint_configuration {
    types = [var.regional ? "REGIONAL" : "EDGE"]
  }
}

resource "aws_cloudwatch_log_group" "group" {
  name              = "/aws/apigateway/${var.repository_name}-${var.stage}"
  retention_in_days = 1
  tags              = {}
}

resource "aws_cloudwatch_log_group" "execution_group" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/${var.stage}"
  retention_in_days = 1
  tags              = {}
}

resource "aws_api_gateway_gateway_response" "cors_responses" {
  for_each = local.cors_response_types

  rest_api_id   = aws_api_gateway_rest_api.api.id
  response_type = each.key
  status_code   = each.value.status_code

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'*'"
  }

  response_templates = {
    "application/json" = "{\"error\":\"${each.key}\",\"message\":$context.error.messageString,\"context\":{}}"
  }
}

module "health" {
  source  = "scaffoldly/api-gateway-static-endpoint/aws"
  version = "1.0.3"

  api_id               = aws_api_gateway_rest_api.api.id
  api_root_resource_id = aws_api_gateway_rest_api.api.root_resource_id
  path                 = "health"

  response = {
    healthy = true
  }

  depends_on = [
    aws_api_gateway_rest_api.api
  ]
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id       = aws_api_gateway_rest_api.api.id
  stage_name        = "bootstrap"
  stage_description = "A basic stage created to remediate a race condition in API Gateway"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    module.health
  ]
}

resource "aws_api_gateway_stage" "stage" {
  stage_name    = var.stage
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  tags          = {}
  variables     = {}

  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.group.arn
    format          = "$context.identity.sourceIp $context.identity.caller $context.identity.user [$context.requestTime] \"$context.httpMethod $context.resourcePath $context.protocol\" $context.status $context.responseLength $context.requestId"
  }

  depends_on = [aws_cloudwatch_log_group.group]

  lifecycle {
    ignore_changes = [
      deployment_id
    ]
  }
}

resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "INFO"

    throttling_rate_limit  = 10000
    throttling_burst_limit = 5000
  }
}

resource "aws_api_gateway_base_path_mapping" "mapping" {
  count = var.domain != "" ? 1 : 0

  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  domain_name = var.domain
  base_path   = var.path
}

module "websocket" {
  count = var.websocket == true ? 1 : 0

  source  = "scaffoldly/serverless-api-stage-websocket/aws"
  version = "1.0.9"

  repository_name = var.repository_name
  path            = var.path
  stage           = var.stage
  logs_arn        = aws_cloudwatch_log_group.group.arn
  domain          = var.websocket_domain
}

module "iam" {
  source  = "scaffoldly/serverless-api-stage-iam/aws"
  version = "1.0.16"

  repository_name = var.repository_name
  stage           = var.stage
  kms_key_id      = var.stage_kms_key_id
  saml_trust      = var.saml_trust
}

resource "aws_sns_topic" "topic" {
  count = var.create_topic ? 1 : 0

  name         = "${var.stage}-${var.repository_name}"
  display_name = "${var.stage}-${var.repository_name}"
}

resource "aws_sns_topic_policy" "policy" {
  count = var.create_topic ? 1 : 0

  arn = aws_sns_topic.topic[0].arn

  policy = templatefile("${path.module}/topic_policy.json.tpl", {
    topic_arn             = aws_sns_topic.topic[0].arn
    read_only_pattern     = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/*-nonlive"
    read_only_principals  = jsonencode([local.root_arn])
    read_write_principals = jsonencode([local.root_arn, module.iam.role_arn])
    write_only_principals = jsonencode([local.root_arn])
  })
}

module "bucket" {
  count = var.create_bucket ? 1 : 0

  source  = "scaffoldly/s3-private-versioned/aws"
  version = "1.0.9"

  bucket_name_prefix        = var.bucket_name != "" ? var.bucket_name : "${var.stage}-${var.repository_name}"
  bucket_name_random_suffix = var.bucket_name == "" ? true : false

  read_write_principals = [
    module.iam.role_arn
  ]

  notification_prefixes = [""]
  public_access         = var.bucket_allow_public_access
}
