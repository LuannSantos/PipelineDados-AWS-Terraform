output "bucket_raw" {
  value       = "${var.project_name}-s3-${var.bucket_names[0]}-data"
  description = "Bucket da camada raw a ser inserido na política IAM, que será usado no DMS e no job do AWS Glue"
}

output "bucket_processed" {
  value       = "${var.project_name}-s3-${var.bucket_names[1]}-data"
  description = "Bucket da camada processed a ser usado no job Glue"
}

output "bucket_curated" {
  value       = "${var.project_name}-s3-${var.bucket_names[2]}-data"
  description = "Bucket da camada curated a ser usado no job Glue"
}

output "bucket_emr" {
  value       = "${var.project_name}-s3-${var.bucket_names[3]}-data"
  description = "Bucket a ser usado no job Glue"
}

output "bucket-emr-python-file" {
  value       = aws_s3_object.bucket-emr-python-file
  description = "Recurso para ser usado no modulo EMR"
}

output "bucket-emr-config-file-bucket-names" {
  value       = aws_s3_object.bucket-emr-config-file-bucket-names
  description = "Recurso para ser usado no modulo EMR"
}

output "bucket-emr-config-file" {
  value       = aws_s3_object.bucket-emr-config-file
  description = "Recurso para ser usado no modulo EMR"
}

output "bucket-emr-logs" {
  value       = aws_s3_object.bucket-emr-logs
  description = "Recurso para ser usado no modulo EMR"
}

