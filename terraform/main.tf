provider "aws" {
  region = var.REGION
}

resource "aws_dynamodb_table" "notes_table" {
  name         = var.DYNAMODB_TABLE_NOTES_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

  tags = {
    Environment = var.STAGE
    Project     = "goland-lambda"
  }
}

resource "aws_lambda_function" "goland_lambda" {
  function_name = "Adgoland-notes-api"
  filename      = "${path.module}/../cmd/lambda/lambda.zip"
  handler       = "bootstrap"
  runtime       = "provided.al2023"
  role          = var.AWS_LAMBDA_EXECUTION_ROLE
  source_code_hash = filebase64sha256("${path.module}/../cmd/lambda/lambda.zip")
}

resource "aws_api_gateway_rest_api" "http_api" {
  name        = "goland-rest-api"
  description = "API Gateway for managing notes"
}

resource "aws_api_gateway_resource" "notes_resource" {
  rest_api_id = aws_api_gateway_rest_api.http_api.id
  parent_id   = aws_api_gateway_rest_api.http_api.root_resource_id
  path_part   = "notes"
}

resource "aws_api_gateway_resource" "note_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.http_api.id
  parent_id   = aws_api_gateway_resource.notes_resource.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "create_note" {
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  resource_id   = aws_api_gateway_resource.notes_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_notes" {
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  resource_id   = aws_api_gateway_resource.notes_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_note" {
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  resource_id   = aws_api_gateway_resource.note_id_resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_method" "put_note" {
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  resource_id   = aws_api_gateway_resource.note_id_resource.id
  http_method   = "PUT"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_method" "delete_note" {
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  resource_id   = aws_api_gateway_resource.note_id_resource.id
  http_method   = "DELETE"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "notes_integration_post" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.notes_resource.id
  http_method             = aws_api_gateway_method.create_note.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.goland_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "notes_integration_get" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.notes_resource.id
  http_method             = aws_api_gateway_method.get_notes.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.goland_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "note_id_integration_get" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.note_id_resource.id
  http_method             = aws_api_gateway_method.get_note.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.goland_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "note_id_integration_put" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.note_id_resource.id
  http_method             = aws_api_gateway_method.put_note.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.goland_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "note_id_integration_delete" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.note_id_resource.id
  http_method             = aws_api_gateway_method.delete_note.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.goland_lambda.invoke_arn
}

resource "aws_api_gateway_stage" "dev_stage" {
  stage_name    = var.STAGE
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  deployment_id = aws_api_gateway_deployment.goland_api_deployment.id
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.goland_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.http_api.execution_arn}/${aws_api_gateway_stage.dev_stage.stage_name}/*/*"
  depends_on    = [aws_api_gateway_stage.dev_stage]
}

resource "aws_api_gateway_deployment" "goland_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.http_api.id

  depends_on = [
    aws_api_gateway_integration.notes_integration_post,
    aws_api_gateway_integration.notes_integration_get,
    aws_api_gateway_integration.note_id_integration_get,
    aws_api_gateway_integration.note_id_integration_put,
    aws_api_gateway_integration.note_id_integration_delete,
  ]
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.goland_lambda.function_name}"
  retention_in_days = 3

  lifecycle {
    create_before_destroy = true
  }
}

output "api_endpoint" {
  value = "https://${aws_api_gateway_rest_api.http_api.id}.execute-api.${var.REGION}.amazonaws.com/${var.STAGE}"
}
