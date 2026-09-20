output "bucket_name" {
  description = "Name of the created S3 bucket for remote Terraform state."
  value       = aws_s3_bucket.state.bucket
}

output "bucket_arn" {
  description = "ARN of the state bucket."
  value       = aws_s3_bucket.state.arn
}
