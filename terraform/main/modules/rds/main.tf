resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.subnets
}

resource "aws_db_instance" "mysql_db" {
  storage_type           = "standard"
  allocated_storage      = 20
  identifier             = "${var.name_prefix}-database"
  db_name                = var.db_info.db_name
  engine                 = "mysql"
  engine_version         = "8.0.43"
  instance_class         = "db.t3.micro"
  username               = var.db_info.db_username
  password               = var.db_info.db_password
  vpc_security_group_ids = var.security_groups
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  availability_zone      = var.availability_zone
  skip_final_snapshot    = true
}