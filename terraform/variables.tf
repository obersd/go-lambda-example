variable "REGION" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "us-east-1"
}

variable "STAGE" {
  description = "The stage for the API Gateway"
  type        = string
  default     = "dev"
}

variable "AWS_LAMBDA_EXECUTION_ROLE" {
  description = "The IAM role for the Lambda function"
  type        = string
  default     = "arn:aws:iam::812214285793:role/RaintechAiDiagnosticsLambdaRole"
}

variable "DYNAMODB_TABLE_NOTES_NAME" {
  description = "The name of the DynamoDB table for notes"
  type        = string
  default     = "AdNotesTable"
}
