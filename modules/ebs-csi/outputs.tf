output "storage_class_name" {
  description = "Name of the created EBS storage class."
  value       = kubernetes_storage_class_v1.ebs_gp3.metadata[0].name
}

output "role_arn" {
  description = "IAM role ARN for the EBS CSI controller."
  value       = aws_iam_role.this.arn
}
