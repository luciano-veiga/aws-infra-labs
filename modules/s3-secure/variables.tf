variable "bucket_name" {
  description = "Nome do bucket S3 a ser criado. Deve ser globalmente único."
  type        = string
}

variable "enable_versioning" {
  description = "Habilita versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Aceita 'AES256' ou 'aws:kms'."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_id" {
  description = "ARN da chave KMS a usar quando sse_algorithm = 'aws:kms'. Ignorado se sse_algorithm = 'AES256'."
  type        = string
  default     = null
}

variable "block_public_access" {
  description = "Bloqueia todo acesso público ao bucket (recomendado manter true)."
  type        = bool
  default     = true
}

variable "enforce_https" {
  description = "Adiciona bucket policy que nega qualquer requisição feita fora de HTTPS (aws:SecureTransport)."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite que o Terraform destrua o bucket mesmo se ele contiver objetos. Útil em ambientes de teste (ex: ministack); evite em produção."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
