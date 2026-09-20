variable "region" {
  description = "AWS region for the environment."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Short project name used in resource names."
  type        = string
  default     = "crickethub"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "crickethub-dev"
}

variable "vpc" {
  description = "VPC configuration."
  type = object({
    cidr            = string
    azs             = list(string)
    public_subnets  = list(string)
    private_subnets = list(string)
  })
}

variable "eks" {
  description = "EKS configuration."
  type = object({
    version        = string
    instance_types = list(string)
    min_size       = number
    desired_size   = number
    max_size       = number
    disk_size      = number
  })
}

variable "alb_controller" {
  description = "ALB controller configuration."
  type = object({
    enabled = bool
  })
}

variable "ebs_csi" {
  description = "EBS CSI configuration."
  type = object({
    enabled = bool
  })
}

variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}
