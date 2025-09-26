#!/bin/bash
yum update -y

# For Amazon Linux 2:
amazon-linux-extras install -y docker || yum install -y docker
service docker start
usermod -a -G docker ec2-user
chmod 666 /var/run/docker.sock

# install awscli v2 if not installed (quick way)
if ! command -v aws >/dev/null 2>&1; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
  unzip /tmp/awscliv2.zip -d /tmp
  /tmp/aws/install
fi

