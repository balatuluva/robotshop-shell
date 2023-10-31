script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input rabbitmq appuser password Missing
  exit
fi

func_print_head "Download erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

func_print_head "Download Rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

func_print_head "Install Rabbitmq & erlang"
yum install rabbitmq-server erlang -y

func_print_head "Start rabbitmq service"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

func_print_head "Add roboshop user"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"