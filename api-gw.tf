resource "aws_api_gateway_rest_api" "api" {
  name = "lambda-api"
}

resource "aws_apigatewayv2_api" "api" {
  name          = "ezimarts-api"
  protocol_type = "HTTP"
}

# API Gateway integration with Lambda
resource "aws_apigatewayv2_integration" "signup_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  integration_uri  = aws_lambda_function.signup.invoke_arn
}


resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
}
# Route (/signup)
resource "aws_apigatewayv2_route" "signup" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /signup"
  target    = "integrations/${aws_apigatewayv2_integration.signup_integration.id}"
}

#allow API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signup.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

#method

resource "aws_api_gateway_method" "get_users" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "GET"
  authorization = "NONE"
}

#lambda-integration

resource "aws_api_gateway_integration" "get_users" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.users.id
  http_method             = aws_api_gateway_method.get_users.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

#deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.get_users]
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "test" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "test"
  deployment_id = aws_api_gateway_deployment.deployment.id
}