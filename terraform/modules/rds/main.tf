#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources
resource "aws_security_group" "access-rds-port" {
  name        = "access_rds"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${chomp(var.my_ip)}/32"]

  }

}

resource "aws_db_instance" "PostgrelSQL-01" {
  db_name              = "dbnews"
  engine               = "postgres"
  engine_version       = "15.3"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  port                 = 5432 

  skip_final_snapshot  = true
  
  # resource identifier
  identifier = "terraform-project-rds"
  
  # Storage options
  allocated_storage    = 20
  max_allocated_storage = 20
  
  # allow remotly access
  vpc_security_group_ids = [aws_security_group.access-rds-port.id]
  publicly_accessible = "true"

  depends_on = [aws_security_group.access-rds-port]
}

resource "local_file" "rds_host" {
    content  = aws_db_instance.PostgrelSQL-01.address
    filename = "./modules/rds/output/rds_address.txt"

    depends_on = [aws_security_group.access-rds-port, aws_db_instance.PostgrelSQL-01]
}

