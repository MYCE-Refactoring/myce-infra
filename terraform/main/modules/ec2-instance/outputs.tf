output "public_ip" {
  value = aws_instance.public_instance.public_ip
}

output "nat_ip" {
  value = aws_instance.nat_instance.public_ip
}

output "bastion_ip" {
  value = aws_instance.bastion_instance.public_ip
}

output "private_ip" {
  value = aws_instance.private_instance.private_ip
}