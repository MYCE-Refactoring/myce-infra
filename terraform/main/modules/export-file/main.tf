locals {
  export_ips = {
    PUBLIC_IP = var.public_ip
    MONITORING_IP = var.monitoring_ip
    INTERNAL_IP = var.internal_ip
    PRIVATE_IP = var.private_ip
  }

  export_ips_yml = yamlencode(local.export_ips)
}

# resource "local_file" "export_ips_yml" {
#   content  = yamlencode(local.export_ips)
#   filename = var.export_path
# }

data "aws_s3_bucket" "artifact" {
  bucket = var.artifact_bucket
}

resource "aws_s3_object" "export_ips_yml_file" { ## 저장소를 local 경로가 아닌 s3 경로로 수정
  bucket = data.aws_s3_bucket.artifact.id
  key = var.artifact_export_path
  content = local.export_ips_yml
  content_type = "application/x-yaml"
}