# Module Networking - VPC, Subnet, IGW, Security Group

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Subnet public
# map_public_ip_on_launch = true : chaque instance lancée ici reçoit une IP publique auto
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-subnet-public"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-igw"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Table de routage publique
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.name}-rt-public"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security Group pour ${var.name}"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Règles entrantes dynamiques 
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for rule in var.ingress_rules : "${rule.from_port}-${rule.protocol}-${rule.cidr}" => rule }

  security_group_id = aws_security_group.this.id
  ip_protocol       = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr
  description       = lookup(each.value, "description", "")
}

# Règle sortante : tout autoriser
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"
}
