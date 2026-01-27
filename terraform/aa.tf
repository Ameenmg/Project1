terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
  backend "s3" {
    key    = "aws/ec2-deploy/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "server" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t2.nano"
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.maingroup.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  connection {
    type = "ssh"
    host = self.public_ip
    user = ubuntu
    private_key = var.private_key
    timeout = "4m"

  }

  tags = {
    Name = "DeployVM"
  }
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = "EC2-ECR-AUTH"
}


resource "aws_key_pair" "deployer" {
  key_name = var.key_name
  public_key = var.public_key


}


resource "aws_security_group" "maingroup" {
  # ... other configuration ...

  ingress {
    protocol  = "tcp"
    self      = false
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]


  }
  ingress {
    protocol  = "tcp"
    self      = false
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]


  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self      = false
  }


}


output "instance_puplic_ip" {
    value = aws_instance.server.public_ip
    sensitive = true
}