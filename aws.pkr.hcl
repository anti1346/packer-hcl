locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

variable "aws_access_key" {
  type    = string
  default = "aws_access_key"
  description = "AWS access key"
}

variable "aws_secret_key" {
  type    = string
  default = "aws_secret_key"
  description = "AWS secret key"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile to use. Typically found in ~/.aws/credentials"
  default     = "default"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_instance_type" {
  type    = string
  default = "t3a.medium"
}

variable "ami_prefix" {
  type        = string
  description = "Prefix to be applied to the image name"
  default     = "aws-packer"
}

variable "ami_dist" {
  type        = string
  description = "Operating system distribution"
  default     = "amazon2"
}

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  # access_key            = var.aws_access_key
  # secret_key            = var.aws_secret_key
  profile               = var.aws_profile
  region                = var.aws_region
  instance_type         = var.aws_instance_type
  source_ami_filter {
    filters = {
                            ##### ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20221206
                            ##### ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20221201
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent           = true
    owners                = ["099720109477"]
  }
  ssh_username            = "ubuntu"
  ami_name                = "${var.ami_prefix}-${var.ami_dist}-${local.timestamp}"
  user_data_file          = "./user-data/init-install.sh"
  tags = {
    name                  = "${var.ami_prefix}-${var.ami_dist}-${local.timestamp}"
    OS_Version            = "ubuntu"
    Base_AMI_ID           = "{{ .SourceAMI }}"
    Base_AMI_Name         = "{{ .SourceAMIName }}"
    Creation_Date         = "{{ .SourceAMICreationDate }}"
  }
}

source "amazon-ebs" "amazon2" {
  # access_key            = var.aws_access_key
  # secret_key            = var.aws_secret_key
  profile               = var.aws_profile
  region                = var.aws_region
  instance_type         = var.aws_instance_type
  source_ami_filter {
    filters = {
                            ##### amzn2-ami-kernel-5.10-hvm-2.0.20221210.1-x86_64-gp2
                            ##### amzn2-ami-hvm-2.0.20221210.1-x86_64-gp2
      name                = "amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent           = true
    owners                = ["137112412989"]
  }
  ssh_username            = "ec2-user"
  ami_name                = "${var.ami_prefix}-${var.ami_dist}-${local.timestamp}"
  user_data_file          = "./user-data/init-install.sh"
  tags = {
    name                  = "${var.ami_prefix}-${var.ami_dist}-${local.timestamp}"
    OS_Version            = "amazon2"
    Base_AMI_ID           = "{{ .SourceAMI }}"
    Base_AMI_Name         = "{{ .SourceAMIName }}"
    Creation_Date         = "{{ .SourceAMICreationDate }}"
  }
}

build {
  name    = "${var.ami_prefix}-${var.ami_dist}-${local.timestamp}"
  sources = [
    "source.amazon-ebs.${var.ami_dist}"
  ]

  provisioner "shell" {
    inline = [
      "sudo hostnamectl set-hostname ${var.ami_prefix}-${var.ami_dist}-${local.timestamp}"
    ]
  }

  ##### var.ami_dist = amazon2 or ubuntu
  ##### awscli install
  provisioner "shell" {
    script = "scripts/install-awscli.sh"
  }
  ##### codeploy-agent install
  provisioner "shell" {
    script = "scripts/install-codeploy-agent.sh"
  }
  ##### docker install
  provisioner "shell" {
    script = "scripts/install-docker.sh"
  }
  ##### application : nginx, phpfpm install
  provisioner "shell" {
    script = "scripts/${var.ami_dist}/application-nginx-phpfpm.sh"
  }
  ##### application : laravel install
  # provisioner "shell" {
  #   script = "scripts/${var.ami_dist}/application-laravel.sh"
  # }

  post-processor "shell-local" {
    inline = ["echo foo"]
  }

}

