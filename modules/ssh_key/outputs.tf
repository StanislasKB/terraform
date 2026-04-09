# Module SSH Key - Outputs

output "key_name" {
  description = "Nom de la clé enregistrée dans AWS (passé au module EC2)"
  value       = aws_key_pair.this.key_name
}
