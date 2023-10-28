app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head () {
  echo -e "\e[36m>>>>>> $1 <<<<<<\e[0m"
}

schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    print_head "Copy Mongodb repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    print_head "Install Mongodb Client"
    yum install mongodb-org-shell -y

    print_head "Load Schema"
    mongo --host mongodb-dev.gehana26.online </app/schema/{component}.js
  fi
}

func_nodejs() {
  print_head "Download Nodejs"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "Install Nodejs"
  yum install nodejs -y

  print_head "Add roboshop user"
  useradd ${app_user}

  print_head "Create app directory"
  mkdir /app

  print_head "Download cart content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head "Unzip cart content"
  unzip /tmp/${component}.zip

  print_head "Install dependencies"
  npm install

  print_head "Create App Directory"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head "Start cart service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  print_head "Schema setup function"
  schema_setup
}