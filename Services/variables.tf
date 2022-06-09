variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "lambda_funtions" {
  type    = set(string)
  default = ["lambda_func_1", "lambda_func_2"]
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
  default     = "poc-spring-test-bucket"
}

variable "processed_prefix" {
  type        = string
  description = "Prefix for S3 objects"
  default     = "destination"
}

variable "function_1" {
  type        = string
  description = "Lambda function 1 name"
  default     = "lambda_func_1"
}

variable "function_2" {
  type        = string
  description = "Lambda function 2 name"
  default     = "lambda_func_2"
}

variable "queue_name" {
  type    = string
  default = "poc-sqs-queue"
}

variable "dead_letter_queue_name" {
  type    = string
  default = "poc-sqs-queue"
}
