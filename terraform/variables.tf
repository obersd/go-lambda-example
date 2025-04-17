variable "REGION" {
  type        = string
  description = "The AWS region to deploy the resources in"
  default     = "us-east-1"
}

variable "STAGE" {
  type        = string
  description = "The stage for the API Gateway"
  default     = "dev"
}

variable "AWS_LAMBDA_EXECUTION_ROLE" {
  type        = string
  description = "The IAM role for the Lambda function"
  default     = "arn:aws:iam::123456789012:role/LAMBDA_ROLE"
}

variable "DYNAMODB_TABLE_NOTES_NAME" {
  type = string
  description = "The name of the DynamoDB table for notes"
  default     = "AdNotesTable"
}
