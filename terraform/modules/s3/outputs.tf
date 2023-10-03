output "bucket_name" {
  value       = "${var.project_name}-s3-${var.bucket_names[0]}-data"
  description = "Bucket a ser inserido na política IAM e que será usado no DMS"
}