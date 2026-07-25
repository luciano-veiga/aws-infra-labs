import json


def handler(event, context):
    """
    Funcao disparada automaticamente sempre que um objeto e criado
    no bucket S3 monitorado. Aqui apenas registra os detalhes do evento
    nos logs (CloudWatch Logs), mas serve de base para qualquer
    processamento real: gerar thumbnail, validar arquivo, notificar
    outro sistema, etc.
    """
    print(f"DEBUG - evento bruto recebido: {json.dumps(event)}")

    for record in event.get("Records", []):
        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]
        size = record["s3"]["object"].get("size", "desconhecido")

        print(f"Novo objeto detectado: bucket={bucket} key={key} size={size} bytes")

    return {
        "statusCode": 200,
        "body": json.dumps({"message": "Evento processado com sucesso"}),
    }
