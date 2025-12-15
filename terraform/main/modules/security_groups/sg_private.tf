# 보안그룹 생성
resource "aws_security_group" "myce_sg_private" {
  name   = "${var.name_prefix}-sg-private"
  vpc_id = var.vpc_id
}

locals {
  default_private_sg_id = aws_security_group.myce_sg_private.id
  bastion_id            = aws_security_group.myce_sg_bastion.id
  public_id             = aws_security_group.myce_sg_public.id
}

resource "aws_security_group_rule" "myce_sg_private_ingress_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_id
  security_group_id        = local.default_private_sg_id
}

resource "aws_security_group_rule" "myce_sg_private_ingress_backend" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = local.public_id
  security_group_id        = local.default_private_sg_id
}

resource "aws_security_group_rule" "myce_sg_private_ingress_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = local.public_id
  security_group_id        = local.default_private_sg_id
}

resource "aws_security_group_rule" "myce_sg_private_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.default_private_sg_id
}