output "private_sg_id" {
  value = aws_security_group.myce_sg_private.id
}

output "public_sg_id" {
  value = aws_security_group.myce_sg_public.id
}

output "internal_sg_id" {
  value = aws_security_group.myce_sg_internal.id
}

output "monitoring_sg_id" {
  value = aws_security_group.myce_sg_monitoring.id
}

output "db_sg_id" {
  value = aws_security_group.myce_sg_db.id
}