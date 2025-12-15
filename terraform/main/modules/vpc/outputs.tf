output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = {
    for key, value in aws_subnet.public-subnet :
    key => value.id
  }
}

output "private_subnet_ids" {
  value = {
    for key, value in aws_subnet.private-subnet :
    key => value.id
  }
}

output "private_route_table_id" {
  value = aws_route_table.private-rt.id
}