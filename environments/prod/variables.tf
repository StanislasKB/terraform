# Environnement PROD - Variables

# Général
variable "aws_region" {
  description = "Région AWS cible"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Nom de l'environnement"
  type        = string
  default     = "prod"
}

# SSH

variable "ssh_public_key" {
  description = "Contenu de la clé publique SSH (ex: ssh-ed25519 AAAA...)"
  type        = string
  sensitive   = true
}
variable "key_name" {
  description = "Nom de la paire de clés SSH dans AWS"
  type        = string
}

# AMI
variable "ami_id" {
  description = "ID de l'AMI"
  type        = string
}

# Instances
variable "instances" {
  description = "Map des instances EC2 à créer"
  type = map(object({
    instance_type = string
    extra_tags    = optional(map(string), {})
  }))
}

# Réseau
variable "vpc_cidr" {
  description = "Bloc CIDR du VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Bloc CIDR du subnet public"
  type        = string
}

variable "availability_zone" {
  description = "Zone de disponibilité pour le subnet"
  type        = string
}

variable "ingress_rules" {
  description = "Règles entrantes du Security Group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr        = string
    description = optional(string, "")
  }))
}

# Stockage
variable "root_volume_size" {
  type    = number
  default = 20
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "encrypt_volumes" {
  type    = bool
  default = true
}

variable "extra_ebs_volumes" {
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
  }))
  default = []
}

# IAM
variable "iam_instance_profile" {
  type    = string
  default = ""
}

# User Data
variable "user_data" {
  type    = string
  default = ""
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = true
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
