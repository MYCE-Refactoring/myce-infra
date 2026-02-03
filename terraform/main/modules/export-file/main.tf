locals {
  export_ips_yml = <<-EOT
INTERNAL_IP: "${var.internal_ip}"
MONITORING_IP: "${var.monitoring_ip}"
PRIVATE_IP: "${var.private_ip}"
PUBLIC_IP: "${var.public_ip}"
RDS_HOST: "${var.db_info.db_host}"
RDS_PASSWORD: "${var.db_info.db_password}"
RDS_USER: "${var.db_info.db_username}"
EOT
}

resource "local_file" "export_ips_yml" {
  content  = local.export_ips_yml
  filename = var.export_path
}

data "aws_s3_bucket" "artifact" {
  bucket = var.artifact_bucket
}

resource "aws_s3_object" "export_ips_yml_file" { ## 저장소를 local 경로가 아닌 s3 경로로 수정
  bucket = data.aws_s3_bucket.artifact.id
  key = var.artifact_export_path
  content = local.export_ips_yml
  content_type = "application/x-yaml"
}