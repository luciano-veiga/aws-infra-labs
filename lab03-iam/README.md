# Lab 03 — IAM Role com Least Privilege

## Objetivo

Criar uma IAM Role para uma instância EC2 que tenha **apenas** as permissões estritamente necessárias — neste caso, ler e escrever objetos em um único bucket S3 específico. Nada de `AdministratorAccess`, nada de `Resource = "*"`.

## Por que isso importa

O erro mais comum (e mais perigoso) em ambientes AWS reais é anexar a `AdministratorAccess` ou usar `"Resource": "*"` "só pra funcionar logo". O problema: se essa instância for comprometida (uma vulnerabilidade na aplicação, uma dependência maliciosa, uma chave vazada), o atacante herda exatamente as permissões da role. Least privilege limita o estrago possível ao mínimo necessário.

## O que este lab cria

1. **Um bucket S3** de exemplo (`aws_s3_bucket.app_bucket`)
2. **Uma trust policy**: define *quem* pode assumir a role — aqui, apenas o serviço EC2 (`ec2.amazonaws.com`), não qualquer usuário ou serviço
3. **Uma IAM Policy customizada**: permite exatamente `s3:ListBucket` no bucket, e `s3:GetObject`/`s3:PutObject` nos objetos dentro dele — nada de `s3:DeleteObject`, nada de acesso a outros buckets
4. **Uma IAM Role**: vincula a trust policy à policy de permissões
5. **Um Instance Profile**: é o que de fato se anexa a uma instância EC2 (roles não se anexam diretamente a instâncias, precisam do profile)

## Diferença de abordagem: least privilege vs "acesso total"

| Abordagem | Actions | Resources | Risco se comprometido |
|---|---|---|---|
| ❌ Comum (errado) | `s3:*` | `*` | Atacante lê/apaga/sobrescreve **qualquer bucket** da conta |
| ✅ Este lab | `s3:ListBucket`, `GetObject`, `PutObject` | Só o bucket específico | Atacante só acessa **um bucket**, e nem pode deletar objetos |

## Como rodar

```bash
terraform init
terraform plan
terraform apply
```

Para testar em LocalStack/ministack, adicione ao provider (mesmo esquema dos labs anteriores), cobrindo também os endpoints de `iam` e `s3`:

```hcl
provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
    iam = "http://localhost:4566"
    s3  = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}
```

## Como conectar este lab ao lab02 (próximo passo de evolução)

O `instance_profile_name` gerado aqui pode ser passado para o `aws_instance` do lab02 através do argumento `iam_instance_profile`. Isso é o próximo nível de maturidade: compor labs entre si em vez de mantê-los isolados — mostra entendimento de como infraestrutura real é organizada em módulos que se referenciam.

## Validação

```bash
aws --endpoint-url=http://localhost:4566 iam get-role --role-name aws-infra-labs-lab03-role
aws --endpoint-url=http://localhost:4566 iam list-attached-role-policies --role-name aws-infra-labs-lab03-role
```

## Limpeza

```bash
terraform destroy
```

## Próximos passos (lab04)

S3 bucket com política de bucket (bucket policy) e versionamento habilitado, para proteção contra sobrescrita/exclusão acidental de dados.
