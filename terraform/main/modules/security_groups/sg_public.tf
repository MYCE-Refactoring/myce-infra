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

## api-gateway
resource "aws_security_group_rule" "myce_sg_public_ingress_gateway" {
  type              = "ingress"
  from_port         = 8083
  to_port           = 8083
  protocol          = "tcp"
  source_security_group_id  = local.monitoring_id
  security_group_id = local.public_id
}

resource "aws_security_group_rule" "myce_sg_public_ingress_node_exporter" {
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
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
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.monitoring_id
}