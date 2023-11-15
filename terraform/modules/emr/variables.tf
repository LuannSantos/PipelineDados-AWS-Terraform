variable "project_name" {
  type        = string
  description = "Nome do Projeto"
}

variable "bucket_raw" {
  type        = string
  description =  "Bucket da camada raw a ser usado no job EMR"
}

variable "bucket_processed" {
  type        = string
  description =  "Bucket da camada processed a ser usado no job EMR"
}

variable "bucket_curated" {
  type        = string
  description =  "Bucket da camada curated a ser usado no job EMR"
}

variable "bucket_emr" {
  type        = string
  description =  "Bucket com arquivos importantes a serem usado no job EMR"
}

variable "iam_emr_arn" {
  type        = string
  description =  "Arn da IAM Role criada para o EMR acessar o S3"
}

variable "iam_instance_profile_ec2" {
  type        = string
  description =  "Arn da IAM Instance profile para o EC2"
}

variable "bucket-emr-python-file" {
  description = "Recurso a ser usado no depends_on do EMR"
}

variable "bucket-emr-config-file-bucket-names" {
  description = "Recurso a ser usado no depends_on do EMR"
}

variable "bucket-emr-config-file" {
  description = "Recurso a ser usado no depends_on do EMR"
}

variable "bucket-emr-logs" {
  description = "Recurso a ser usado no depends_on do EMR"
}