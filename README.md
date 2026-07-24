# aws-infra-labs

Laboratórios práticos de infraestrutura AWS provisionada via Terraform.
Cada pasta é um lab independente, com o objetivo de consolidar a base teórica dos certificados **AWS Cloud Practitioner** e **AWS Solutions Architect – Associate** em prática real, documentando as decisões de arquitetura por trás de cada recurso.

## Labs

| Lab | Descrição | Status |
|---|---|---|
| [lab01-vpc](./lab01-vpc) | VPC com subnets pública e privada, Internet Gateway e route tables | ✅ |
| [lab02-ec2](./lab02-ec2) | EC2 em subnet pública com security group restrito ao meu IP | ✅ |
| [lab03-iam](./lab03-iam) | IAM Role com least privilege (acesso restrito a um bucket S3) | ✅ |
| lab04-s3 | S3 bucket com política segura e versionamento | 🔜 |
| lab05-lambda | Lambda disparada por evento no S3 | 🔜 |

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.6
- Conta AWS com credenciais configuradas (`aws configure` ou variáveis de ambiente)
- AWS CLI instalado (opcional, útil para validar os recursos criados)

## Como rodar um lab

```bash
cd lab01-vpc
terraform init
terraform plan
terraform apply
```

Ao terminar de testar, sempre destrua os recursos para evitar custos:

```bash
terraform destroy
```

## Aviso

Estes labs usam free tier sempre que possível, mas **confira os custos antes de aplicar** em sua própria conta. O autor não se responsabiliza por cobranças gerados pelo uso destes exemplos.
