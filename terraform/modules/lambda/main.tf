locals {
  source_bucket_arn = "arn:aws:s3:::${var.source_bucket_name}"
}

# Création propre et managée du rôle IAM
resource "aws_iam_role" "this" {
  name = "groupe-7-iac-image-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, { Name = "groupe-7-iac-image-processor-role" })
}

# Création de la politique associée au rôle
resource "aws_iam_role_policy" "this" {
  name = "groupe-7-iac-image-processor-policy"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          local.source_bucket_arn,
          "arn:aws:s3:::${var.source_bucket_name}/*",
          "arn:aws:s3:::${var.destination_bucket_name}/*"
        ]
      }
    ]
  })
}

# Création nominale de la fonction Lambda
resource "aws_lambda_function" "this" {
  filename         = var.lambda_zip_path
  function_name    = var.lambda_name
  role             = aws_iam_role.this.arn
  handler          = "handler.lambda_handler"
  runtime          = var.lambda_runtime
  source_code_hash = fileexists(var.lambda_zip_path) ? filebase64sha256(var.lambda_zip_path) : ""

  environment {
    variables = var.lambda_environment_variables
  }

  timeout = var.lambda_timeout
  tags    = merge(var.tags, { Name = var.lambda_name })
}

# Autorisation d'invocation par S3
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = local.source_bucket_arn
}

# Notification et déclencheur S3
resource "aws_s3_bucket_notification" "source_to_lambda" {
  bucket = var.source_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3,
    aws_lambda_function.this,
  ]
}