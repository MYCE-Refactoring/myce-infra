locals {
  export_ips = {
    PUBLIC_IP  = var.public_ip
    MONITORING_IP  = var.monitoring_ip
    INTERNAL_IP = var.internal_ip
    PRIVATE_IP = var.private_ip
  }
}

resource "local_file" "export_ips_yml" {
  content  = yamlencode(local.export_ips)
  filename = var.export_path
}