terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name    = var.project_name
  environment     = var.environment
  cluster_name    = var.cluster_name
  vpc_cidr        = var.vpc.cidr
  azs             = var.vpc.azs
  public_subnets  = var.vpc.public_subnets
  private_subnets = var.vpc.private_subnets
  tags            = var.common_tags
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  tags         = var.common_tags
}

module "eks" {
  source = "../../modules/eks"

  project_name               = var.project_name
  environment                = var.environment
  cluster_name               = var.cluster_name
  kubernetes_version         = var.eks.version
  subnet_ids                 = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  private_subnet_ids         = module.vpc.private_subnet_ids
  cluster_security_group_ids = [module.security.cluster_security_group_id]
  node_groups = [{
    name            = "general"
    instance_types  = var.eks.instance_types
    min_size        = var.eks.min_size
    desired_size    = var.eks.desired_size
    max_size        = var.eks.max_size
    disk_size       = var.eks.disk_size
    max_unavailable = 1
  }]
  tags = var.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  repositories = [
    "frontend",
    "api-gateway",
    "auth-service",
    "team-service",
    "match-service",
    "scoring-service"
  ]
  tags = var.common_tags
}

module "ebs_csi" {
  source = "../../modules/ebs-csi"

  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_provider_url  = module.eks.oidc_provider_url
  storage_class_name = "aws-ebs"
  tags               = var.common_tags
}

module "alb_controller" {
  source = "../../modules/alb-controller"

  region            = var.region
  cluster_name      = module.eks.cluster_name
  vpc_id            = module.vpc.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  tags              = var.common_tags
}
