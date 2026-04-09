# Environnement DEV - Valeurs des variables

# Général
aws_region   = "us-east-1"
project_name = "web-laravel"
environment  = "dev"

# AMI
ami_id = "ami-0b6c6ebed2801a5cb" 

# Instances
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
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "us-east-1a"

# Règles entrantes du Security Group
ingress_rules = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr        = "0.0.0.0/0"  
    description = "SSH"
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr        = "0.0.0.0/0"
    description = "HTTP"
  },
   {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr        = "0.0.0.0/0"
    description = "MySQL"
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

# Volumes additionnels
extra_ebs_volumes = []

# IAM
iam_instance_profile = ""

# User Data
user_data = <<-EOF
  #!/bin/bash
  apt update -y
  echo "Instance DEV démarrée" >> /var/log/init.log
EOF

# Monitoring
enable_detailed_monitoring = false

# Tags communs
extra_tags = {
  Owner      = "equipe-dev"
  CostCenter = "123"
}