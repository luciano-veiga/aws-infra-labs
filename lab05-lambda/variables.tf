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
  description = "Nome do bucket S3 que dispara a Lambda. Deve ser globalmente único na AWS real."
  type        = string
  default     = "aws-infra-labs-lab05-bucket"
}
