locals {
  project_name = "myce-terra"
  azs          = ["ap-northeast-2a", "ap-northeast-2c"]
}

# vpc & subnet 생성
module "myce_vpc" {
  source      = "./modules/vpc"
  name_prefix = local.project_name
  vpc_cidr    = "10.0.0.0/16"
  public_subnets = {
    public-1 : {
      cidr              = "10.0.10.0/24",
      availability_zone = local.azs[0]
    },
    public-2 : {
      cidr              = "10.0.20.0/24"
      availability_zone = local.azs[1]
    }
  }
  private_subnets = {
    private-1 : {
      cidr              = "10.0.11.0/24",
      availability_zone = local.azs[0]
    },
    private-2 : {
      cidr              = "10.0.22.0/24"
      availability_zone = local.azs[1]
    }
  }
  route_cidr = "0.0.0.0/0"
}

# security group 생성
module "sg_groups" {
  source      = "./modules/security_groups"
  vpc_id      = module.myce_vpc.vpc_id
  name_prefix = local.project_name
}

# EC2 생성
module "myce_ec2" {
  source        = "./modules/ec2-instance"
  key_pair_name = var.private_key_name
  subnet_ids = {
    public : module.myce_vpc.public_subnet_ids["public-1"],
    private : module.myce_vpc.private_subnet_ids["private-1"],
    nat : module.myce_vpc.public_subnet_ids["public-1"],
    bastion : module.myce_vpc.public_subnet_ids["public-2"]
  }
  security_goups = {
    public : [module.sg_groups.public_sg_id],
    private : [module.sg_groups.private_sg_id],
    nat : [module.sg_groups.nat_sg_id],
    bastion : [module.sg_groups.bastion_sg_id]
  }
  private_rt_id = module.myce_vpc.private_route_table_id
  name_prefix   = local.project_name
}

# RDS 생성
module "myce_rds" {
  source      = "./modules/rds"
  name_prefix = local.project_name
  db_info = {
    db_name : var.db_name
    db_username : var.db_username
    db_password : var.db_password
  }
  subnets = [
    for key, value in module.myce_vpc.private_subnet_ids :
    value
  ]
  security_groups   = [module.sg_groups.db_sg_id]
  availability_zone = local.azs[0]
}

module "export_ips_yml" {
  source      = "./modules/export-file"
  public_ip   = module.myce_ec2.public_ip
  nat_ip      = module.myce_ec2.nat_ip
  bastion_ip  = module.myce_ec2.bastion_ip
  private_ip  = module.myce_ec2.private_ip
  export_path = var.env_export_path
}