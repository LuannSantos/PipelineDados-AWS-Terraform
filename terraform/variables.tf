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

variable "bucket_names" {
  type        = list(string)
  description = "Lista de buckets para as camadas de dados"
}

variable "schedule_time" {
  type        = string
  description = "Tempo do agendador do EventBridge"
}


data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}