variable "project_name" {
  type        = string
  description = "Nome do Projeto"
}

variable "schedule_time" {
  type        = string
  description = "Tempo do agendador do EventBridge"
}


variable "lambda_arn" {
  type        = string
  description = "ARN da função lambda"
}