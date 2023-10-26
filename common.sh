app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_nodejs() {
  echo -e "\e[36m>>>>>> Download Nodejs <<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[36m>>>>>> Install Nodejs <<<<<<\e[0m"
  yum install nodejs -y

  echo -e "\e[36m>>>>>> Add roboshop user <<<<<<\e[0m"
  useradd ${app_user}

  echo -e "\e[36m>>>>>> Create app directory <<<<<<\e[0m"
  mkdir /app

  echo -e "\e[36m>>>>>> Download cart content <<<<<<\e[0m"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  echo -e "\e[36m>>>>>> Unzip cart content <<<<<<\e[0m"
  unzip /tmp/${component}.zip

  echo -e "\e[36m>>>>>> Install dependencies <<<<<<\e[0m"
  npm install

  echo -e "\e[36m>>>>>> Copy cart service <<<<<<\e[0m"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[36m>>>>>> Start cart service <<<<<<\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}