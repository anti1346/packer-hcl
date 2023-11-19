#!/bin/bash
# Script: create_instance.sh
# Author: YourName
# Description: Script to create an EC2 instance with default or user-specified parameters.

# Usage: ./create_instance.sh [AMI_ID] [INSTANCE_NAME] [INSTANCE_COUNT] [INSTANCE_TYPE] [KEY_NAME]

# .env 파일 로드
if [ -f .env ]; then
  source .env
  echo "환경 변수가 로드되었습니다."
else
  echo ".env 파일을 찾을 수 없습니다."
  # 기본 값 설정
  ami_id=${1:-ami-0}
  instance_name=${2:-instance}
  instance_count=${3:-1}
  instance_type=${4:-t4g.medium}
  key_name=${5:-keyfile}
  subnet_id=${subnet_id:-your_subnet_id}  # your_subnet_id에 실제 서브넷 ID를 지정
  security_groups=${security_groups:-your_security_groups}  # your_security_groups에 실제 보안 그룹 ID를 지정
  #exit 1
fi

# AWS CLI를 사용하여 EC2 인스턴스 생성
aws --region ap-northeast-2 ec2 run-instances \
    --image-id "$ami_id" \
    --instance-type "$instance_type" \
    --key-name "$key_name" \
    --subnet-id "$subnet_id" \
    --security-group-ids "$security_groups" \
    --count "$instance_count" \
    --associate-public-ip-address \
    --monitoring '{"Enabled":true}' \
    --credit-specification CpuCredits=unlimited \
    --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":20,"DeleteOnTermination":true,"VolumeType":"gp3"}}]' \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value='$instance_name-$instance_count'}]" \
    --iam-instance-profile "Name=EC2RoleforSSM" \
    --user-data "file://user-data/user_data_script.sh"
