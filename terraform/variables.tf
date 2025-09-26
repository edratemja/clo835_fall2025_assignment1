variable "aws_region" {
  default = "us-east-1"
}

variable "ssh_key_name" {
  description = "EC2 key pair name to use"
  default     = "CLO835_Assmnt1_Key"
}

variable "create_iam_role" {
  description = "Whether to create IAM role for EC2 (set false in Learner Lab)"
  type        = bool
  default     = false
}
