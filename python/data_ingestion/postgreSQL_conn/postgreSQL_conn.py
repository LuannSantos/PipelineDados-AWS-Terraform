# Import
import psycopg
import traceback
import os
import datetime
from dotenv import load_dotenv, find_dotenv
from sqlalchemy import create_engine
from log_register.log_register import log_register

load_dotenv(find_dotenv())

DBNAME = os.environ.get("DBNAME")
DBPORT = os.environ.get("DBPORT")
DBUSER = os.environ.get("DBUSER")
DBPASSWORD = os.environ.get("DBPASSWORD")

log_register("Buscando url de conexão ao PostgresSQL")

try:
	with open('../../terraform/modules/rds/output/rds_address.txt') as f:
		lines = f.readlines()
	DBHOST = lines[0]
except:
	log_register("Erro ao buscar a url de conexão")
	raise Exception(traceback.format_exc())

try:
	log_register("Conectando ao SGBD Postgres com create_engine")

	conn_string = f'postgresql://{DBUSER}:{DBPASSWORD}@{DBHOST}/{DBNAME}'
	db_alch = create_engine(conn_string)
	conn_alch = db_alch.connect()

	log_register("Conexão feita com sucesso")
except:
	log_register("Erro ao tentar se conectar ao SGBD Postgres com create_engine")
	raise Exception(traceback.format_exc())


def get_max_data():
	# Cria conexão
	data_max_postgre = None
	log_register("Conectando ao SGBD Postgres...")
	try:
		conn = psycopg.connect(dbname = DBNAME, port = DBPORT, user = DBUSER, password = DBPASSWORD, host = DBHOST)
	except:
		log_register("Erro ao tentar se conectar ao banco de dados")
		raise Exception(traceback.format_exc())

	try:
		# Abre um cursor
		log_register("Conexão feita com sucesso...")
		cursor = conn.cursor()

		log_register("Cria schema e tabela que armazenarão os dados")

		cursor.execute("CREATE SCHEMA IF NOT EXISTS scnews")

		conn.commit()

		cursor.execute("""CREATE TABLE IF NOT EXISTS scnews.tbtabnews
		(id VARCHAR(36) PRIMARY KEY NOT NULL ,
		owner_id VARCHAR(36),
		parent_id  VARCHAR(36),
		slug VARCHAR(400),
		title VARCHAR(400),
		status VARCHAR(50),
		source_url VARCHAR(600),
		created_at TIMESTAMP,
		updated_at TIMESTAMP,
		published_at TIMESTAMP,
		deleted_at TIMESTAMP,
		tabcoins INT,
		owner_username VARCHAR(36),
		children_deep_count INT
		)
		""")

		conn.commit()

		log_register("Tabela criada com sucesso")
		log_register("Busca a data da última noticia salva")

		cursor.execute("SELECT MAX(created_at) FROM scnews.tbtabnews")
		data_max_postgre = cursor.fetchone()[0]

		if data_max_postgre == None:
		    data_max_postgre = datetime.datetime.strptime('2022-05-06 15:20:01.160000', '%Y-%m-%d %H:%M:%S.%f')
		    data_max_postgre_str = data_max_postgre.strftime('%Y-%m-%d %H:%M:%S.%f')
		else:
			data_max_postgre_str = data_max_postgre.strftime('%Y-%m-%d %H:%M:%S.%f')

		log_register("A data máxima encontrada foi " + data_max_postgre_str )

		conn.close()

	except:
		log_register("Erro ao tentar se conectar ao SGBD Postgres para obter a data máxima")
		raise Exception(traceback.format_exc())

	return data_max_postgre

