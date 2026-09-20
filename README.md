# CricketHub Infrastructure

Terraform infrastructure repository for the CricketHub platform on AWS.

This repository is intentionally separate from the application code repository. It provisions the AWS platform required by the existing CricketHub application, including the VPC, EKS cluster, ECR, IAM/IRSA, EBS CSI, and AWS Load Balancer Controller infrastructure.

The application repo remains responsible for runtime application manifests and Helm deployments.

## Structure

- `bootstrap/s3-state/` - bootstrap S3 backend creation
- `modules/` - reusable Terraform modules
- `environments/dev` - dev environment configuration
- `environments/prod` - prod environment configuration
- `docs/` - architecture and reference analysis documentation

## Goals

- Build an EKS platform without `eksctl`
- Use reusable Terraform modules
- Keep environment configuration separate by directory
- Support separate remote state for `dev` and `prod`
- Support ECR, ALB, EBS CSI, VPC, IAM, and IRSA

## Notes

The application repository was used as a reference only. No application code was modified.

See [docs/reference-infrastructure.md](docs/reference-infrastructure.md) for the AWS platform requirements inferred from the existing application.
