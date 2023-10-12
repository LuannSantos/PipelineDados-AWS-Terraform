resource "aws_cloudwatch_event_rule" "event-rule" {
  name        = "${var.project_name}-eventrule"

  schedule_expression = "cron(0/${var.schedule_time} * * * ? *)"
}

resource "aws_cloudwatch_event_target" "event-rule-target" {
  rule      = aws_cloudwatch_event_rule.event-rule.name
  arn       = var.lambda_arn
}