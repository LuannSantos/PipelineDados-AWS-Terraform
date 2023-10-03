output "security_group_id" {
  value       = aws_security_group.access-rds-port.id
  description = "Id do grupo de segurança"
}

output "db_name" {
  value       = aws_db_instance.PostgrelSQL-01.db_name
  description = "Nome do database do RDS"
}

output "db_address" {
  value       = aws_db_instance.PostgrelSQL-01.address
  description = "Endereço do servidor RDS"
}