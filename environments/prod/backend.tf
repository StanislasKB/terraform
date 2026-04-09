# Backend S3 - Remote State PROD


terraform {
  backend "s3" {
    bucket         = "ton-bucket-tfstate"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
