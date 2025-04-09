variable "function_name" {
  description = "Name of a Lambda function"
  type = string
}

variable "filename" {
  description = "Path to the zip file containing the Lambda function code"
  type = string
}

variable "role" {
  description = "IAM role that Lambda assumes when it executes the function"
  type = string
}
