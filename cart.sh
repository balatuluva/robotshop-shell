script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>> Download Nodejs <<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>> Install Nodejs <<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>> Add roboshop user <<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>> Create app directory <<<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>>> Download cart content <<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m>>>>>> Unzip cart content <<<<<<\e[0m"
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>> Install dependencies <<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>> Copy cart service <<<<<<\e[0m"
cp ${script_path}/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>> Start cart service <<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
