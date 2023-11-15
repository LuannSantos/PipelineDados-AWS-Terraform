variable "project_name" {
  type        = string
  description = "Nome do Projeto"
}

variable "bucket_raw" {
  type        = string
  description =  "Bucket da camada raw a ser inserido na política IAM"
}

variable "bucket_processed" {
  type        = string
  description =  "Bucket da camada processed a ser inserido na política IAM"
}

variable "bucket_curated" {
  type        = string
  description =  "Bucket da camada curated a ser inserido na política IAM"
}

variable "bucket_emr" {
  type        = string
  description =  "Bucket com arquivos do job EMR a ser inserido na política IAM"
}


variable "replication_task_arn" {
  type        = string
  description = "ARN da replication task do DMS"
}



