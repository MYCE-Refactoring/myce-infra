resource "aws_security_group" "db_sg" {
  name   = "${var.name_prefix}-sg-db"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.myce_sg_private.id]
  }
}