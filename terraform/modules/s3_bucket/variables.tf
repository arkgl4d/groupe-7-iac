variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable bucket versioning"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the bucket"
  default     = {}
}
