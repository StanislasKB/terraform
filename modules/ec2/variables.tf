# Module EC2 - Variables

# Identification
variable "instance_name" {
  description = "Nom de l'instance EC2 (tag Name)"
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement (ex: dev, staging, prod)"
  type        = string
}

# AMI & Type
variable "ami_id" {
  description = "ID de l'AMI à utiliser (ex: ami-0c55b159cbfafe1f0)"
  type        = string
}

variable "instance_type" {
  description = "Type d'instance EC2 (ex: t3.micro, t3.medium, m5.large)"
  type        = string
  default     = "t3.micro"
}

# Réseau
variable "subnet_id" {
  description = "ID du sous-réseau dans lequel lancer l'instance"
  type        = string
}

variable "security_group_ids" {
  description = "Liste des IDs de Security Groups à associer"
  type        = list(string)
  default     = []
}

variable "associate_public_ip" {
  description = "Associer une IP publique automatique à l'instance"
  type        = bool
  default     = false
}

variable "create_eip" {
  description = "Créer et associer une Elastic IP (IP publique statique)"
  type        = bool
  default     = false
}

# Accès SSH
variable "key_name" {
  description = "Nom de la paire de clés SSH AWS (doit exister au préalable)"
  type        = string
}

# Stockage
variable "root_volume_size" {
  description = "Taille du volume racine en Go"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type du volume racine (gp3, gp2, io1...)"
  type        = string
  default     = "gp3"
}

variable "encrypt_volumes" {
  description = "Chiffrer les volumes EBS"
  type        = bool
  default     = true
}

variable "extra_ebs_volumes" {
  description = "Volumes EBS additionnels à attacher"
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
  }))
  default = []
}

# IAM
variable "iam_instance_profile" {
  description = "Nom du profil IAM à associer à l'instance (optionnel)"
  type        = string
  default     = ""
}

# User Data
variable "user_data" {
  description = "Script User Data à exécuter au démarrage (bash, cloud-init...)"
  type        = string
  default     = ""
}

# Monitoring
variable "enable_detailed_monitoring" {
  description = "Activer le monitoring détaillé CloudWatch (facturation supplémentaire)"
  type        = bool
  default     = false
}

# Tags
variable "extra_tags" {
  description = "Tags supplémentaires à appliquer à l'instance"
  type        = map(string)
  default     = {}
}
