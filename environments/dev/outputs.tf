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