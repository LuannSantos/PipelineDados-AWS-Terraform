
resource "aws_dms_replication_instance" "dms-replication" {
	allocated_storage    = 10
	engine_version 		 = "3.5.1"
	multi_az             = false
	replication_instance_class   = "dms.t3.micro"
	replication_instance_id = "${var.project_name}-dms-replication-rds-s3"
	vpc_security_group_ids = [ "${var.security_group_id}" ]

}

resource "aws_dms_endpoint" "postgresql_endpoint" {
  endpoint_id                 = "${var.project_name}-endpoint-source-rds"
  endpoint_type               = "source"
  engine_name                 = "postgres"
  username                    = var.db_username
  password                    = var.db_password
  port                        = 5432
  database_name               = var.db_name
  server_name                 = var.db_address
  ssl_mode                    = "require"

  depends_on = [aws_dms_replication_instance.dms-replication]
}

resource "aws_dms_endpoint" "s3_endpoint" {
  endpoint_id                 = "${var.project_name}-endpoint-target-s3"
  endpoint_type               = "target"
  engine_name                 = "s3"
  ssl_mode                    = "none"
  extra_connection_attributes = "IncludeOpForFullLoad=True;TimestampColumnName=TIMESTAMP;AddColumnName=True"
  
  s3_settings {
    bucket_name             = var.bucket_name
    service_access_role_arn = var.iam_arn
    add_column_name = true
    cdc_path = "cdc"
    timestamp_column_name = "TIMESTAMP"
 }
  depends_on = [aws_dms_replication_instance.dms-replication]
}

resource "aws_dms_replication_task" "replication-task1" {
  migration_type            = "full-load"
  start_replication_task    = true
  replication_instance_arn  = aws_dms_replication_instance.dms-replication.replication_instance_arn
  replication_task_id       = "${var.project_name}-replication-task-rds-s3"
  source_endpoint_arn       = aws_dms_endpoint.postgresql_endpoint.endpoint_arn
  target_endpoint_arn       = aws_dms_endpoint.s3_endpoint.endpoint_arn
  table_mappings            = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"scnews\",\"table-name\":\"tbtabnews\"},\"rule-action\":\"include\"}]}"

  replication_task_settings = local.json_task_settings

}
