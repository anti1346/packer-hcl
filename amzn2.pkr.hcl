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
# locals {
#   timestamp = timestamp()
#   formatted_timestamp = formatdate("YYYYMMDD-HHMM", local.timestamp) # YYYYMMDD
# }


variables {
  ami_prefix           = "amzn2-nginx_php-fpm"
  ami_verser           = "v1.1.1"
  aws_region           = "ap-northeast-2"
  aws_vpc_id           = "vpc-0"
  aws_subnet_id        = "subnet-0"
  aws_instance_type    = "t3a.medium" #t3a.medium, c5a.xlarge
  block_device_size_gb = "10"
}

source "amazon-ebs" "amzn2" {
  profile         = "default" # AWS 자격 증명 프로필 이름을 설정하세요.
  region          = var.aws_region
  vpc_id          = var.aws_vpc_id
  subnet_id       = var.aws_subnet_id
  instance_type   = var.aws_instance_type
  ami_name        = "${var.ami_prefix}-{{timestamp}}"
  # ami_name        = "${var.ami_prefix}-${var.ami_verser}_${local.formatted_timestamp}"
  ami_description = "Amazon Linux AMI v2 created by Packer"

  launch_block_device_mappings {
    volume_size           = var.block_device_size_gb
    delete_on_termination = true
    volume_type           = "gp3"
    device_name           = "/dev/xvda"
  }

  # 필요한 이미지 필터를 설정하세요.
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"
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
    # Name                     = "${var.ami_prefix}-${var.ami_verser}_${local.formatted_timestamp}"
    Operating_System_Version = "Amazon Linux v2"
    Source_AMI               = "{{ .SourceAMI }}"
    Base_AMI_Name            = "{{ .SourceAMIName }}"
    Creation_Date            = "{{ .SourceAMICreationDate }}"
  }
}

build {
  name    = "${var.ami_prefix}-{{timestamp}}"
  # name    = "${var.ami_prefix}-${var.ami_verser}_${local.formatted_timestamp}"
  sources = ["source.amazon-ebs.amzn2"]

  provisioner "file" {
    source      = "./scripts/init-install.sh"
    destination = "/tmp/init-install.sh"
  }

  provisioner "file" {
    source      = "./WEB-CONFIG"
    destination = "/tmp/Initialize_Files"
  }

  provisioner "shell" {
    inline = [
      "sudo chmod +x /tmp/init-install.sh",
      "bash /tmp/init-install.sh",
      "echo 'AMI Build Completed'"
    ]
  }

  post-processor "shell-local" {
    inline = ["echo 'AMI Build Completed'"]
  }
}

# packer -var "aws_access_key=$AWS_ACCESS_KEY" -var "aws_secret_key=$AWS_SECRET_KEY"
