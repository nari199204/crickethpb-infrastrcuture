variable "project_name" {
  description = "Project name used in naming resources."
  type        = string
}

variable "environment" {
  description = "Environment name, such as dev or prod."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane."
  type        = string
  default     = "1.29"
}

variable "subnet_ids" {
  description = "Public and private subnet IDs for the EKS cluster."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for managed node groups."
  type        = list(string)
}

variable "node_groups" {
  description = "Managed node group definitions."
  type = list(object({
    name            = string
    instance_types  = list(string)
    ami_type        = optional(string, "AL2023_x86_64_STANDARD")
    capacity_type   = optional(string, "ON_DEMAND")
    disk_size       = optional(number, 50)
    min_size        = optional(number, 1)
    desired_size    = optional(number, 2)
    max_size        = optional(number, 3)
    max_unavailable = optional(number, 1)
  }))
  default = [{
    name            = "general"
    instance_types  = ["t3.medium"]
    min_size        = 1
    desired_size    = 2
    max_size        = 3
    max_unavailable = 1
  }]
}

variable "enabled_cluster_log_types" {
  description = "EKS control plane log types."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "endpoint_private_access" {
  description = "Enable private API server endpoint."
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to access the public Kubernetes API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_security_group_ids" {
  description = "Security group IDs for the EKS control plane."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags applied to EKS resources."
  type        = map(string)
  default     = {}
}
