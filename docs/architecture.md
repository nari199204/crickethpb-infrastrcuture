# CricketHub AWS Architecture

## Platform overview

Terraform will provision the AWS platform required for the CricketHub application, while the application itself remains managed by ArgoCD and Helm.

## Components

- VPC with public and private subnets across multiple AZs
- NAT Gateways for private egress
- EKS control plane and managed node groups
- OIDC provider for IRSA
- ECR repositories for all app services
- AWS Load Balancer Controller with IRSA
- EBS CSI driver with IRSA and StorageClass
- security groups and least-privilege IAM
- remote Terraform state in S3 with state locking

## Separation of concerns

Terraform owns:

- AWS platform
- EKS cluster
- IAM/IRSA
- ECR
- Storage infrastructure
- networking and load balancer plumbing

ArgoCD/Helm owns:

- CricketHub applications
- Ingress definitions
- Deployments, Services, Secrets, and config

## Production-style defaults

- multi-AZ networking
- private worker subnets
- public ALB-facing subnets
- encryption at rest
- VPC and S3 security hardening
- centralized ECR image registry
- StorageClass alignment with the application’s existing `aws-ebs` naming compatibility
