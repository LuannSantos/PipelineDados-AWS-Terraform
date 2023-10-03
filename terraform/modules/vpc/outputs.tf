output "vpc_cidr_block" {
  value       = data.aws_vpc.default_vpc.cidr_block
  description = "Rede da VPC padrão que será usada no grupo de segurança da instância RDS"
}