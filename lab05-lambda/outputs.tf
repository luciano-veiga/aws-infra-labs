output "bucket_name" {
  description = "Nome do bucket S3 que dispara a Lambda"
  value       = aws_s3_bucket.trigger_bucket.bucket
}

output "lambda_function_name" {
  description = "Nome da funcao Lambda criada"
  value       = aws_lambda_function.on_object_created.function_name
}

output "lambda_function_arn" {
  description = "ARN da funcao Lambda"
  value       = aws_lambda_function.on_object_created.arn
}

output "lambda_role_arn" {
  description = "ARN da IAM Role de execucao da Lambda"
  value       = aws_iam_role.lambda_role.arn
}
