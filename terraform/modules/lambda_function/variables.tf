variable "function_name" {
  type        = string
  description = "Name of a Lambda function"
}

variable "filename" {
  type        = string
  description = "Path to the zip file containing the Lambda function code"

}

variable "role" {
  type        = string
  description = "IAM role that Lambda assumes when it executes the function"
}
