variable "lambda_name" {
  type        = string
  description = "Lambda function name"
}

variable "lambda_zip_path" {
  type        = string
  description = "Path to the deployment package zip file"
}

variable "source_bucket_name" {
  type        = string
  description = "Source S3 bucket name"
}

variable "destination_bucket_name" {
  type        = string
  description = "Destination S3 bucket name"
}

variable "lambda_environment_variables" {
  type        = map(string)
  description = "Environment variables for the Lambda function"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Lambda resources"
  default     = {}
}

variable "lambda_runtime" {
  type        = string
  description = "Runtime used by the Lambda function"
  default     = "python3.11"
}

variable "lambda_timeout" {
  type        = number
  description = "Timeout in seconds for the Lambda function"
  default     = 60
}
