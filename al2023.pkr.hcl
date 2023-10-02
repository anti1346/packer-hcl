packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.2.7"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

variables {
  ami_prefix           = "al2023-nginx_php-fpm"
  aws_region           = "ap-northeast-2"
  aws_vpc_id           = "vpc-06"
  aws_subnet_id        = "subnet-0d"
  aws_instance_type    = "t3a.medium"
  block_device_size_gb = "10"
}

source "amazon-ebs" "al2023" {
  profile         = "default" # AWS 자격 증명 프로필 이름을 설정하세요.
  region          = var.aws_region
  vpc_id          = var.aws_vpc_id
  subnet_id       = var.aws_subnet_id
  instance_type   = var.aws_instance_type
  ami_name        = "${var.ami_prefix}-{{timestamp}}"
  ami_description = "Amazon Linux AMI 2023 created by Packer"
  launch_block_device_mappings {
    volume_size           = var.block_device_size_gb
    delete_on_termination = true
    volume_type           = "gp3"
    device_name           = "/dev/xvda"
  }

  # 필요한 이미지 필터를 설정하세요.
  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-kernel-6.1-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  ssh_username  = "ec2-user"
  ssh_timeout   = "5m"

  tags = {
    Name                     = "${var.ami_prefix}-{{timestamp}}"
    Operating_System_Version = "Amazon Linux 2023"
    Source_AMI               = "{{ .SourceAMI }}"
    Base_AMI_Name            = "{{ .SourceAMIName }}"
    Creation_Date            = "{{ .SourceAMICreationDate }}"
  }
}

build {
  name    = "${var.ami_prefix}-{{timestamp}}"
  sources = ["source.amazon-ebs.al2023"]

  provisioner "shell" {
    script = "scripts/init-install.sh"
  }

  post-processor "shell-local" {
    inline = ["echo 'AMI Build Completed'"]
  }
}

# packer -var "aws_access_key=$AWS_ACCESS_KEY" -var "aws_secret_key=$AWS_SECRET_KEY"
