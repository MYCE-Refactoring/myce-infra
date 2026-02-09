resource "aws_iam_policy" "ssm_parameter_policy" {
  name        = "myce-ssm-parameter-policy"
  description = "Allow access to SSM Parameter Store"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid": "AllowReadMyceParameterStore",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:GetParametersByPath",
            ],
            "Resource": [
                "arn:aws:ssm:ap-northeast-2:*:parameter/myce/*",
                "arn:aws:ssm:ap-northeast-2:*:parameter/myce"
            ]
        Resource = "*"
      },
      {
            "Sid": "AllowDecryptForParameterStore",
            "Effect": "Allow",
            "Action": "kms:Decrypt",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "ssm.ap-northeast-2.amazonaws.com"
                }
            }
        }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "myce-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ssm_parameter_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "myce-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# EC2 생성
resource "aws_instance" "public_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_ids.public
  vpc_security_group_ids      = var.security_goups.public
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags                        = { Name = "${var.name_prefix}-public" }
}

resource "aws_instance" "private_instance" {
  ami                         = var.ami
  instance_type               = "t3.micro"
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_ids.private
  vpc_security_group_ids      = var.security_goups.private
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags                        = { Name = "${var.name_prefix}-private" }
}

resource "aws_instance" "internal_instance" {
  ami                         = var.ami
  instance_type               = "t3.micro"
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_ids.internal
  vpc_security_group_ids      = var.security_goups.internal
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
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
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags                        = { Name = "${var.name_prefix}-monitoring" }
}

# routing table설정
resource "aws_route" "private_route_to_nat" {
  route_table_id         = var.private_rt_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.monitoring_instance.primary_network_interface_id
}