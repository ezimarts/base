# terraform {

#   required_providers {

#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }

#     archive = {
#       source  = "hashicorp/archive"
#       version = "~> 2.4"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }

# Package Lambda automatically
data "archive_file" "lambda_zip" {

  type = "zip"

  source_file = "${path.module}/lambda_function.py"

  output_path = "${path.module}/lambda.zip"
}

# IAM Role
resource "aws_iam_role" "lambda_role" {

  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
        Effect = "Allow"
        action = "sts:AssumeRole"

        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }]
    ]
  })
}

# IAM Policy for CloudWatch logs
resource "aws_iam_role_policy_attachment" "lambda_basic" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "hello_lambda" {

  function_name = "hello-world-lambda"

  filename = data.archive_file.lambda_zip.output_path

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role = aws_iam_role.lambda_role.arn

  handler = "lambda_function.lambda_handler"

  runtime = "python3.12"
}

output "lambda_name" {
  value = aws_lambda_function.hello_lambda.function_name
}

resource "aws_lambda_function_url" "url" {

  function_name = aws_lambda_function.hello_lambda.function_name

  authorization_type = "NONE"
}

resource "aws_lambda_permission" "url_permission" {

  statement_id = "AllowPublicAccess"

  action = "lambda:InvokeFunctionUrl"

  function_name = aws_lambda_function.hello_lambda.function_name

  principal = "*"

  function_url_auth_type = "NONE"
}

output "lambda_url" {
  value = aws_lambda_function_url.url.function_url
}