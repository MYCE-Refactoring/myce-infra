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

resource "aws_instance" "nat_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_ids.nat
  vpc_security_group_ids      = var.security_goups.nat
  associate_public_ip_address = true
  source_dest_check           = false
  tags                        = { Name = "${var.name_prefix}-nat" }
}

# nat routing table설정
resource "aws_route" "private_route_to_nat" {
  route_table_id         = var.private_rt_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_instance.primary_network_interface_id
}

resource "aws_instance" "bastion_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_ids.bastion
  vpc_security_group_ids      = var.security_goups.bastion
  associate_public_ip_address = true
  tags                        = { Name = "${var.name_prefix}-bastion" }
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