
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "terraform-state-tf-s3-bucket-0001"
    key          = "ec2/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "server" {
  for_each      = var.instances
  ami           = var.ami_id
  instance_type = var.instance_type
  # IAM 
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  
  tags = {
    Name = each.key
  }
  # IAM
  depends_on = [
    aws_iam_role_policy_attachment.ssm
  ]
}

resource "aws_eip" "server" {
  for_each = aws_instance.server

  domain = "vpc"

  tags = {
    Name = "${each.key}-eip"
  }
}

resource "aws_eip_association" "server" {
  for_each = aws_instance.server

  instance_id   = each.value.id
  allocation_id = aws_eip.server[each.key].id
}

###AWS Systems Manager (SSM)

# IAM role
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
# SSM policy
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

moved {
  from = aws_instance.web
  to   = aws_instance.server["web"]
}