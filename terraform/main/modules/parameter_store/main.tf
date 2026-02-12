locals {
  parameter_name_prefix = "/myce/product"
}

resource "aws_ssm_parameter" "core_db_url" {
  name = "${local.parameter_name_prefix}/CORE_DB_URL"
  type = "SecureString"
  value = "jdbc:mysql://${var.db_host}:3306/myce_core"
  overwrite = true
}

resource "aws_ssm_parameter" "payment_db_url" {
  name = "${local.parameter_name_prefix}/PAYMENT_DB_URL"
  type = "SecureString"
  value = "jdbc:mysql://${var.db_host}:3306/myce_payment"
  overwrite = true
}

resource "aws_ssm_parameter" "notification_db_url" {
  name = "${local.parameter_name_prefix}/NOTIFICATION_DB_URL"
  type = "SecureString"
  value = "jdbc:mysql://${var.db_host}:3306/myce_notification"
  overwrite = true
}

resource "aws_ssm_parameter" "eureka_url" {
  name  = "${local.parameter_name_prefix}/EUREKA_URL"
  type  = "SecureString"
  value = "http://${var.monitoring_ip}:8084/eureka"
  overwrite = true
}

resource "aws_ssm_parameter" "core_api_url" {
  name  = "${local.parameter_name_prefix}/CORE_API_URL"
  type  = "SecureString"
  value = "${var.private_ip}"
  overwrite = true
}

resource "aws_ssm_parameter" "notification_api_url" {
  name  = "${local.parameter_name_prefix}/NOTIFICATION_API_URL"
  type  = "SecureString"
  value = "${var.private_ip}"
  overwrite = true
}

resource "aws_ssm_parameter" "chat_api_url" {
  name  = "${local.parameter_name_prefix}/CHAT_API_URL"
  type  = "SecureString"
  value = "${var.private_ip}"
  overwrite = true
}

resource "aws_ssm_parameter" "payment_internal_url" {
  name  = "${local.parameter_name_prefix}/PAYMENT_INTERNAL_URL"
  type  = "SecureString"
  value = "${var.internal_ip}"
  overwrite = true
}

resource "aws_ssm_parameter" "core_internal_url" {
  name  = "${local.parameter_name_prefix}/CORE_INTERNAL_URL"
  type  = "SecureString"
  value = "${var.internal_ip}"
  overwrite = true
}

resource "aws_ssm_parameter" "gateway_url" {
  name  = "${local.parameter_name_prefix}/GATEWAY_URL"
  type  = "SecureString"
  value = "${var.public_ip}"
  overwrite = true
}