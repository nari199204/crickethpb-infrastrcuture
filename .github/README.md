# GitHub Actions for CricketHub Infra

This repository includes a production-style Terraform pipeline for the AWS platform.

## Required GitHub secrets

- `AWS_ROLE_TO_ASSUME`: IAM role ARN that GitHub OIDC can assume

## Required GitHub variables

- `TERRAFORM_STATE_BUCKET`: set to the S3 bucket name used for remote state, e.g. `crickethub-us-east-1-terraform-state`

## Required GitHub environment

Create a GitHub environment named `plan-approval` and configure required reviewers so that apply cannot proceed without approval.

## Workflow flow

- `terraform-bootstrap.yml`: creates the S3 backend bucket for remote state.
- `terraform-plan.yml`: runs the full validation pipeline:
  - `terraform fmt -check`
  - `terraform init -backend=false`
  - `terraform validate`
  - `tfsec` security scanning
  - `terraform plan`
- `terraform-apply.yml`: stops at a `plan-approval` environment gate and only then runs `terraform apply` when the confirmation input is `APPLY`.

Use the Actions tab in GitHub to trigger them manually.
