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

source "amazon-ebs" "amzn2" {
  profile         = "default"
  region          = "${var.aws_region}"
  vpc_id          = "${var.aws_vpc_id}"
  subnet_id       = "${var.aws_subnet_id}"
  instance_type   = "${var.aws_instance_type}"
  ami_name        = "${var.ami_prefix}-${local.timestamp}"
  ami_description = "Amazon Linux AMI v2 created by Packer"

  launch_block_device_mappings {
    volume_size           = 10
    delete_on_termination = true
    volume_type           = "gp3"
    device_name           = "/dev/xvda"
  }

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  ssh_username = "ec2-user"
  ssh_timeout  = "5m"

  tags = {
    Name                     = var.ami_name
    Operating_System_Version = "Amazon Linux v2"
    Source_AMI               = "{{ .SourceAMI }}"
    Base_AMI_Name            = "{{ .SourceAMIName }}"
    Creation_Date            = "{{ .SourceAMICreationDate }}"
  }
}

build {
  name    = var.ami_name
  sources = ["source.amazon-ebs.amzn2"]

  provisioner "file" {
    source      = "./scripts/init-install.sh"
    destination = "/tmp/init-install.sh"
  }

  provisioner "file" {
    source      = "./Initialize_Files"
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
