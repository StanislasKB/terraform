# Environnement PROD

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Clé SSH
module "ssh_key" {
  source = "../../modules/ssh_key"

  key_name   = var.key_name
  public_key = var.ssh_public_key
}

# Réseau (VPC, Subnet, IGW, Security Group)
module "networking" {
  source = "../../modules/networking"

  name               = "${var.project_name}-${var.environment}"
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  ingress_rules      = var.ingress_rules
}

# Instance(s) EC2
module "ec2_instance" {
  source   = "../../modules/ec2"
  for_each = var.instances

  instance_name = "${var.project_name}-${var.environment}-${each.key}"
  environment   = var.environment
  ami_id        = var.ami_id
  instance_type = each.value.instance_type

  subnet_id          = module.networking.subnet_id
  security_group_ids = [module.networking.security_group_id]

  associate_public_ip = false
  create_eip          = true
  key_name            = module.ssh_key.key_name

  root_volume_size           = var.root_volume_size
  root_volume_type           = var.root_volume_type
  encrypt_volumes            = var.encrypt_volumes
  extra_ebs_volumes          = var.extra_ebs_volumes
  iam_instance_profile       = var.iam_instance_profile
  user_data                  = var.user_data
  enable_detailed_monitoring = var.enable_detailed_monitoring

  extra_tags = each.value.extra_tags
}
