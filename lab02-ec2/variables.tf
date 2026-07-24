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

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Bloco CIDR da subnet pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone onde a subnet será criada"
  type        = string
  default     = "us-east-1a"
}

variable "my_ip" {
  description = "Seu IP público, em formato CIDR (ex: 203.0.113.10/32), autorizado a acessar a instância via SSH. Descubra o seu com: curl -s https://checkip.amazonaws.com"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "ID da AMI a ser usada. Padrão: Amazon Linux 2023 (us-east-1). Ajuste se usar outra região."
  type        = string
  default     = "ami-0182f373e66f89c85"
}
