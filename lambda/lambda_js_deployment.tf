data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.js"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "signup" {
  function_name = "ezimarts_signup"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "nodejs18.x"
  handler       = "index.handler"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}