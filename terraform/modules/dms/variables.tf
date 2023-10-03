variable "project_name" {
  type        = string
  description = "Nome do Projeto"
}

variable "db_username" {
  type        = string
  description = "Nome de usuário RDS"
}

variable "db_password" {
  type        = string
  description = "Senha de usuário root RDS"
  sensitive   = true
}

variable "security_group_id" {
  type        = string
  description = "Id do grupo de segurança"
}

variable "db_name" {
  type        = string
  description = "Nome do database do RDS"
}

variable "db_address" {
  type        = string
  description = "Endereço do servidor RDS"
}

variable "bucket_name" {
  type        = string
  description = "Bucket a ser usado no DMS"
}

variable "iam_arn" {
  type        = string
  description = "Arn da IAM Role criada para o endpoint S3 do DMS"
}

locals {
  json_task_settings = file("${path.module}/task_settings/task_settings.json")
}




