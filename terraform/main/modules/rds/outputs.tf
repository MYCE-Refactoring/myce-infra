output "rds_host" {
    value = aws_db_instance.mysql_db.address
}