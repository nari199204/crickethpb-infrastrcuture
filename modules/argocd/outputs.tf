output "argocd_namespace" {
  description = "Namespace where Argo CD is installed."
  value       = var.namespace
}

output "argocd_release_name" {
  description = "Helm release name for Argo CD."
  value       = helm_release.argocd.name
}
