output "private_sg_id" {
  value = aws_security_group.myce_sg_private.id
}

output "public_sg_id" {
  value = aws_security_group.myce_sg_public.id
}

output "nat_sg_id" {
  value = aws_security_group.myce_sg_nat.id
}

output "bastion_sg_id" {
  value = aws_security_group.myce_sg_bastion.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}