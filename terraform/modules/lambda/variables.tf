variable "project_name" {
  type        = string
  description = "Nome do Projeto"
}


variable "iam_arn" {
  type        = string
  description = "Arn da IAM Role criada para o lambda acessar o DMS"
}

variable "event_rule_arn" {
  type        = string
  description = "ARN do EventBridge"
}

variable "replication_task_arn" {
  type        = string
  description = "ARN da replication task do DMS"
}