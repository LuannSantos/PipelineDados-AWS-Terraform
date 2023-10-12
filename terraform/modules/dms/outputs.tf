output "replication_task_arn" {
  value       = aws_dms_replication_task.replication-task1.replication_task_arn
  description = "ARN da replication task do DMS"
}