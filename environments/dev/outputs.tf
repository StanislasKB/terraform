# Environnement DEV - Outputs

output "vpc_id" {
  description = "ID du VPC créé"
  value       = module.networking.vpc_id
}

output "subnet_id" {
  description = "ID du subnet public"
  value       = module.networking.subnet_id
}

output "security_group_id" {
  description = "ID du Security Group"
  value       = module.networking.security_group_id
}

output "instances" {
  description = "Infos de toutes les instances"
  value = {
    for k, instance in module.ec2_instance : k => {
      instance_id = instance.instance_id
      private_ip  = instance.private_ip
      public_ip   = instance.public_ip
    }
  }
}


output "web_public_ip" {
  description = "IP publique du serveur web - injectée dans l'inventaire Ansible"
  value       = module.ec2_instance["web"].public_ip
}


output "db_public_ip" {
  description = "IP publique du serveur db - injectée dans l'inventaire Ansible"
  value       = module.ec2_instance["db"].public_ip
}

output "db_private_ip" {
  description = "IP privée du serveur DB — utilisée par le serveur web pour se connecter à MySQL"
  value       = module.ec2_instance["db"].private_ip
}