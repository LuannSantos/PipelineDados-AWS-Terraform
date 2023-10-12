variable "project_name" {
  type        = string
  description = "Nome do Projeto"
}

variable "bucket_name" {
  type        = string
  description =  "Bucket a ser inserido na política IAM"
}


variable "replication_task_arn" {
  type        = string
  description = "ARN da replication task do DMS"
}



