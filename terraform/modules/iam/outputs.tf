output "iam_arn" {
  value       = aws_iam_role.iam_s3_access_role.arn
  description = "Arn da IAM Role criada para o endpoint S3 do DMS"
}