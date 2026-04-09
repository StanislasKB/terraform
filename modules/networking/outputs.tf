# Module Networking - Outputs

output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID du subnet public (à passer au module EC2)"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID du Security Group (à passer au module EC2)"
  value       = aws_security_group.this.id
}
