import {
  to = module.lambda_processor.aws_iam_role.this
  id = "groupe-7-iac-image-processor-role"
}

import {
  to = module.lambda_processor.aws_lambda_function.this
  id = "groupe-7-iac-image-processor"
}

locals {
  common_tags = merge(
    {
      Project = "ynov-iac-2025"
      equipe  = "groupe-7"
    },
    var.common_tags
  )

  suffix                  = random_id.resource_suffix.hex
  source_bucket_name      = "${var.bucket_name_prefix}-source-${local.suffix}"
  destination_bucket_name = "${var.bucket_name_prefix}-destination-${local.suffix}"
  lambda_name             = var.lambda_name
  lambda_package          = var.lambda_zip_path != "" ? var.lambda_zip_path : "${path.module}/lambda_package.zip"
}

resource "random_id" "resource_suffix" {
  byte_length = 4
}

module "source_bucket" {
  source             = "./modules/s3_bucket"
  bucket_name        = local.source_bucket_name
  versioning_enabled = var.enable_bucket_versioning
  tags               = local.common_tags
}

module "destination_bucket" {
  source             = "./modules/s3_bucket"
  bucket_name        = local.destination_bucket_name
  versioning_enabled = var.enable_bucket_versioning
  tags               = local.common_tags
}

module "lambda_processor" {
  source                  = "./modules/lambda"
  lambda_name             = local.lambda_name
  lambda_zip_path         = local.lambda_package
  source_bucket_name      = module.source_bucket.bucket_name
  destination_bucket_name = module.destination_bucket.bucket_name
  lambda_environment_variables = {
    DEST_BUCKET = module.destination_bucket.bucket_name
  }
  lambda_runtime = var.lambda_runtime
  lambda_timeout = var.lambda_timeout
  tags           = local.common_tags
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${module.lambda_processor.lambda_name}"
  retention_in_days = var.lambda_log_retention
  tags              = local.common_tags
}