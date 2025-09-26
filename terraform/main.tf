provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "me" {}

# Use default VPC and its first public subnet
data "aws_vpc" "default" { default = true }
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ECR repos
resource "aws_ecr_repository" "webapp" {
  name = "clo835-webapp"
}

resource "aws_ecr_repository" "mysql" {
  name = "clo835-mysql"
}

# IAM role
#resource "aws_iam_role" "ec2_role" {
 # count = var.create_iam_role ? 1 : 0
  #name  = "ec2-ecr-pull-role"

  #assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
#}

# Instance profile
#resource "aws_iam_instance_profile" "ec2_profile" {
 # count = var.create_iam_role ? 1 : 0
  #name  = "ec2-ecr-profile"
  #role  = aws_iam_role.ec2_role[0].name
#}

# Attach AWS managed policy
#resource "aws_iam_role_policy_attachment" "ecr_pull" {
 # count      = var.create_iam_role ? 1 : 0
  #role       = aws_iam_role.ec2_role[0].name
  #policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#}


# Security group (allow SSH + HTTP ports 8081-8083)
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-web-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "App ports"
    from_port   = 8081
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance in first default subnet
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"] 
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.ssh_key_name
  
  # Attach instance profile only if IAM role was created
  iam_instance_profile =  null

  user_data = file("${path.module}/user_data.sh")
  tags = { Name = "clo835-app-host" }
}
