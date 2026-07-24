output "instance_id" {
  description = "ID da instância EC2 criada"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "IP público da instância (uso limitado em ambiente local/emulado)"
  value       = aws_instance.web.public_ip
}

output "security_group_id" {
  description = "ID do security group criado"
  value       = aws_security_group.ec2_sg.id
}

output "vpc_id" {
  description = "ID da VPC criada para este lab"
  value       = aws_vpc.main.id
}
