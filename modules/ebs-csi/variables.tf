variable "namespace" {
  description = "Namespace for the EBS CSI driver."
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Service account name used by the driver."
  type        = string
  default     = "ebs-csi-controller-sa"
}

variable "role_name" {
  description = "IAM role name for the EBS CSI driver."
  type        = string
  default     = "crickethub-ebs-csi"
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
  description = "Helm chart version for the EBS CSI driver."
  type        = string
  default     = "2.36.0"
}

variable "storage_class_name" {
  description = "Name of the EBS StorageClass to create."
  type        = string
  default     = "aws-ebs"
}

variable "tags" {
  description = "Common tags applied to AWS resources."
  type        = map(string)
  default     = {}
}
