

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../python/lambda_dms_start_task/lambda_replication_task_start.py"
  output_path = "lambda_function_payload.zip"
}


resource "aws_lambda_function" "lambda_start_replication" {
  filename      = "lambda_function_payload.zip"
  function_name = "${var.project_name}-lambda-dms"
  role          = var.iam_arn
  runtime       = "python3.9"
  handler       = "lambda_replication_task_start.lambda_handler"

  environment {
    variables = {
      replicationTaskArn = var.replication_task_arn
    }
  }

}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_start_replication.function_name
    principal = "events.amazonaws.com"
    source_arn = var.event_rule_arn
}