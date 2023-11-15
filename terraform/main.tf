module "dms" {
	source = "./modules/dms"
	project_name = var.project_name
	db_username = var.db_username
  	db_password = var.db_password

  	security_group_id = module.rds.security_group_id
  	db_name = module.rds.db_name
  	db_address = module.rds.db_address
  	bucket_name = module.s3.bucket_raw
  	iam_arn = module.iam.iam_s3_arn
}

module "iam" {
	source = "./modules/iam"
	project_name = var.project_name

	bucket_raw = module.s3.bucket_raw
	bucket_processed = module.s3.bucket_processed
	bucket_curated = module.s3.bucket_curated
	bucket_emr = module.s3.bucket_emr
	replication_task_arn = module.dms.replication_task_arn
}

module "rds" {
	source = "./modules/rds"
	db_username = var.db_username
  	db_password = var.db_password
  	my_ip = data.http.myip.body
  	project_name = var.project_name

  	vpc_cidr_block = module.vpc.vpc_cidr_block
}

module "s3" {
	source = "./modules/s3"
	bucket_names = var.bucket_names
	project_name = var.project_name
}


module "vpc" {
	source = "./modules/vpc"
}

module "lambda" {
	source = "./modules/lambda"
	project_name = var.project_name

	iam_arn = module.iam.iam_dms_lambda_arn
	event_rule_arn = module.event-bridge.event_rule_arn
	replication_task_arn = module.dms.replication_task_arn

}

module "event-bridge" {
	source = "./modules/event_bridge"
	project_name = var.project_name
	schedule_time  = var.schedule_time

	lambda_arn = module.lambda.lambda_arn
}

module "emr" {
	source = "./modules/emr"
	project_name = var.project_name

	bucket_raw = module.s3.bucket_raw
	bucket_processed = module.s3.bucket_processed
	bucket_curated = module.s3.bucket_curated
	bucket_emr = module.s3.bucket_emr
	iam_emr_arn = module.iam.iam_emr_arn
	iam_instance_profile_ec2 = module.iam.iam_instance_profile_ec2

	bucket-emr-python-file = module.s3.bucket-emr-python-file
	bucket-emr-config-file-bucket-names = module.s3.bucket-emr-config-file-bucket-names
	bucket-emr-config-file = module.s3.bucket-emr-config-file
	bucket-emr-logs = module.s3.bucket-emr-logs

}