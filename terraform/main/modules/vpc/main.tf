resource "aws_vpc" "vpc" {                                   # 새로운 vpc를 만들겠다는 의미
  cidr_block           = var.vpc_cidr                        #IPv4 CIDR Block
  enable_dns_hostnames = true                                # DNS Hostname 사용 옵션, 기본은 false
  tags                 = { Name = "${var.name_prefix}_vpc" } #tag입력
}

locals {
  vpc_id = aws_vpc.vpc.id
}

# 서브넷 생성
# Public Subnet
resource "aws_subnet" "public-subnet" {
  for_each = var.public_subnets

  vpc_id                  = local.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.name_prefix}-${each.key}" }
}

# Private Subnet
resource "aws_subnet" "private-subnet" {
  for_each = var.private_subnets

  vpc_id                  = local.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.name_prefix}-${each.key}" }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "myce-igw" {
  vpc_id = local.vpc_id
  tags   = { Name = "${var.name_prefix}-igw" }
}


# 라우팅 테이블 생성
resource "aws_route_table" "public-rt" {
  vpc_id = local.vpc_id
  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.myce-igw.id
  }
  tags = { Name = "${var.name_prefix}-public-rt" }
}

resource "aws_route_table" "private-rt" {
  vpc_id = local.vpc_id
  tags   = { Name = "${var.name_prefix}-private-rt" }
}

resource "aws_route_table_association" "routing-public-ac" {
  for_each = aws_subnet.public-subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "routing-private-ac" {
  for_each = aws_subnet.private-subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private-rt.id
}
