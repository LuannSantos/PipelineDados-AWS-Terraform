module "dms" {
	source = "./modules/dms"
	project_name = var.project_name
	db_username = var.db_username
  	db_password = var.db_password

  	security_group_id = module.rds.security_group_id
  	db_name = module.rds.db_name
  	db_address = module.rds.db_address
  	bucket_name = module.s3.bucket_name
  	iam_arn = module.iam.iam_arn
}

module "iam" {
	source = "./modules/iam"
	project_name = var.project_name

	bucket_name = module.s3.bucket_name
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