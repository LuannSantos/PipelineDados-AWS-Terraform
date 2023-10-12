output "iam_s3_arn" {
  value       = aws_iam_role.iam_s3_access_role.arn
  description = "Arn da IAM Role criada para o endpoint S3 do DMS"
}

output "iam_dms_lambda_arn" {
  value       = aws_iam_role.iam_lambda_dms_access_role.arn
  description = "Arn da IAM Role criada para o lambda acessar o DMS"
}