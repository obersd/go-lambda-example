provider "aws" {
  region = var.REGION
}

module "lambda_create_note" {
  source        = "./modules/lambda_function"
  function_name = "AdCreate_note"
  filename      = "${path.module}/../bin/create-note/lambda.zip"
  role          = var.AWS_LAMBDA_EXECUTION_ROLE
}

module "lambda_delete_note" {
  source        = "./modules/lambda_function"
  function_name = "AdDelete_note"
  filename      = "${path.module}/../bin/delete-note/lambda.zip"
  role          = var.AWS_LAMBDA_EXECUTION_ROLE
}

module "lambda_get_note" {
  source        = "./modules/lambda_function"
  function_name = "AdGet_note"
  filename      = "${path.module}/../bin/get-note/lambda.zip"
  role          = var.AWS_LAMBDA_EXECUTION_ROLE
}

module "lambda_list_notes" {
  source        = "./modules/lambda_function"
  function_name = "AdList_notes"
  filename      = "${path.module}/../bin/list-notes/lambda.zip"
  role          = var.AWS_LAMBDA_EXECUTION_ROLE
}

module "lambda_update_note" {
  source        = "./modules/lambda_function"
  function_name = "AdUpdate_note"
  filename      = "${path.module}/../bin/update-note/lambda.zip"
  role          = var.AWS_LAMBDA_EXECUTION_ROLE
}

module "api_gateway" {
  source = "./modules/api_gateway"

  stage_name = var.STAGE
  region     = var.REGION

  create_note_function_name = module.lambda_create_note.function_name
  create_note_invoke_arn    = module.lambda_create_note.invoke_arn

  delete_note_function_name = module.lambda_delete_note.function_name
  delete_note_invoke_arn    = module.lambda_delete_note.invoke_arn

  get_note_function_name    = module.lambda_get_note.function_name
  get_note_invoke_arn       = module.lambda_get_note.invoke_arn

  list_notes_function_name  = module.lambda_list_notes.function_name
  list_notes_invoke_arn     = module.lambda_list_notes.invoke_arn

  update_note_function_name = module.lambda_update_note.function_name
  update_note_invoke_arn    = module.lambda_update_note.invoke_arn
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
    Project     = "go-lambda-example"
  }
}

output "api_endpoint" {
  value = module.api_gateway.api_url
}
