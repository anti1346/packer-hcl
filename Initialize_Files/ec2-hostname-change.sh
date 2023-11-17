#!/bin/bash

IID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
IREGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`

IHOSTNAME=`aws --region ${IREGION} ec2 describe-instances \
	--instance-ids ${IID} \
	--query "Reservations[].Instances[].Tags[?Key=='Name'].Value[]" \
	--output text`

sudo hostnamectl set-hostname ${IHOSTNAME}
