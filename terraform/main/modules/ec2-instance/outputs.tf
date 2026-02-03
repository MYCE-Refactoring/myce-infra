output "public_ip" {
  value = aws_instance.public_instance.private_ip
}

output "internal_ip" {
  value = aws_instance.internal_instance.private_ip
}

output "private_ip" {
  value = aws_instance.private_instance.private_ip
}

output "monitoring_ip" {
  value = aws_instance.monitoring_instance.public_ip
}