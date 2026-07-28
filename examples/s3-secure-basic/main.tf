terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Provider AWS "real" por padrão.
# Para testar contra o ministack, descomente o bloco de override abaixo
# (mesmo padrão usado nos demais labs deste repositório).
provider "aws" {
  region = "us-east-1"

  # --- Override para ministack (descomentar para testes locais) ---
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://localhost:4566"
  }
}

module "bucket_teste" {
  source = "../../modules/s3-secure"

  bucket_name   = "s3-secure-example-bucket"
  force_destroy = true # facilita apply/destroy repetido durante teste

  tags = {
    Ambiente = "teste"
    Origem   = "modulo-s3-secure"
  }
}

output "bucket_criado" {
  value = module.bucket_teste.bucket_id
}

output "versionamento" {
  value = module.bucket_teste.versioning_status
}
