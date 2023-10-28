script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input rabbitmq appuser password Missing
  exit
fi

echo -e "\e[36m>>>>>> Intsall python repos <<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>> Add roboshop user <<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>> Add app directory <<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>> Download payment content <<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app

echo -e "\e[36m>>>>>> Unzip payment content <<<<<<\e[0m"
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>> Install dependencies <<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>> Copy payment service files <<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>> Restart payment service <<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment