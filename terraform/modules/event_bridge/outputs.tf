output "event_rule_arn" {
  value       = aws_cloudwatch_event_rule.event-rule.arn
  description = "ARN do EventBridge"
}