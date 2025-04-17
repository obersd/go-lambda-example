resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  filename         = var.filename
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  role             = var.role
  source_code_hash = filebase64sha256(var.filename)
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 3

  lifecycle {
    create_before_destroy = true
  }
}

output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}
