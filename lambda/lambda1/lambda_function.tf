data "archive_file" "lambda_zip" {
    type        = "zip"
    
    source_file = "${path.root}/lambda_function.py"
    output_path = "${path.root}/lambda.zip"
}

resource "aws_lambda_function" "hello_lambda" {
    function_name = "hello-world-lambda-v2"
    
    filename         = data.archive_file.lambda_zip.output_path
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    
    role    = aws_iam_role.lambda_role.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.12"
}

resource "aws_iam_role" "lambda_role" {
    name = "lambda-role"
    
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

resource "aws_iam_role_policy_attachment" "lambda_basic" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "lambda_name" {
    value = aws_lambda_function.hello_lambda.function_name
}

resource "aws_lambda_function_url" "url" {
    function_name = aws_lambda_function.hello_lambda.function_name
    authorization_type = "NONE"
}

