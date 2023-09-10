import requests
import json
import traceback
import time
import datetime
import schedule
import pandas as pd

import postgreSQL_conn.postgreSQL_conn as ps
from log_register.log_register import log_register

def data_ingestion():
	url = f'https://www.tabnews.com.br/api/v1/contents'

	data_max = ps.get_max_data()

	data_finalizacao = datetime.datetime.now()

	params = {"page": 1, "per_page": 100, "strategy": "new"}

	df = pd.DataFrame(columns=["id", 'owner_id', "parent_id" ,"slug", "title", "status", "source_url", "created_at", "updated_at", 
	                           "published_at", "deleted_at", 'tabcoins', "owner_username", "children_deep_count"])
	df = df.astype(dtype = {'id': "str", 'owner_id': "str", "parent_id": "str", "slug": "str", "title": "str", 
	                        "status": "str", "source_url": "str", "created_at": "str", "updated_at": "str", 
	                        "published_at": "str", "deleted_at": "str", 'tabcoins': "int64", "owner_username": "str", 
	                        "children_deep_count": "int64"})

	log_register('Começa a fazer requisições a API')

	try:
		while data_max <= data_finalizacao:
		    log_register(f'Requisição na página {params["page"]}')
		    
		    url = "https://tabnews.com.br/api/v1/contents"
		    resp = requests.get(url, params=params)

		    dados = resp.json()
		    dados = [dados] if type(dados) == "<class 'dict'>" else dados
		    
		    if len(dados) > 0:
		        df_temp = pd.DataFrame(data = dados)
		        data_finalizacao = datetime.datetime.strptime(df_temp["created_at"].min(),"%Y-%m-%dT%H:%M:%S.%fZ")
		        data_finalizacao_str = data_finalizacao.strftime('%Y-%m-%d %H:%M:%S.%f')
		        log_register('Última data encontrada na página ' + data_finalizacao_str)
		      
		    if data_finalizacao < data_max_postgre:
		        data_max_str = data_max_postgre.strftime('%Y-%m-%d %H:%M:%S.%f')
		        df_temp = df_temp[df_temp.created_at > data_max_str]
		    
		    if len(dados) > 0:
		        df = pd.concat( [df,df_temp] )

		    params["page"] += 1
		    
		    
		    log_register("Aguarda 10 segundos para próxima requisição")
		    time.sleep(10)
	except:
		log_register("Erro em requisições a API")
		raise Exception(traceback.format_exc())

	try:
		log_register("Requisições finalizadas")
		log_register("Elimina duplicidades e lida com dados nulos")
		df = df.drop_duplicates(subset=['id'])
		df = df.replace({'None': None})

		log_register("Ingere dados na tabela do PostgreSQL")
		df.to_sql(name = 'tbtabnews', con= ps.conn_alch, if_exists='append', index=False, schema = 'scnews')

		ps.conn_alch.commit()

		log_register("Ingestão realizada")
	except:
		log_register("Erro ao tentar ingerir dados no PostgreSQL")
		raise Exception(traceback.format_exc())

def scheduleJob ():
	log_register("Aguarda inicio do job")
	schedule.every(1).minutes.do(data_ingestion)
	#schedule.every().day.at("19:00").do(data_ingestion)

	while True:
		schedule.run_pending()
		time.sleep(1)


if __name__ == "__main__":
	scheduleJob()