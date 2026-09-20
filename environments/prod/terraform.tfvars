region = "us-east-1"

project_name = "crickethub"
environment  = "prod"
cluster_name = "crickethub-prod-us-east-1"

vpc = {
  cidr            = "10.40.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.40.1.0/24", "10.40.2.0/24", "10.40.3.0/24"]
  private_subnets = ["10.40.11.0/24", "10.40.12.0/24", "10.40.13.0/24"]
}

eks = {
  version        = "1.29"
  instance_types = ["m6i.large"]
  min_size       = 2
  desired_size   = 3
  max_size       = 6
  disk_size      = 100
}

alb_controller = {
  enabled = true
}

ebs_csi = {
  enabled = true
}

common_tags = {
  Project     = "crickethub"
  Environment = "prod"
  ManagedBy   = "terraform"
}
