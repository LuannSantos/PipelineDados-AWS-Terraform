output "lambda_arn" {
  value       = aws_lambda_function.lambda_start_replication.arn
  description = "ARN da função lambda"
}