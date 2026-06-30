variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "eu-west-3"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile name to use for credentials"
  default     = ""
}

variable "aws_shared_credentials_file" {
  type        = string
  description = "Path to AWS shared credentials file"
  default     = ""
}

variable "bucket_name_prefix" {
  type        = string
  description = "Base prefix used for bucket and resource naming"
  default     = "groupe-7-iac"
}

variable "lambda_name" {
  type        = string
  description = "Name of the Lambda function"
  default     = "groupe-7-iac-image-processor"
}

variable "lambda_zip_path" {
  type        = string
  description = "Local path to the Lambda deployment package"
  default     = ""
}

variable "common_tags" {
  type        = map(string)
  description = "Additional tags applied to AWS resources"
  default     = {}
}

variable "lambda_timeout" {
  type        = number
  description = "Timeout in seconds for the Lambda function"
  default     = 60
}

variable "lambda_log_retention" {
  type        = number
  description = "CloudWatch log retention in days"
  default     = 14
}

variable "enable_bucket_versioning" {
  type        = bool
  description = "Enable versioning on the S3 buckets"
  default     = true
}

variable "lambda_runtime" {
  type        = string
  description = "Runtime used by the Lambda function"
  default     = "python3.13"
}
