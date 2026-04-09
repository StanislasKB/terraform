# Module SSH Key
# La clé est pré-générée en dehors de Terraform.
# On enregistre uniquement la clé PUBLIQUE dans AWS.
# La clé PRIVÉE est stockée dans GitHub Secrets → utilisée par Ansible.

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = var.public_key

  tags = {
    Name      = var.key_name
    ManagedBy = "Terraform"
  }
}
