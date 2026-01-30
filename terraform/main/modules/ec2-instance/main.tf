# EC2 생성
resource "aws_instance" "public_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_ids.public
  vpc_security_group_ids      = var.security_goups.public
  associate_public_ip_address = true
  tags                        = { Name = "${var.name_prefix}-public" }
}

resource "aws_instance" "private_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_ids.private
  vpc_security_group_ids      = var.security_goups.private
  associate_public_ip_address = false
  tags                        = { Name = "${var.name_prefix}-private" }
}

resource "aws_instance" "internal_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_ids.internal
  vpc_security_group_ids      = var.security_goups.internal
  associate_public_ip_address = false
  tags                        = { Name = "${var.name_prefix}-internal" }
}

resource "aws_instance" "monitoring_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_ids.monitoring
  vpc_security_group_ids      = var.security_goups.monitoring
  associate_public_ip_address = true
  source_dest_check           = false
  tags                        = { Name = "${var.name_prefix}-monitoring" }
}

# routing table설정
resource "aws_route" "private_route_to_nat" {
  route_table_id         = var.private_rt_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.monitoring_instance.primary_network_interface_id
}