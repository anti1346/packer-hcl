#!/bin/bash

os_distribution=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
if [ "$os_distribution" == "Amazon" ]; then
    sudo yum install -y jq ruby
    sudo cd /home/ec2-user/
elif [ "$os_distribution" == "Ubuntu" ]; then
    sudo apt-get update
    sudo apt-get install -y jq wget unzip ruby
    sudo -i
    cd /home/ubuntu/
    ###rbenv install on ubuntu 22.04
    #     sudo sh """
    # git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    # echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    # echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    # exec $SHELL
    # git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
    # rbenv install 2.6.10
    # rbenv global 2.6.10
    # ln -s /root/.rbenv/shims/ruby /bin/ruby
    # """
else
    sudo echo "other operating system distribution"
fi

REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r ".region")

### Dependency is not satisfiable: ruby2.0|ruby2.1|ruby2.2|ruby2.3|ruby2.4|ruby2.5|ruby2.6|ruby2.7
sudo wget -q https://aws-codedeploy-${REGION}.s3.${REGION}.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
sudo rm -rf install
sudo systemctl --now enable codedeploy-agent
sudo systemctl restart codedeploy-agent
