output "role_arn" {
  description = "ARN da IAM Role criada"
  value       = aws_iam_role.app_role.arn
}

output "policy_arn" {
  description = "ARN da IAM Policy de least privilege criada"
  value       = aws_iam_policy.s3_least_privilege.arn
}

output "instance_profile_name" {
  description = "Nome do instance profile, usado para anexar a role a uma instancia EC2"
  value       = aws_iam_instance_profile.app_profile.name
}

output "bucket_name" {
  description = "Nome do bucket S3 de exemplo"
  value       = aws_s3_bucket.app_bucket.bucket
}
