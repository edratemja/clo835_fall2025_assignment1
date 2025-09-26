# ---------------------------
# EC2 Instance Outputs
# ---------------------------
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app.public_ip
}

output "ec2_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.app.private_ip
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app.id
}

# ---------------------------
# ECR Repository Outputs
# ---------------------------
output "webapp_ecr_repo_url" {
  description = "URI of the webapp ECR repository"
  value       = aws_ecr_repository.webapp.repository_url
}

output "mysql_ecr_repo_url" {
  description = "URI of the MySQL ECR repository"
  value       = aws_ecr_repository.mysql.repository_url
}

# ---------------------------
# Security Group Output
# ---------------------------
output "ec2_security_group_id" {
  description = "Security group ID for EC2 instance"
  value       = aws_security_group.ec2_sg.id
}


