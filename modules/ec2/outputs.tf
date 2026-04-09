# Module EC2 - Outputs

output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN de l'instance EC2"
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "Adresse IP privée de l'instance"
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Adresse IP publique auto-assignée (si activée)"
  value       = aws_instance.this.public_ip
}

output "elastic_ip" {
  description = "Elastic IP associée (si créée)"
  value       = var.create_eip ? aws_eip.this[0].public_ip : null
}

output "instance_state" {
  description = "État actuel de l'instance"
  value       = aws_instance.this.instance_state
}

output "availability_zone" {
  description = "Zone de disponibilité de l'instance"
  value       = aws_instance.this.availability_zone
}

output "eip_ip" {
  description = "IP de l'EIP associé"
  value       = var.create_eip ? aws_eip.this[0].public_ip : null
}