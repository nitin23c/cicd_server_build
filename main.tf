# --- root/main.tf ---

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source           = "./network"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  max_subnets      = 20
  public_sn_count  = 2
  private_sn_count = 3
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}

module "ec2ecrrole" {
  source    = "./ec2ecrrole"
  role_name = "ec2ecrrole"
}

module "compute" {
  source             = "./compute"
  instance_count     = 1
  instance_type      = var.inst_type
  public_sg          = module.network.public_sg
  public_subnets     = module.network.public_subnets
  vol_size           = 10
  key_name           = "awsgeek0_pub_key"
  public_key_path    = var.key_path
  user_data_path     = file("userdata.sh")
  instance_role_name = module.ec2ecrrole.profile_name
  depends_on         = [module.ec2ecrrole]
}

