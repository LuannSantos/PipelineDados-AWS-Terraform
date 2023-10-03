
resource "aws_security_group" "access-rds-port" {
  name        = "${var.project_name}-security-group-access-rds"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    
    cidr_blocks = ["${chomp(var.my_ip)}/32", "${var.vpc_cidr_block}"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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
  identifier = "${var.project_name}-rds"
  
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

