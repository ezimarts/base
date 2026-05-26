# modules/api-gw/variables.tf

variable "api_name" {
  type = string
  default = "test-api"
}

variable "lambda_invoke_arn" {
  type = string
}

variable "lambda_function_name" {
  type = string
  default = "user-table-lambda"
}