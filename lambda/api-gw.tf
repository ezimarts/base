resource "aws_api_gateway_rest_api" "api" {
  name = "ezm-user-api"
}

resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_method" "post_users" {

  rest_api_id = aws_api_gateway_rest_api.api.id

  resource_id = aws_api_gateway_resource.users.id

  http_method = "POST"

  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {

  rest_api_id = aws_api_gateway_rest_api.api.id

  resource_id = aws_api_gateway_resource.users.id

  http_method = aws_api_gateway_method.post_users.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.hello_lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw" {

  statement_id = "AllowAPIGatewayInvoke"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.hello_lambda.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deployment" {

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "dev" {

  deployment_id = aws_api_gateway_deployment.deployment.id

  rest_api_id = aws_api_gateway_rest_api.api.id

  stage_name = "dev"
}

output "api_url" {

  value = "${aws_api_gateway_stage.dev.invoke_url}/users"
}

