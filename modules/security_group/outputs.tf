
output "aws_sg_allow_web" {
  value = aws_security_group.allow_WEB.id
}

output "aws_sg_internal_access" {
  value = aws_security_group.internal_access.id
}
