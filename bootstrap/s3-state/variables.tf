variable "region" {
  description = "AWS region for the bootstrap S3 state bucket."
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform remote state."
  type        = string
  default     = "crickethub-tfstate-dev"
}
