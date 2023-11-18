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

source "amazon-ebs" "amzn2" {
  profile         = "default"
  region          = "${var.aws_region}"
  vpc_id          = "${var.aws_vpc_id}"
  subnet_id       = "${var.aws_subnet_id}"
  ami_name        = "${var.ami_prefix}-${var.ami_version}-${local.timestamp}"
  instance_type   = "${var.aws_instance_type}"
  ami_description = "${var.ami_description}"

  launch_block_device_mappings {
    volume_size           = "${var.block_device_size_gb}"
    delete_on_termination = true
    volume_type           = "gp3"
    device_name           = "/dev/xvda"
  }

  source_ami_filter {
    filters = {
      name                = "${var.source_ami_name}""
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  ssh_username = "ec2-user"
  ssh_timeout  = "5m"

  tags = {
    Name                      = "${var.ami_prefix}-${var.ami_version}-${local.timestamp}"
    Source_AMI_Creation_Date  = "{{ .SourceAMICreationDate }}"
    Source_AMI                = "{{ .SourceAMI }}"
    Source_AMI_Name           = "{{ .SourceAMIName }}"
    Operating_System_Version  = "Amazon Linux v2"
  }
}

build {
  name    = "${var.ami_prefix}-${var.ami_version}-${local.timestamp}"
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

####################
##### variable #####
####################
variable "aws_region" {
  type = string
  default = ""
}
variable "aws_vpc_id" {
  type = string
  default = ""
}
variable "aws_subnet_id" {
  type = string
  default = ""
}
variable "ami_prefix" {
  type = string
  default = ""
}
variable "ami_version" {
  type = string
  default = ""
}
variable "ami_description" {
  type = string
  default = ""
}
variable "aws_instance_type" {
  type = string
  default = ""
}
variable "block_device_size_gb" {
  type = string
  default = ""
}
variable "source_ami_name" {
  type = string
  default = ""
}
