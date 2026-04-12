# Backend S3 - Remote State DEV

terraform {
  backend "s3" {
    bucket         = "staging-tfstate-008347"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
