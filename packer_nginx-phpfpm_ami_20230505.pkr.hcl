packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.5"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


source "amazon-ebs" "ubuntu_2204" {
  ami_name      = "packer-ubuntu-22.04-{{timestamp}}"
  instance_type = "t3.micro"
  region        = "ap-northeast-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical
  }
  ssh_username = "ubuntu"
  tags = {
    Name = "packer-ubuntu-22.04-{{timestamp}}"
  }
}


build {
  name    = "packer-ubuntu-22.04-{{timestamp}}"
  sources = [
    "source.amazon-ebs.ubuntu_2204"
  ]

  provisioner "shell" {
    script       = "scripts/ubuntu/install-nginx-phpfpm_20230503.sh"
    pause_before = "10s"
    timeout      = "10s"
  }

  provisioner "shell" {
    script       = "scripts/ubuntu/os-settings_20230503.sh"
    pause_before = "10s"
    timeout      = "10s"
  }
}
