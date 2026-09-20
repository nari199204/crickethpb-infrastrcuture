variable "project_name" {
  description = "Project name prefix used for naming resources."
  type        = string
}

variable "environment" {
  description = "Environment identifier such as dev or prod."
  type        = string
}

variable "vpc_id" {
  description = "Target VPC ID."
  type        = string
}

variable "tags" {
  description = "Common tag map."
  type        = map(string)
  default     = {}
}
