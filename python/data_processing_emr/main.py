import os
import json
import sys
import schedule
import traceback
import time
import logging
import pyspark
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql import types
from delta import *


def create_spark_session():
    my_packages = ["io.delta:delta-spark_2.12:2.0.0"]

    builder = pyspark.sql.SparkSession.builder.appName("MyApp") \
    .config("spark.jars.packages", "io.delta:delta-core_2.12:2.0.0") \
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")

    spark = configure_spark_with_delta_pip(builder, extra_packages=my_packages ).getOrCreate()

    spark.sparkContext.setLogLevel("ERROR")
    return spark

def read_bucket_names(path):
    logging.info('Lendo Nome dos Buckets')
    bucket_names_dict = {}
    bucket_key_list = ["bucket-raw", "bucket-processed", "bucket-curated", "bucket-emr"]
    i = 0
    with open(path, "r") as open_file:
        for item in open_file:
            bucket_names_dict[bucket_key_list[i]] = item.strip()
            i += 1
        open_file.close()
    return bucket_names_dict

def import_schema( path):
    logging.info('Importando Schema')
    with open(path, "r") as open_file:
        schema = json.load(open_file)
        open_file.close()
    return types.StructType.fromJson(schema)

def read_csv( spark, path, customSchema):
    logging.info("Realiza leitura dos dados csv da raw")
    df = spark.read.format("csv")\
        .option("header", "True")\
        .schema(customSchema)\
        .csv(path)

    logging.info("Leitura Realizada")
    return df

def clean_processing_data( df):
    logging.info("Realiza limpeza nos dados")
    df = df.dropDuplicates()
    df = df.filter(col("id").isNotNull())

    df_columns = df.columns
    df_columns.remove("TIMESTAMP")

    logging.info(df_columns)
    df = df.select(df_columns)

    logging.info("Limpeza Realizada")

    return df

def create_data_queries( df):
    logging.info("Cria tabelas analiticas")
    logging.info("Número de publicações por usuário")
    df_query1 = df.where(col("status") == "published") \
                .groupBy("owner_username") \
                .agg(count("owner_username").alias("publication_count")) \
                .sort(desc("publication_count"))
                
    logging.info("TabCoins por usuário")
    df_query2 = df.where(col("status") == "published") \
                .groupBy("owner_username") \
                .agg(sum("tabcoins").alias("tabcoins_sum")) \
                .sort(desc("tabcoins_sum"))

    logging.info("Número de publicações por hora")
    df_query3 = df.where(col("status") == "published") \
                .groupby(hour("created_at").alias("hour")) \
                .agg(count(hour("created_at")).alias("publication_count")) \
                .sort(asc("hour"))

    logging.info("Número de publicações por data")
    df_query4 = df.where(col("status") == "published") \
                .groupby(year("created_at").alias("year"), month("created_at").alias("month"), dayofweek("created_at").alias("day")) \
                .agg(count('*').alias("publication_count")) \
                .sort(asc("year"), asc("month"), asc("day"))

    logging.info("Tabelas criadas")
    return df_query1, df_query2, df_query3, df_query4
                

def main():  
    try:
        spark = create_spark_session()
        logging.info("Inicio do job")
        bucket_names = read_bucket_names('/home/hadoop/python/config/bucket_names.txt')

        schema = import_schema( '/home/hadoop/python/config/data_schema.json')
        path = f"{bucket_names['bucket-raw']}/scnews/tbtabnews/LOAD00000001.csv"
        df = read_csv( spark, path, schema)
        df = clean_processing_data( df)
        [df_query1, df_query2, df_query3, df_query4] = create_data_queries( df)

        logging.info("Salva dados em tabela delta")

        logging.info("Salva dados na processed")
        df.write.format("delta").mode("overwrite").save(f"{bucket_names['bucket-processed']}/df")

        logging.info("Salva dados na curated")
        df_query1.write.format("delta").mode("overwrite").save(f"{bucket_names['bucket-curated']}/df_query1")
        df_query2.write.format("delta").mode("overwrite").save(f"{bucket_names['bucket-curated']}/df_query2")
        df_query3.write.format("delta").mode("overwrite").save(f"{bucket_names['bucket-curated']}/df_query3")
        df_query4.write.format("delta").mode("overwrite").save(f"{bucket_names['bucket-curated']}/df_query4")

        logging.info("Finalização do Job")
        spark.stop()
    except:
        logging.info("Erro no processamento de dados")
        logging.info(traceback.format_exc())


def scheduleJob ():
    logging.info("Aguarda inicio do job")
    schedule.every(2).minutes.do(main)
    #schedule.every().day.at("19:00").do(data_ingestion)

    while True:
        schedule.run_pending()
        time.sleep(2)

if __name__ == "__main__":
    logging.basicConfig(
    format="""%(asctime)s,%(msecs)d %(levelname)-8s[%(filename)s:%(funcName)s:%(lineno)d] %(message)s""",
    datefmt="%Y-%m-%d %H:%M:%S",
    level=logging.INFO
    )
    scheduleJob()
