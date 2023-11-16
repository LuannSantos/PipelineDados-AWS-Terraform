# Pipeline de dados usando API do tabnews com serviços da AWS e Terraform

## Introdução

Pipeline de dados usando API do tabnews com serviços da AWS e Terraform.

Os dados são armazenados no AWS RDS e AWS S3. No S3, os dados são divididos em 3 camadas: raw, processed e curated.

Em resumo, um código python extrai e salva os dados da API do tabnews no banco de dados PostgreSQL no AWS RDS. Após isso, o serviço AWS DMS pega os dados armazenados e os salva, em formato .csv, na camada raw do AWS S3. Depois, um código python presente em um cluster AWS EMR pega os dados da camada raw e os processa. Após uma limpeza de registros nulos e duplicidades, os dados são salvos em formato delta na camada processed do AWS S3. Então, esse mesmo código cria tabelas analiticas que serão armazenadas em formato delta na camada curated do AWS S3.

**Tecnologias Usadas**: Python, PySpark, Terraform, AWS S3, AWS RDS, AWS Lambda, AWS Event Bridge, AWS DMS, AWS EMR

## Preparação e Execução do Projeto

### Dados

Os dados vem da API do tabnews. A documentação pode ser conferida no seguinte link: https://www.tabnews.com.br/GabrielSozinho/documentacao-da-api-do-tabnews

### Arquitetura do Projeto

Toda a infraestrtutura fica na AWS e é criada no Terraform. O pipeline de dados funciona seguindo a arquitetura a seguir:

Na primeira parte, um programa python, que fica em uma máquina fora da AWS, realiza extrações de dados da API. O código extrai dados de cada página e a cada iteração, um conjunto de registros é salvo no banco de dados PostgreSQL no AWS RDS. Esse programa é executado de forma agendada usando a biblioteca schedule do Python.

Os registros armazenados no banco de dados relacional são transferidos para a camada raw do AWS S3 através do AWS DMS. Esse serviço foi configurado com dois endpoints: o AWS RDS como fonte e o AWS S3 como destino. Além das colunas existentes, o DMS acrescenta mais uma coluna que é o TIMESTAMP que está relacionado a data de transferência do registro do RDS para o S3.

Um cluster de máquinas EC2 criados pelo AWS EMR possui um script pyspark que irá extrair, processar e salvar os dados em formato delta.

Esse script, primeiramente, extrai os dados da camada raw do S3. Após isso, os dados passam por um processo de limpeza onde registros nulos são excluídos e duplicidades são limpadas. O conjunto de dados resultante é salvo na camada processed do AWS S3. Com os dados limpos, o código agrega os dados em tabelas analiticas que são salvas na camada curated do AWS S3. Assim como o outro programa python, as tarefas são executadas de forma agendada usando a biblioteca schedule.

### Execução do Projeto

Primeiramente, será criado a parte responsável por salvar o estado de toda infraestrutura e que também servirá para evitar que, em casos de mais de uma pessoa usando o mesmo projeto, que mais de uma atualização seja aplicada ao mesmo tempo. Para fazer isso execute:

<code>cd path/to/project/terraform_remotestate</code>

<code>terraform init</code>

<code>terraform apply -auto-approve</code>

Quando a primeira parte for executada com sucesso, vem a criação de toda infraestrutura AWS. Antes de executar os comandos para esse fim, entre na pasta do projeto:

<code>cd path/to/project/terraform</code>

Aqui, entre no arquivo terraform.tfvars e preencha as variáveis com os valores desejados. Lembrando que na variável bucket_names, é necessário passar uma lista com 4 nomes para os buckets da camada raw, processed, curated e o bucket responsável por armazenar o script python respectivamente.

Após fazer isso, execute os comandos abaixo:

<code>terraform init</code>

<code>terraform apply -auto-approve</code>

O último comando pedirá a senha que será usada pelo usuário root do banco de dados.

Após a execução completa desse passo, vem a última parte que é a execução do programa que irá a fazer a extração de dados da API e a ingestão no AWS RDS. Para isso, execute:

<code>cd path/to/project/python/data_ingestion</code>

<code>pip install -r requirements.txt</code>

<code>python main.py</code>

Se tudo funcionar, o projeto está pronto. Ou seja, foi criado um pipeline de dados capaz de extrair dados da API tabnews, processa-los e armazena-los naa camadas de dados dentro da AWS.
