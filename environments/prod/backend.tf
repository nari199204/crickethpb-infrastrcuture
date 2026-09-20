terraform {
  backend "s3" {
    bucket       = "crickethub-us-east-1-terraform-state"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
