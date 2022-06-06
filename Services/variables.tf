variable "lambda_funtions" {
  type    = set(string)
  default = ["lambda_func_1", "lambda_func_2"]
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
