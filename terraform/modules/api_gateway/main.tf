resource "aws_api_gateway_rest_api" "http_api" {
  name        = "go-rest-api"
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

# Métodos y sus integraciones

resource "aws_api_gateway_method" "create_note" {
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  resource_id   = aws_api_gateway_resource.notes_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_note" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.notes_resource.id
  http_method             = aws_api_gateway_method.create_note.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.create_note_invoke_arn
}

resource "aws_api_gateway_method" "get_notes" {
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  resource_id   = aws_api_gateway_resource.notes_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_notes" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.notes_resource.id
  http_method             = aws_api_gateway_method.get_notes.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.list_notes_invoke_arn
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

resource "aws_api_gateway_integration" "get_note" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.note_id_resource.id
  http_method             = aws_api_gateway_method.get_note.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_note_invoke_arn
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

resource "aws_api_gateway_integration" "put_note" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.note_id_resource.id
  http_method             = aws_api_gateway_method.put_note.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.update_note_invoke_arn
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

resource "aws_api_gateway_integration" "delete_note" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.note_id_resource.id
  http_method             = aws_api_gateway_method.delete_note.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.delete_note_invoke_arn
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.http_api.id
  depends_on = [
    aws_api_gateway_integration.create_note,
    aws_api_gateway_integration.get_notes,
    aws_api_gateway_integration.get_note,
    aws_api_gateway_integration.put_note,
    aws_api_gateway_integration.delete_note,
  ]
}

resource "aws_api_gateway_stage" "this" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  deployment_id = aws_api_gateway_deployment.this.id
}

resource "aws_lambda_permission" "create_note" {
  statement_id  = "AllowExecutionFromAPIGatewayCreateNote"
  action        = "lambda:InvokeFunction"
  function_name = var.create_note_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.http_api.execution_arn}/${var.stage_name}/*/*"
}

resource "aws_lambda_permission" "delete_note" {
  statement_id  = "AllowExecutionFromAPIGatewayDeleteNote"
  action        = "lambda:InvokeFunction"
  function_name = var.delete_note_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.http_api.execution_arn}/${var.stage_name}/*/*"
}

resource "aws_lambda_permission" "get_note" {
  statement_id  = "AllowExecutionFromAPIGatewayGetNote"
  action        = "lambda:InvokeFunction"
  function_name = var.get_note_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.http_api.execution_arn}/${var.stage_name}/*/*"
}

resource "aws_lambda_permission" "list_notes" {
  statement_id  = "AllowExecutionFromAPIGatewayListNotes"
  action        = "lambda:InvokeFunction"
  function_name = var.list_notes_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.http_api.execution_arn}/${var.stage_name}/*/*"
}

resource "aws_lambda_permission" "update_note" {
  statement_id  = "AllowExecutionFromAPIGatewayUpdateNote"
  action        = "lambda:InvokeFunction"
  function_name = var.update_note_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.http_api.execution_arn}/${var.stage_name}/*/*"
}
