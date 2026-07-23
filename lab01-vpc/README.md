# Lab 01 — VPC com subnets pública e privada

## Objetivo

Provisionar uma VPC funcional com separação clara entre recursos que precisam de acesso direto à internet (subnet pública) e recursos que devem ficar isolados (subnet privada) — o desenho base de praticamente qualquer arquitetura AWS séria.

## Arquitetura

```
                         Internet
                            |
                     [Internet Gateway]
                            |
                    ┌───────┴────────┐
                    │      VPC       │
                    │  10.0.0.0/16   │
                    │                │
        ┌───────────┴──────┐   ┌─────┴─────────────┐
        │  Subnet Pública    │   │  Subnet Privada    │
        │  10.0.1.0/24       │   │  10.0.2.0/24       │
        │  (route → IGW)     │   │  (sem rota p/ IGW) │
        └────────────────────┘   └────────────────────┘
```

## Por que esse desenho

- **Subnet pública**: tem rota para o Internet Gateway na route table. É onde ficariam recursos que precisam ser alcançados de fora (ex: um load balancer, um bastion host).
- **Subnet privada**: não tem rota direta para a internet. É onde ficaria um banco de dados ou uma aplicação que só deve ser acessada de dentro da VPC — reduz superfície de ataque.
- **CIDR /16 na VPC e /24 nas subnets**: dá margem para criar mais subnets depois (multi-AZ, por exemplo) sem precisar redesenhar o range de IPs.

## Recursos criados

- 1 VPC
- 1 Internet Gateway
- 1 subnet pública + 1 subnet privada
- 1 route table pública associada à subnet pública
- Tags padronizadas em todos os recursos (facilita achar tudo no console e evita "recurso órfão" esquecido)

## Como rodar

```bash
terraform init
terraform plan
terraform apply
```

## Como validar

```bash
aws ec2 describe-vpcs --filters "Name=tag:Project,Values=aws-infra-labs"
aws ec2 describe-subnets --filters "Name=tag:Project,Values=aws-infra-labs"
```

## Limpeza

```bash
terraform destroy
```

## Próximos passos (lab02)

Subir uma instância EC2 dentro da subnet pública, com security group restringindo acesso SSH apenas ao meu IP.
