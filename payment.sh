script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input rabbitmq appuser password Missing
  exit
fi

func_print_head "Install python repos"
yum install python36 gcc python3-devel -y

func_print_head "Add roboshop user"
useradd ${app_user}

func_print_head "Add app directory"
rm -rf /app
mkdir /app

func_print_head "Download payment content"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app

func_print_head "Unzip payment content"
unzip /tmp/payment.zip

func_print_head "Install dependencies"
pip3.6 install -r requirements.txt

func_print_head "Copy payment service files"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

func_print_head "Restart payment service"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment