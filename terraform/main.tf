

module "rds" {
	source = "./modules/rds"
	db_username = var.db_username
  	db_password = var.db_password
  	my_ip = data.http.myip.body
}

module "s3" {
	source = "./modules/s3"
	bucket_names = var.bucket_names
}