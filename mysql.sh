script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input Mysql Root Password Missing
  exit
fi

func_print_head "Disable default Mysql version"
dnf module disable mysql -y &>>$log_file
func_status_check $?

func_print_head "Load Schema"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status_check $?

func_print_head "Install Mysql"
yum install mysql-community-server -y &>>$log_file
func_status_check $?

func_print_head "start mysql"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_status_check $?

func_print_head "Set Mysql password"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
func_status_check $?