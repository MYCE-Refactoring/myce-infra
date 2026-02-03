# 보안그룹 생성
resource "aws_security_group" "myce_sg_public" {
  name   = "${var.name_prefix}-sg-public"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "myce_sg_public_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.public_id
}

resource "aws_security_group_rule" "myce_sg_public_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id  = local.monitoring_id
  security_group_id = local.public_id
}

resource "aws_security_group_rule" "myce_sg_public_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id = local.monitoring_id
  security_group_id = local.private_id
}

resource "aws_security_group_rule" "myce_sg_public_egress_monitoring" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "icmp"
  source_security_group_id = local.monitoring_id
  security_group_id = local.private_id
}