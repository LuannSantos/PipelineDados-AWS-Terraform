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

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}