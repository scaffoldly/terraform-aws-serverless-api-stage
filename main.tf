
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
}

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.repository_name}-${var.stage}"
  tags = {}
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
  version = "1.0.0"

  api_id               = aws_api_gateway_rest_api.api.id
  api_root_resource_id = aws_api_gateway_rest_api.api.root_resource_id
  path                 = "health"

  response = {
    healty = true
  }
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
  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  domain_name = var.domain
  base_path   = var.path
}

module "iam" {
  source  = "scaffoldly/serverless-api-stage-iam/aws"
  version = "1.0.1"

  repository_name = var.repository_name
  stage           = var.stage
}
