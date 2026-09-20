variable "role_name" {
  description = "Name of the IAM role to create."
  type        = string
}

variable "policy_name" {
  description = "Name of the IAM policy."
  type        = string
}

variable "policy_description" {
  description = "Description for the IAM policy."
  type        = string
  default     = "Managed by Terraform"
}

variable "policy_json" {
  description = "JSON policy document to attach to the IAM role."
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider."
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the EKS OIDC provider."
  type        = string
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for the service account."
  type        = string
}

variable "kubernetes_service_account" {
  description = "Kubernetes service account name."
  type        = string
}

variable "tags" {
  description = "Tags applied to IAM resources."
  type        = map(string)
  default     = {}
}

variable "additional_policy_arns" {
  description = "Additional AWS managed policies to attach."
  type        = set(string)
  default     = []
}
