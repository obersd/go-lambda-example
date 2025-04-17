variable "stage_name" {
  type        = string
  description = "The name of the API Gateway stage."
}

variable "region" {
  type        = string
  description = "The AWS region where the API Gateway is deployed."
  default     = "us-east-1"
}

# CREATE
variable "create_note_function_name" {
  type        = string
  description = "The name of the Lambda function for creating notes."
}

variable "create_note_invoke_arn" {
  type        = string
  description = "The ARN of the Lambda function for creating notes."
}

# DELETE
variable "delete_note_function_name" {
  type        = string
  description = "The name of the Lambda function for deleting notes."
}

variable "delete_note_invoke_arn" {
  type        = string
  description = "The ARN of the Lambda function for deleting notes."
}

# GET
variable "get_note_function_name" {
  type        = string
  description = "The name of the Lambda function for getting a note."
}

variable "get_note_invoke_arn" {
  type        = string
  description = "The ARN of the Lambda function for getting a note."
}

# LIST
variable "list_notes_function_name" {
  type        = string
  description = "The name of the Lambda function for listing notes."
}

variable "list_notes_invoke_arn" {
  type        = string
  description = "The ARN of the Lambda function for listing notes."
}

# UPDATE
variable "update_note_function_name" {
  type        = string
  description = "The name of the Lambda function for updating notes."
}

variable "update_note_invoke_arn" {
  type        = string
  description = "The ARN of the Lambda function for updating notes."
}
