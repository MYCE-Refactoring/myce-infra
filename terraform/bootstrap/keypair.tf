# # RSA 개인 키 생성
# resource "tls_private_key" "make_key" {
#     algorithm = "RSA"
# }

# # EC2 인스턴스 구축 시 참조용
# resource "aws_key_pair" "myce_keypair" {
#     key_name = var.key_pair_name
#     public_key = tls_private_key.make_key.public_key_openssh
# }

# # 로컬 파일 다운로드
# resource "local_file" "cicd_downloads_key" {
#     filename = "${var.key_pair_name}.pem"
#     content = tls_private_key.make_key.private_key_pem
# }

# # EC2 인스턴스 키페어
# resource "aws_key_pair" "myce_keypair" {
#     key_name = var.key_pair_name
#     public_key = file("./${var.key_pair_name}.pub")
# }