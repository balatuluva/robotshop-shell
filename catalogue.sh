source common.sh

echo -e "\e[36m>>>>>> Configure Nodejs repos <<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>> Install Nodejs <<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>> Add Application user <<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>> Create Application Directory <<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>> Download App Content <<<<<<\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>>> Unzip App Content <<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>> Install Nodejs Dependencies <<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>> Copy Catalogue SystemD file <<<<<<\e[0m"
cp /home/centos/robotshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>> Start Catalogue Service <<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>> Copy Mongodb repo <<<<<<\e[0m"
cp /home/centos/robotshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>> Install Mongodb Client <<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>> Load Schema <<<<<<\e[0m"
mongo --host mongodb-dev.gehana26.online </app/schema/catalogue.js