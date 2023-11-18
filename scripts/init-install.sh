#!/bin/bash

YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}SCRIPT ==> START${NC}"

### Create Account
echo -e "${YELLOW}script start ==> Create User${NC}"
Service_Account=www-data
sudo useradd ${Service_Account}
sudo echo "$Service_Account   ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
echo -e "${YELLOW}script end <== Create User${NC}"

### Timezone
echo -e "${YELLOW}script start ==> timezone${NC}"
sudo timedatectl set-timezone Asia/Seoul
echo -e "${YELLOW}script end <== timezone${NC}"

### Chrony
echo -e "${YELLOW}script start ==> amazon2 : chrony${NC}"
curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/common/set-chrony.sh | sudo bash
echo -e "${YELLOW}script end <== amazon2 : chrony${NC}"
sleep 5

### AWS CLI v2
echo -e "${YELLOW}script start ==> awscli${NC}"
curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/common/awscliv2.sh | sudo bash
echo -e "${YELLOW}script end <== awscli${NC}"
sleep 5

### Cloudwatch Agent
echo -e "${YELLOW}script start ==> cloudwatch agent${NC}"
#curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/aws/cloudwatch-agent.sh | sudo bash
curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/common/amazon-cloudwatch-agent.sh | sudo bash
echo -e "${YELLOW}script end <== cloudwatch agent${NC}"
sleep 5

### Codedeploy Agent
echo -e "${YELLOW}script start ==> codedeploy agent${NC}"
curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/aws/codedeploy-agent.sh | sudo bash
echo -e "${YELLOW}script end <== codedeploy agent${NC}"
sleep 5

### nginx 1.24
echo -e "${YELLOW}script start ==> nginx${NC}"
curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/aws/amzn2-nginx.sh | sudo bash
echo -e "${YELLOW}script end <== nginx${NC}"
sleep 5

# ### php-fpm 8.1
# echo -e "${YELLOW}script start ==> php-fpm(php)${NC}"
# curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/aws/amzn2-phpfpm.sh | sudo bash
# echo -e "${YELLOW}script end <== php-fpm(php)${NC}"

# ### WEB CONFIG(nginx, php-fpm)
# sudo chmod +x /tmp/Initialize_Files/configure-nginx-phpfpm.sh
# sudo bash /tmp/Initialize_Files/configure-nginx-phpfpm.sh

# ### composer 2.5
# echo -e "${YELLOW}script start ==> composer${NC}"
# # composer 실행 파일이 있는지 확인
# if [ -x "$(command -v composer)" ]; then
#     echo "Composer is already installed."
# else
#     # Download and install Composer
#     sudo curl -Ssf https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin/
#     sudo ln -s /usr/local/bin/composer.phar /usr/local/bin/composer
#     echo "Composer has been installed."
# fi
# echo "Composer `composer --version | awk 'NR==1{print $3}'` 설치가 완료되었습니다."
# echo -e "${YELLOW}script end <== composer${NC}"

# ### cloudwatch-agent
# echo -e "${YELLOW}script start ==> cloudwatch-agent${NC}"
# ### amazon-cloudwatch-agent.json
# sudo cp -f /tmp/Initialize_Files/amazon-cloudwatch-agent.json /root/amazon-cloudwatch-agent.json
# sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/root/amazon-cloudwatch-agent.json
# # cat /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.toml
# echo -e "${YELLOW}script end <== cloudwatch-agent${NC}"

sudo rm -rf /tmp/init-install.sh /tmp/Initialize_Files

echo -e "${YELLOW}SCRIPT <== END${NC}"
