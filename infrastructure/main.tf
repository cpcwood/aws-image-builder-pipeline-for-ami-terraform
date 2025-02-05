# ==============================================
# Project setup

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.85"
    }
  }
  required_version = ">= 1.10.5"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  default_tags {
    tags = {
      project     = var.project_name
      environment = var.environment
    }
  }
}

# ==============================================
# VPC

module "image_builder_vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
}

# ==============================================
# Image Builder Pipeline

module "image_builder_pipeline" {
  source = "./modules/image_builder_pipeline"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.image_builder_vpc.vpc_id
  build_subnet_id = module.image_builder_vpc.build_subnet_id
  base_image      = var.base_image
}
