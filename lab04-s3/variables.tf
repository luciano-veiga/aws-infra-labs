variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto, usado como prefixo/tag em todos os recursos"
  type        = string
  default     = "aws-infra-labs"
}

variable "bucket_name" {
  description = "Nome do bucket S3. Deve ser globalmente único na AWS real; em ambiente local pode ser qualquer nome."
  type        = string
  default     = "aws-infra-labs-lab04-bucket"
}

variable "noncurrent_version_expiration_days" {
  description = "Dias para expirar versoes antigas de objetos (lifecycle), evitando custo indefinido de armazenamento de versoes historicas"
  type        = number
  default     = 90
}
