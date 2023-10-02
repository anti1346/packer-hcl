#!/bin/bash

# Determine the Linux distribution
os_distribution=$(grep -oP '(?<=^PRETTY_NAME=")(.*)(?=")' /etc/os-release)

case "$os_distribution" in
  "Amazon Linux 2")
    package_manager="yum"
    ;;
  "CentOS Linux"*)
    package_manager="yum"
    ;;
  "Ubuntu"*)
    package_manager="apt"
    ;;
  *)
    echo "Unsupported operating system distribution"
    exit 1
    ;;
esac

# Install the CloudWatch Agent
if [ "$package_manager" = "yum" ]; then
  rpm -Uvh https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
elif [ "$package_manager" = "apt" ]; then
  wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
  dpkg -i amazon-cloudwatch-agent.deb
fi

# Configure the CloudWatch Agent
cat <<EOF | tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "YourLogGroupName",
            "log_stream_name": "{instance_id}/messages",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/secure",
            "log_group_name": "YourLogGroupName",
            "log_stream_name": "{instance_id}/secure",
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
EOF

# Start and enable the CloudWatch Agent service
if [ "$package_manager" = "yum" ]; then
  systemctl start amazon-cloudwatch-agent
  systemctl enable amazon-cloudwatch-agent
elif [ "$package_manager" = "apt" ]; then
  /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
  systemctl start amazon-cloudwatch-agent
  systemctl enable amazon-cloudwatch-agent
fi
