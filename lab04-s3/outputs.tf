output "bucket_name" {
  description = "Nome do bucket S3 criado"
  value       = aws_s3_bucket.data.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3"
  value       = aws_s3_bucket.data.arn
}

output "versioning_status" {
  description = "Status do versionamento do bucket"
  value       = aws_s3_bucket_versioning.data.versioning_configuration[0].status
}
