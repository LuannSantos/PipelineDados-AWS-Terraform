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

variable "my_ip" {
  type        = string
  description = "IP público do usuário"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Rede da VPC padrão que será usada no grupo de segurança da instância RDS"
}

