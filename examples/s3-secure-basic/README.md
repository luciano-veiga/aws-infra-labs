# Exemplo: s3-secure-basic

Exemplo mínimo de uso do módulo [`s3-secure`](../../modules/s3-secure), pronto para ser testado localmente via `ministack`.

## Como testar

1. Confirme que o `ministack` está rodando:
   ```bash
   docker ps -a | grep ministack
   docker start ministack   # caso esteja parado
   ```

2. Abra `main.tf` e descomente o bloco de override do provider (endpoints apontando para `http://localhost:4566`).

3. Inicialize e aplique:
   ```bash
   terraform init
   terraform apply
   ```

4. Confirme a criação do bucket:
   ```bash
   aws --endpoint-url=http://localhost:4566 s3 ls
   ```

   > Nota: se o AWS CLI reclamar de checksum (`CRC64NVME`), use:
   > ```bash
   > export AWS_REQUEST_CHECKSUM_CALCULATION=when_required
   > ```

5. Ao terminar, destrua os recursos de teste:
   ```bash
   terraform destroy
   ```

## Evidências

Depois de rodar o teste, salve os prints em `docs/` dentro desta pasta (seguindo o mesmo padrão dos labs 02 a 05), por exemplo:
- `apply-complete.png`
- `bucket-listado.png`
