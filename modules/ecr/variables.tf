variable "project_name" {
  description = "Base project name for repository naming."
  type        = string
}

variable "repositories" {
  description = "List of ECR repositories to create."
  type        = list(string)
  default     = ["frontend", "api-gateway", "auth-service", "team-service", "match-service", "scoring-service"]
}

variable "image_tag_mutability" {
  description = "Whether image tags are mutable."
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Whether to scan images on push."
  type        = bool
  default     = true
}

variable "max_images_to_keep" {
  description = "Maximum number of tagged images to retain in each ECR repository."
  type        = number
  default     = 20
}

variable "tags" {
  description = "Tag map applied to ECR resources."
  type        = map(string)
  default     = {}
}
