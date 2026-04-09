# Environnement PROD

# Général
aws_region   = "us-east-1"
project_name = "mon-projet"
environment  = "prod"

# AMI
ami_id = "ami-0b6c6ebed2801a5cb"

instances = {
  web = {
    instance_type = "t3.micro"
    extra_tags    = { Role = "webserver" }
  }
  db = {
    instance_type = "t3.micro"
    extra_tags    = { Role = "database" }
  }
}

# Réseau
vpc_cidr           = "10.1.0.0/16"
public_subnet_cidr = "10.1.1.0/24"
availability_zone  = "us-east-1a"

# Règles entrantes du Security Group (SSH restreint en prod)
ingress_rules = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr        = "10.1.1.0/24"   
    description = "SSH interne"
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
root_volume_size = 15
root_volume_type = "gp3"
encrypt_volumes  = true

extra_ebs_volumes = [
  {
    device_name = "/dev/sdb"
    volume_size = 15
    volume_type = "gp3"
  }
]

# IAM
iam_instance_profile = ""

# User Data
user_data = <<-EOF
  #!/bin/bash
  apt update -y
  echo "Instance PROD démarrée" >> /var/log/init.log
EOF

# Monitoring
enable_detailed_monitoring = true

# Tags supplémentaires
extra_tags = {
  Owner       = "equipe-ops"
  CostCenter  = "456"
  Criticality = "high"
}
