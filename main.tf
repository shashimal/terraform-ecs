terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "du-terraform-state-bucket"
    key    = "state/terraform_state.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = "us-east-1"
}

module "iam" {
  source   = "./modules/iam"
  app_name = var.app_name
}

module "vpc" {
  source             = "./modules/vpc"
  app_name           = var.app_name
  env                = var.env
  cidr               = var.cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
}

#module "internal-alb" {
#  source          = "./modules/alb"
#  app_name        = var.app_name
#  private_subnets = module.vpc.private-subnets
#  vpc_id          = module.vpc.vpc-id
#  target-groups   = var.target-groups
#}

module "ecr" {
  source                  = "./modules/ecr"
  app_name                = var.app_name
  ecr_repository_services = var.app_services
}

module "ecs" {
  source                      = "./modules/ecs"
  app_name                    = var.app_name
  app_services                = var.app_services
  account = var.account
  region = var.region
  ecs-task-execution-role-arn = module.iam.ecs-task-execution-role-arn
  task_definition_config = var.task_definition_config
}

