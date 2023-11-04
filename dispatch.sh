script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Install golang repos"
yum install golang -y &>>$log_file
func_status_check $?

func_app_prereq

func_print_head "Install app dependencies"
go mod init dispatch &>>$log_file
go get &>>$log_file
go build &>>$log_file
func_status_check $?

func_systemd_setup