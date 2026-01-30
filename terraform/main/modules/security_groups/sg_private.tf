# 보안그룹 생성
## 같은 폴더는 같은 모듈이라서 파일이 달라도 자유롭게 참주 가능
locals { ## 참조는 의존성을 만들어서 얘네를 먼저 만들고 이 파일이 실행됨
  private_id            = aws_security_group.myce_sg_private.id
  monitoring_id         = aws_security_group.myce_sg_monitoring.id
  public_id             = aws_security_group.myce_sg_public.id
  db_id                 = aws_security_group.myce_sg_db.id
  monitoring_private_ingress = {
    monitoring: local.monitoring_id,
    private: local.private_id
  }
}

resource "aws_security_group" "myce_sg_private" {
  name   = "${var.name_prefix}-sg-private"
  vpc_id = var.vpc_id

}

## core-api
resource "aws_security_group_rule" "myce_sg_private_ingress_core" {
  for_each = local.monitoring_private_ingress

  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  source_security_group_id = each.value
  security_group_id = local.private_id
}

## notification
resource "aws_security_group_rule" "myce_sg_private_ingress_notification" {
  for_each = local.monitoring_private_ingress

  type              = "ingress"
  from_port         = 8023
  to_port           = 8023
  protocol          = "tcp"
  source_security_group_id = each.value
  security_group_id = local.private_id
}

## chat
resource "aws_security_group_rule" "myce_sg_private_ingress_chat" {
  for_each = local.monitoring_private_ingress

  type              = "ingress"
  from_port         = 8031
  to_port           = 8031
  protocol          = "tcp"
  source_security_group_id = each.value
  security_group_id = local.private_id
}

resource "aws_security_group_rule" "myce_sg_private_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id  = local.monitoring_id
  security_group_id = local.private_id
}

resource "aws_security_group_rule" "myce_sg_private_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.private_id
}