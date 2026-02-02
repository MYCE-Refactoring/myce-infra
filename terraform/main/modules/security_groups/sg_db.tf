resource "aws_security_group" "myce_sg_db" {
  name   = "${var.name_prefix}-sg-db"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [
      aws_security_group.myce_sg_private.id,
      aws_security_group.myce_sg_internal.id,
      aws_security_group.myce_sg_monitoring.id
    ]
  }
}