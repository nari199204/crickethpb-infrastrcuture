# CricketHub Reference Infrastructure

This document summarizes the AWS infrastructure implied by the existing CricketHub application repository and the Kubernetes manifests currently used by the app. It is a design reference for a separate Terraform infrastructure repository and does not modify the application repository.

## 1. Application-derived requirements

### 1.1 Services and ports
The application repository uses these runtime services and port mappings:

- frontend: port 3000
- api-gateway: port 8080
- auth-service: port 8081
- team-service: port 8082
- match-service: port 8083
- scoring-service: port 8084
- PostgreSQL: port 5432 (internal service)

This indicates an EKS cluster with a managed internal service mesh and an external ALB/Ingress for user traffic.

### 1.2 Kubernetes ingress
The application chart and raw manifests use an AWS ALB ingress, not a generic NGINX ingress. Relevant requirements include:

- `kubernetes.io/ingress.class: alb`
- `alb.ingress.kubernetes.io/scheme: internet-facing`
- `alb.ingress.kubernetes.io/target-type: ip`
- health checks on `/health`
- path routing:
  - `/api` -> `api-gateway:8080`
  - `/` -> `frontend:3000`

This means Terraform must provision:

- AWS Load Balancer Controller on EKS
- IAM role with IRSA for the controller
- proper subnet tagging for the ALB controller
- public subnets for ALB

### 1.3 PostgreSQL and storage
The application requires a PostgreSQL database and storage:

- PostgreSQL container: `postgres:16-alpine`
- database secret and init SQL for multiple databases:
  - `auth_db`
  - `team_db`
  - `match_db`
  - `scoring_db`
- persistent volume claim with `ReadWriteOnce`
- StorageClass `aws-ebs`
- storage request around `10Gi`

This implies:

- EBS CSI driver on EKS
- EBS StorageClass definition managed by Terraform
- a production-style `gp3` StorageClass with `WaitForFirstConsumer` and `allowVolumeExpansion`
- Kubernetes workloads that reference the database via a service named `postgres`

### 1.4 AWS ECR dependencies
The application manifests reference container images from ECR, including an account-specific ECR hostname pattern:

- `114268015259.dkr.ecr.ap-south-1.amazonaws.com/crickethub/...`

This implies the infrastructure repository must create ECR repositories for:

- frontend
- api-gateway
- auth-service
- team-service
- match-service
- scoring-service

These ECR repos should support:

- image scanning
- encryption at rest
- lifecycle policy
- immutable tags where practical
- repository outputs for later CI/CD image pushes

### 1.5 Kubernetes environment and networking
The app is built around a single namespace:

- `crickethub`

The stack includes:

- namespace creation
- internal Kubernetes services per app
- a central API gateway fronting backend services
- frontend deployment
- Postgres deployment and service
- ingress routing to both frontend and API

This requires a VPC with separated public and private subnets and cluster worker nodes in private subnets.

### 1.6 AWS region
The app’s reference environment is clearly in:

- `ap-south-1`

The infrastructure repo must allow region configuration while defaulting to `ap-south-1` for the reference environment.

## 2. Infrastructure requirements inferred from the application

### 2.1 VPC
Required:

- VPC with configurable CIDR
- public subnets in multiple AZs
- private subnets in multiple AZs
- internet gateway
- NAT gateways (or NAT instance strategy if intentionally simpler)
- route tables and associations
- subnet tags required by EKS and ALB:
  - `kubernetes.io/cluster/<cluster-name> = shared`
  - `kubernetes.io/role/elb = 1` for public subnets
  - `kubernetes.io/role/internal-elb = 1` for private subnets if used

### 2.2 EKS cluster
Required:

- EKS control plane
- managed node groups
- private worker subnets
- cluster logging enabled
- OIDC provider enabled
- configurable Kubernetes version
- node IAM role and cluster IAM role
- minimal security baseline

### 2.3 IAM and IRSA
Required roles for:

- EBS CSI controller
- AWS Load Balancer Controller

Required trust: OIDC provider from EKS cluster, with least-privilege IAM policies.

### 2.4 StorageClass and EBS CSI
Required:

- EBS CSI add-on or Helm-based installation through Terraform
- StorageClass named `aws-ebs` is currently used by the app
- application Helm chart should not own the StorageClass; Terraform should
- recommended class settings:
  - provisioner: `ebs.csi.aws.com`
  - `type: gp3`
  - `fsType: ext4`
  - `volumeBindingMode: WaitForFirstConsumer`
  - `allowVolumeExpansion: true`

If the existing app still references `aws-ebs`, the Terraform-created class should preserve that name for compatibility unless explicitly migrated. The design should document this compatibility decision.

### 2.5 AWS Load Balancer Controller
Required:

- IRSA role for controller
- proper policy
- service account created for controller use
- ALB ingress support in the cluster

### 2.6 Security baseline
Required:

- EKS endpoint private/public configuration decisions
- private worker subnets
- security groups for node groups and ALB
- encryption for ECR and S3 backend
- public access blocking on S3 state bucket
- bucket versioning and SSE
- least-privilege IAM

## 3. Kubernetes version and instance types
The application repo does not explicitly pin a Kubernetes version, but the EKS cluster must be modern and production-safe. The reference environment uses AWS and the app’s current configuration expects EKS-managed workloads with ALB and EBS CSI. A sensible default is:

- Kubernetes version: `1.29` or `1.30` depending on current AWS support at deployment time
- node size: `t3.medium` or `t3.large` for dev; `m6i.large` or `m6i.xlarge` for prod

These values should be variables rather than hard-coded in modules.

## 4. Proposed Terraform module structure

Recommended structure:

- `modules/vpc`
- `modules/eks`
- `modules/iam`
- `modules/ecr`
- `modules/alb-controller`
- `modules/ebs-csi`
- `modules/security`

Responsibilities:

- `vpc`: VPC, public/private subnets, NAT, IGW, tags, routing
- `eks`: cluster, node groups, IAM roles, OIDC
- `iam`: reusable policy/role helpers and IRSA trust patterns
- `ecr`: ECR repos per app service
- `alb-controller`: controller IAM, policy, service account, helm release
- `ebs-csi`: CSI driver IAM, policy, service account, helm release, StorageClass
- `security`: common security controls, SG, tags, auditing-friendly defaults

## 5. State backend strategy
Terraform state must be remote and backed by S3. The repo should include a bootstrap process to create the S3 bucket before `terraform init` against the backend. Use:

- versioning
- encryption at rest
- public access block
- bucket ownership controls
- S3 native state locking with `use_lockfile = true`

Use separate state paths for:

- `dev`
- `prod`

## 6. Environment separation
The repository should use separate environment folders, not Terraform workspaces.

- `environments/dev`
- `environments/prod`

Common values can be passed via `variables.tf` and `terraform.tfvars`.

## 7. Important requirement
Terraform owns platform infrastructure only. It does not deploy the CricketHub application stack itself. The application lifecycle remains with ArgoCD/Helm after infrastructure is created.

This allows the platform to be provisioned cleanly and separately from the application release process.

## 8. Proposed implementation boundary
The next phase is to create the Terraform repository skeleton and the reference infrastructure document, but not to apply any AWS resources. The repository should be designed so it can later create a production-ready platform from scratch, while leaving the existing live cluster alone.
