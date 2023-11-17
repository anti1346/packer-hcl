#!/bin/bash
# Script: create_instance.sh
# Author: YourName
# Description: Script to create an EC2 instance with default or user-specified parameters.

# Usage: ./create_instance.sh [AMI_ID] [INSTANCE_NAME] [INSTANCE_COUNT] [INSTANCE_TYPE] [KEY_NAME]

# Default values
ami_id=${1:-ami-031a4f8b9745c3f3c}
instance_name=${2:-kraaa-test-web}
instance_count=${3:-1}
instance_type=${4:-t3a.medium}
key_name=${5:-keyfile}

aws --region ap-northeast-2 ec2 run-instances \
    --image-id "$ami_id" \
    --instance-type "$instance_type" \
    --key-name "$key_name" \
    --subnet-id subnet-02e \
    --security-group-ids sg-0245 sg-00c4 \
    --count "$instance_count" \
    --associate-public-ip-address \
    --monitoring '{"Enabled":true}' \
    --credit-specification CpuCredits=unlimited \
    --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":20,"DeleteOnTermination":true,"VolumeType":"gp3"}}]' \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='"$instance_name-$instance_count"'}]' \
    --iam-instance-profile "Name=EC2RoleforSSM" \
    --user-data file://user-data/user_data_script.sh
