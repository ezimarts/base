# modules/api-gw/outputs.tf

output "api_url" {
  value = "${aws_api_gateway_stage.dev.invoke_url}/users"
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.api.id
}