resource "aws_dynamodb_table" "users" {

  name = "ezm-user-table"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "userId"

  attribute {
    name = "userId"
    type = "S"
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_dynamodb_role" {

  name = "lambda-dynamodb-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for DynamoDB access
resource "aws_iam_role_policy" "lambda_policy" {

  role = aws_iam_role.lambda_role.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
        ]

        Resource = aws_dynamodb_table.users.arn
      },

      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "*"
      }
    ]
  })
}