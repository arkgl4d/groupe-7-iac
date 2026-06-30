locals {
  source_bucket_arn = "arn:aws:s3:::${var.source_bucket_name}"
}

data "aws_iam_role" "this" {
  name = "groupe-7-iac-image-processor-role"
}

resource "aws_iam_role_policy" "this" {
  name = "${var.lambda_name}-policy"
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

resource "aws_lambda_function" "this" {
  filename         = var.lambda_zip_path
  function_name    = var.lambda_name
  role             = aws_iam_role.this.arn
  handler          = "handler.lambda_handler"
  runtime          = var.lambda_runtime
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = var.lambda_environment_variables
  }

  timeout = var.lambda_timeout
  tags    = merge(var.tags, { Name = var.lambda_name })
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = local.source_bucket_arn
}

COMMENTE TEMPORAIREMENT CE BLOC :
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