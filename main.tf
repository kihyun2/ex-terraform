terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}


module "vpc" {
  source = "./vpc"
}

module "security" {
  source = "./security"
  public_subnet_cidr = module.vpc.public_subnet_a_cidr
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source     = "./ec2"

  fe_sg_id   = module.security.fe_sg_id
  be_sg_id   = module.security.be_sg_id

  # FE 인스턴스는 public subnet에 위치
  fe_subnet_id = module.vpc.public_subnet_a_id
  # BE 인스턴스는 private subnet에 위치
  be_subnet_id = module.vpc.private_subnet_a_id

  key_name = var.key_name
}
