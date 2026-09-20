region = "us-east-1"

project_name = "crickethub"
environment  = "dev"
cluster_name = "crickethub-dev-us-east-1"

vpc = {
  cidr            = "10.30.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.30.1.0/24", "10.30.2.0/24"]
  private_subnets = ["10.30.11.0/24", "10.30.12.0/24"]
}

eks = {
  version        = "1.34"
  instance_types = ["t3.medium"]
  min_size       = 1
  desired_size   = 2
  max_size       = 3
  disk_size      = 50
}

alb_controller = {
  enabled = true
}

ebs_csi = {
  enabled = true
}

common_tags = {
  Project     = "crickethub"
  Environment = "dev"
  ManagedBy   = "terraform"
}
