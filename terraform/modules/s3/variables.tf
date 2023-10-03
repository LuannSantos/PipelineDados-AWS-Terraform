
variable "project_name" {
  type        = string
  description = "Nome do Projeto"
}

variable "bucket_names" {
  type        = list(string)
  description = "Lista de buckets para as camadas de dados"
}