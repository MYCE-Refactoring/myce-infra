locals {
  export_ips = {
    PUBLIC_IP  = var.public_ip
    NAT_GW_IP     = var.nat_ip
    BASTION_IP = var.bastion_ip
    PRIVATE_IP = var.private_ip
  }
}

resource "local_file" "export_ips_yml" {
  content  = yamlencode(local.export_ips)
  filename = var.export_path
}