provider "aws" {
  region                   = var.aws_region
  profile                  = var.aws_profile != "" ? var.aws_profile : null
  shared_credentials_files = var.aws_shared_credentials_file != "" ? [var.aws_shared_credentials_file] : null
  assume_role {
    role_arn     = var.aws_assume_role_arn
    session_name = "groupe-7-iac-terraform"
  }
  default_tags {
    tags = local.common_tags
  }
}
