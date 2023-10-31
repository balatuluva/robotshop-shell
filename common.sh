app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[36m>>>>>> $1 <<<<<<\e[0m"
}

func_status_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi
}

func_app_prereq() {
  func_print_head "Add App user"
  useradd ${app_user}
  func_status_check $?

  func_print_head "Create app directory"
  rm -rf /app
  mkdir /app
  func_status_check $?

  func_print_head "Download App content"
  curl -L -o /tmp/{component}.zip https://roboshop-artifacts.s3.amazonaws.com/{component}.zip
  cd /app
  func_status_check $?

  func_print_head "Unzip App content"
  unzip /tmp/{component}.zip
  func_status_check $?
}

func_systemd_setup() {
  func_print_head "copy {component} service"
  cp ${script_path}/{component}.service /etc/systemd/system/{component}.service
  func_status_check $?

  func_print_head "Start {component} service"
  systemctl daemon-reload
  systemctl enable {component}
  systemctl start {component}
  func_status_check $?
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "Copy Mongodb repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
    func_status_check $?

    func_print_head "Install Mongodb Client"
    yum install mongodb-org-shell -y
    func_status_check $?

    func_print_head "Load Schema"
    mongo --host mongodb-dev.gehana26.online </app/schema/{component}.js
    func_status_check $?
  fi
  if [ "$schema_setup" == "mysql" ]; then
    func_print_head "Install Mysql"
    yum install mysql -y
    func_status_check $?

    func_print_head "Load Schema"
    mysql -h mysql-dev.gehana26.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
    func_status_check $?
  fi
}

func_nodejs() {
  func_print_head "Download Nodejs"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  func_status_check $?

  func_print_head "Install Nodejs"
  yum install nodejs -y
  func_status_check $?

  func_app_prereq

  func_print_head "Install dependencies"
  npm install
  func_status_check $?

  func_schema_setup

  func_systemd_setup
}

func_java() {
  func_print_head "Install maven"
  yum install maven -y
  func_status_check $?

  func_app_prereq

  func_print_head "Download {component} service"
  mvn clean package
  func_status_check $?
  mv target/{component}-1.0.jar {component}.jar

  func_schema_setup

  func_systemd_setup
}