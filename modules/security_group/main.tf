terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.67.0"
    }
  }
}

# Create SG
resource "aws_security_group" "allow_WEB" {
  name        = "Web_Access"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id
  tags = {
    Name = "allow_WEB"
  }
}

resource "aws_security_group_rule" "SSH" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.inbound_IPv4_CIDR_Blocks]
  ipv6_cidr_blocks  = [var.inbound_IPv6_CIDR_Blocks]
  security_group_id = aws_security_group.allow_WEB.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [var.inbound_IPv4_CIDR_Blocks]
  ipv6_cidr_blocks  = [var.inbound_IPv6_CIDR_Blocks]
  security_group_id = aws_security_group.allow_WEB.id
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [var.inbound_IPv4_CIDR_Blocks]
  ipv6_cidr_blocks  = [var.inbound_IPv6_CIDR_Blocks]
  security_group_id = aws_security_group.allow_WEB.id
}

resource "aws_security_group" "internal_access" {
  name        = "internal_access"
  description = "Allow ssh inbound traffic from my public SG"
  vpc_id      = var.vpc_id
  tags = {
    Name = "internal_access"
  }
}

resource "aws_security_group_rule" "ssh_internal" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.allow_WEB.id
  security_group_id        = aws_security_group.internal_access.id
}

resource "aws_security_group_rule" "internal_outbound_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [var.inbound_IPv4_CIDR_Blocks]
  security_group_id = aws_security_group.internal_access.id
}
