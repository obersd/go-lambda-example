variable "stage_name" {
  description = "The name of the API Gateway stage."
  type        = string
}

variable "region" {
  description = "The AWS region where the API Gateway will be created."
  type        = string
}

variable "create_note_arn" {
  description = "The ARN of the Lambda function for creating notes."
  type        = string
}

variable "delete_note_arn" {
  description = "The ARN of the Lambda function for deleting notes."
  type        = string
}

variable "get_note_arn" {
  description = "The ARN of the Lambda function for getting notes."
  type        = string
}

variable "list_notes_arn" {
  description = "The ARN of the Lambda function for listing notes."
  type        = string
}

variable "update_note_arn" {
  description = "The ARN of the Lambda function for updating notes."
  type        = string
}
