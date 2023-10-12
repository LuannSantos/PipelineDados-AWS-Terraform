import boto3
import os

def lambda_handler(event, context):
    # Nome da tarefa de migração DMS
    replicationTaskArn = os.environ['replicationTaskArn']
    
    # Crie um cliente DMS
    dms_client = boto3.client('dms')

    try:
        # Inicie a tarefa de migração
        response = dms_client.start_replication_task(
            ReplicationTaskArn=replicationTaskArn,
            StartReplicationTaskType='reload-target'
        )
        
        # Verifique o status da tarefa
        if response['ReplicationTask']['Status'] == 'starting':
            return "Tarefa de migração iniciada com sucesso."
        else:
            raise Exception("Falha ao iniciar a tarefa de migração.")

    except Exception as e:
        raise Exception("Erro ao iniciar a tarefa de migração: {}".format(str(e)))