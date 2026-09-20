output "service_account_name" {
  description = "Service account name created for the AWS Load Balancer Controller."
  value       = kubernetes_service_account.this.metadata[0].name
}

output "role_arn" {
  description = "IAM role ARN for the controller."
  value       = aws_iam_role.this.arn
}
