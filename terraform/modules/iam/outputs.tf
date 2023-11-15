output "iam_s3_arn" {
  value       = aws_iam_role.iam_s3_access_role.arn
  description = "Arn da IAM Role criada para o endpoint S3 do DMS"
}

output "iam_dms_lambda_arn" {
  value       = aws_iam_role.iam_lambda_dms_access_role.arn
  description = "Arn da IAM Role criada para o lambda acessar o DMS"
}

output "iam_emr_arn" {
  value       = aws_iam_role.iam_emr_access_role.arn
  description = "Arn da IAM Role criada para o EMR"
}

output "iam_instance_profile_ec2" {
  value       = aws_iam_instance_profile.emr_profile.arn
  description = "Arn da IAM Instance profile para o EC2"
}