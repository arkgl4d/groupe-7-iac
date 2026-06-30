output "source_bucket_name" {
  value = module.source_bucket.bucket_name
}

output "destination_bucket_name" {
  value = module.destination_bucket.bucket_name
}

output "lambda_function_name" {
  value = module.lambda_processor.lambda_name
}

output "lambda_function_arn" {
  value = module.lambda_processor.lambda_arn
}
