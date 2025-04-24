resource "aws_iam_role" "lambda_role" {
  name = "lambda_alb_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
  type                    = "zip"
  source_content          = file("${path.module}/lambda.py")
  source_content_filename = "lambda.py"
  output_path             = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "headers_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "display-request-headers"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout     = 15
  memory_size = 128
}

# Permission for ALB to invoke Lambda
resource "aws_lambda_permission" "alb_invoke" {
  statement_id  = "AllowALBInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.headers_lambda.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
}

# Target group with Lambda
resource "aws_lb_target_group" "lambda_tg" {
  name        = "lambda-headers-tg"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "lambda_tg_attachment" {
  target_group_arn = aws_lb_target_group.lambda_tg.arn
  target_id        = aws_lambda_function.headers_lambda.arn
  depends_on       = [aws_lambda_permission.alb_invoke]
}
