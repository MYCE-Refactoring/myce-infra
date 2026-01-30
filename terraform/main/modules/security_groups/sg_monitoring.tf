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

resource "aws_security_group_rule" "myce_sg_monitoring_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.monitoring_id
}