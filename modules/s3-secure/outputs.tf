output "bucket_id" {
  description = "Nome (ID) do bucket criado."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket criado."
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "Domínio regional do bucket (útil para referenciar em outros recursos, ex: CloudFront)."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status atual do versionamento aplicado."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}
