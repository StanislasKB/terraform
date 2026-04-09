# Environnement STAGING - Valeurs non-sensibles


# Général
aws_region   = "us-east-1"
project_name = "web-laravel"
environment  = "staging"

# AMI (Ubuntu 22.04 LTS us-east-1)
ami_id = "ami-0b6c6ebed2801a5cb"

# Instances 
instances = {
  web = {
    instance_type = "t3.micro"
    extra_tags    = { Role = "webserver" }
  }
}

# Réseau
vpc_cidr           = "10.2.0.0/16"
public_subnet_cidr = "10.2.1.0/24"
availability_zone  = "us-east-1a"

# Règles Security Group
ingress_rules = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr        = "0.0.0.0/0"
    description = "SSH - GitHub Actions runner"
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr        = "0.0.0.0/0"
    description = "HTTP"
  },
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr        = "0.0.0.0/0"
    description = "HTTPS"
  }
]

# Stockage
root_volume_size = 20
root_volume_type = "gp3"
encrypt_volumes  = true
extra_ebs_volumes = []

# IAM
iam_instance_profile = ""

# User Data 
user_data = <<-EOF
  #!/bin/bash
  apt-get update -y
  apt-get install -y python3
  echo "Instance STAGING prête" >> /var/log/init.log
EOF

# Monitoring
enable_detailed_monitoring = false
