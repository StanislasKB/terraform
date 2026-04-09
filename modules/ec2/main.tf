# Module EC2 - Ressource principale

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile != "" ? var.iam_instance_profile : null

  associate_public_ip_address = var.associate_public_ip

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = var.encrypt_volumes
  }

  dynamic "ebs_block_device" {
    for_each = var.extra_ebs_volumes
    content {
      device_name           = ebs_block_device.value.device_name
      volume_type           = ebs_block_device.value.volume_type
      volume_size           = ebs_block_device.value.volume_size
      encrypted             = var.encrypt_volumes
      delete_on_termination = true
    }
  }

  user_data = var.user_data != "" ? var.user_data : null

  metadata_options {
    http_tokens   = "required" 
    http_endpoint = "enabled"
  }

  monitoring = var.enable_detailed_monitoring

  tags = merge(
    {
      Name        = var.instance_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.extra_tags
  )
}

# Elastic IP (optionnelle)

resource "aws_eip" "this" {
  count    = var.create_eip ? 1 : 0
  instance = aws_instance.this.id
  domain   = "vpc"

  tags = {
    Name        = "${var.instance_name}-eip"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
