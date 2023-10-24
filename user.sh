echo -e "\e[36m>>>>>> Download Nodejs repos <<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>> Install Nodejs <<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>> Add roboshop user <<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>> Create App Directory <<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>> Download user config repos <<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[36m>>>>>> Unzip user content <<<<<<\e[0m"
unzip /tmp/user.zip

echo -e "\e[36m>>>>>> Install app dependencies <<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>> Copy User service files <<<<<<\e[0m"
cp /home/centos/robotshop-shell/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>> Start user service <<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user

echo -e "\e[36m>>>>>> Copy mongo service files <<<<<<\e[0m"
cp /home/centos/robotshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>> Install mongo repos <<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>> Load Schema <<<<<<\e[0m"
mongo --host mongodb-dev.gehana26.online </app/schema/catalogue.js