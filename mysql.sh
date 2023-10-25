script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>> Disable default Mysql version <<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>> Load Schema <<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>> Install Mysql <<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>> start mysql <<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[36m>>>>>> Set Mysql password <<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1