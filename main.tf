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
  region = "us-east-1"
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

module "internal-alb-security-group" {
  source        = "./modules/security-group"
  name          = "internal-alb-security-group"
  description   = "internal-alb-security-group"
  vpc_id        = module.vpc.vpc-id
  ingress_rules = var.internal_alb_ingress_rules
  egress_rules  = var.internal_alb_egress_rules
}

module "public-alb-security-group" {
  source        = "./modules/security-group"
  name          = "public-alb-security-group"
  description   = "public-alb-security-group"
  vpc_id        = module.vpc.vpc-id
  ingress_rules = var.public_alb_ingress_rules
  egress_rules  = var.public_alb_egress_rules
}

module "internal-alb" {
  source             = "./modules/alb"
  name               = "${lower(var.app_name)}-internal-alb"
  subnets            = module.vpc.private-subnets
  vpc_id             = module.vpc.vpc-id
  target_groups      = var.internal_alb_target_groups
  internal = true
  listener_port = 80
  listener_protocol = "HTTP"
  security_groups    = [module.internal-alb-security-group.security-group-id]
}

module "public-alb" {
  source             = "./modules/alb"
  name               = "${lower(var.app_name)}-public-alb"
  subnets            = module.vpc.public-subnets
  vpc_id             = module.vpc.vpc-id
  target_groups      = var.public_alb_target_groups
  internal = false
  listener_port = 80
  listener_protocol = "HTTP"
  security_groups    = [module.public-alb-security-group.security-group-id]
}

module "ecr" {
  source                  = "./modules/ecr"
  app_name                = var.app_name
  ecr_repository_services = var.app_services
}

module "ecs" {
  source                      = "./modules/ecs"
  app_name                    = var.app_name
  app_services                = var.app_services
  account                     = var.account
  region                      = var.region
  ecs-task-execution-role-arn = module.iam.ecs-task-execution-role-arn
  task_definition_config      = var.task_definition_config
}

