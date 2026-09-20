variable "region" {
  description = "AWS region where the cluster is deployed."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC hosting the cluster."
  type        = string
}

variable "namespace" {
  description = "Namespace for the AWS Load Balancer Controller."
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Service account name used by the controller."
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "role_name" {
  description = "Name of the IAM role to create for the controller."
  type        = string
  default     = "crickethub-alb-controller"
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN for the cluster."
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL for the cluster."
  type        = string
}

variable "chart_version" {
  description = "Helm chart version for the AWS Load Balancer Controller."
  type        = string
  default     = "1.8.1"
}

variable "tags" {
  description = "Common tags applied to AWS resources."
  type        = map(string)
  default     = {}
}
