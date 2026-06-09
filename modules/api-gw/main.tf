# modules/api-gw/main.tf

resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "REST API for Lambda integration"
}

# /users resource
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
}

# POST method
resource "aws_api_gateway_method" "post_users" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "POST"
  authorization = "NONE"
}

# API Gateway -> Lambda integration
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.users.id
  http_method             = aws_api_gateway_method.post_users.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = var.lambda_invoke_arn
}

# Request model
resource "aws_api_gateway_model" "user_model" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "UserModel"
  content_type = "application/json"

  schema = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#"
    title     = "UserModel"
    type      = "object"

    properties = {
      userId = {
        type = "string"
      }
      name = {
        type = "string"
      }
      email = {
        type = "string"
      }
    }

    required = ["userId", "name", "email"]
  })
}

# Request validator
resource "aws_api_gateway_request_validator" "validator" {
  rest_api_id                 = aws_api_gateway_rest_api.api.id
  name                        = "request-validator"
  validate_request_body       = true
  validate_request_parameters = false
}

# Attach model to POST method
resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.dev.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

# Deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
}

# Stage
resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"
}

# Lambda permission
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}