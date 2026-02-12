# 보안그룹 생성
resource "aws_security_group" "myce_sg_monitoring" {
  name   = "${var.name_prefix}-sg-monitoring"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "myce_sg_monitoring_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.monitoring_id
}

resource "aws_security_group_rule" "myce_sg_monitoring_ingress_grafana" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.monitoring_id
}

## eureka
resource "aws_security_group_rule" "myce_sg_monitoring_ingress_eureka" {
  type              = "ingress"
  from_port         = 8084
  to_port           = 8084
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.monitoring_id
}

## prometheus
resource "aws_security_group_rule" "myce_sg_monitoring_ingress_prometheus" {
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.monitoring_id
}

resource "aws_security_group_rule" "myce_sg_monitoring_ingress_internal" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id = local.internal_id
  security_group_id = local.monitoring_id
}

resource "aws_security_group_rule" "myce_sg_monitoring_ingress_private" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id = local.private_id
  security_group_id = local.monitoring_id
}

resource "aws_security_group_rule" "myce_sg_monitoring_ingress_public" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id = local.public_id
  security_group_id = local.monitoring_id
}

resource "aws_security_group_rule" "myce_sg_monitoring_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.monitoring_id
}