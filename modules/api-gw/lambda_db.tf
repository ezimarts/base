resource "aws_lambda_function" "register_user" {

  function_name = "register-user"

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  runtime = "python3.13"
  handler = "lambda_function.lambda_handler"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.users.name
    }
  }
}