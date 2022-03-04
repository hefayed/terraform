terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.67.0"
    }
  }
}

# Create EC2 instance
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# assign a subnet id to the ec2 from public subnets
data "aws_subnets" "ec2_public" {
  filter {
    name   = "tag:Name"
    values = [for key, value in var.subnet_id : key if length(regexall("public-1a", key)) > 0]
  }
}

# assign a subnet id to the ec2 from private subnets
data "aws_subnets" "ec2_private" {
  filter {
    name   = "tag:Name"
    values = [for key, value in var.subnet_id : key if length(regexall("private-1a", key)) > 0]
  }
}


resource "aws_instance" "instance" {
  vpc_security_group_ids = [var.security_group_ids]
  subnet_id              = var.my_subnet == "public" ? data.aws_subnets.ec2_public.ids[0] : data.aws_subnets.ec2_private.ids[0]
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  ipv6_address_count     = 1
  key_name               = "terraform"
  tags = {
    Name = var.instance_tag
  }
  provisioner "remote-exec" {
    inline = var.inline_cmd

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/terraform.pem")
      host        = self.public_ip
    }
  }
}
