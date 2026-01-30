# 보안그룹 생성
resource "aws_security_group" "myce_sg_internal" {
  name   = "${var.name_prefix}-sg-internal"
  vpc_id = var.vpc_id
}

## core-internal : private
resource "aws_security_group_rule" "myce_sg_internal_ingress_core_private" {
  type              = "ingress"
  from_port         = 8082
  to_port           = 8082
  protocol          = "tcp"
  source_security_group_id = local.private_id
  security_group_id = aws_security_group.myce_sg_internal.id
}

## core-internal : monitoring
resource "aws_security_group_rule" "myce_sg_internal_ingress_core_monitoring" {
  type              = "ingress"
  from_port         = 8082
  to_port           = 8082
  protocol          = "tcp"
  source_security_group_id = local.monitoring_id
  security_group_id = aws_security_group.myce_sg_internal.id
}

## payment-internal : private
resource "aws_security_group_rule" "myce_sg_internal_ingress_payment_private" {
  type              = "ingress"
  from_port         = 8023
  to_port           = 8023
  protocol          = "tcp"
  source_security_group_id = local.private_id
  security_group_id = aws_security_group.myce_sg_internal.id
}

## payment-internal : monitoring
resource "aws_security_group_rule" "myce_sg_internal_ingress_payment_monitoring" {
  type              = "ingress"
  from_port         = 8023
  to_port           = 8023
  protocol          = "tcp"
  source_security_group_id = local.monitoring_id
  security_group_id = aws_security_group.myce_sg_internal.id
}

resource "aws_security_group_rule" "myce_sg_internal_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id  = local.monitoring_id
  security_group_id = aws_security_group.myce_sg_internal.id
}


resource "aws_security_group_rule" "myce_sg_internal_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  source_security_group_id = local.monitoring_id
  security_group_id = aws_security_group.myce_sg_internal.id
}

resource "aws_security_group_rule" "myce_sg_internal_egress_db" {
  type              = "egress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = local.db_id
  security_group_id = aws_security_group.myce_sg_internal.id
}