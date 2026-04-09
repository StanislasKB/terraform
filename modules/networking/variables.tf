# Module Networking - Variables

variable "name" {
  description = "Préfixe utilisé pour nommer toutes les ressources réseau"
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement (ex: dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloc CIDR du VPC (ex: 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Bloc CIDR du subnet public (doit être inclus dans vpc_cidr)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Zone de disponibilité AWS pour le subnet (ex: us-east-1a)"
  type        = string
}

variable "ingress_rules" {
  description = "Règles de sécurité entrantes"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr        = string
    description = optional(string, "")
  }))
  default = []
}
