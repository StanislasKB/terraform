# Module SSH Key - Variables

variable "key_name" {
  description = "Nom de la paire de clés dans AWS EC2"
  type        = string
}

variable "public_key" {
  description = "Contenu de la clé publique SSH (injectée depuis GitHub Secrets via -var)"
  type        = string
}
