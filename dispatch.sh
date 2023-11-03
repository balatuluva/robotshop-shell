script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Install golang repos"
yum install golang -y &>>$log_file
func_status_check $?

func_print_head "Add roboshop user"
useradd roboshop &>>$log_file
func_status_check $?

func_print_head "Create App directory"
rm -rf /app &>>$log_file
mkdir /app &>>$log_file
func_status_check $?

func_print_head "Download dispatch content"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>$log_file
cd /app
func_status_check $?

func_print_head "Unzip dispatch content"
unzip /tmp/dispatch.zip &>>$log_file
func_status_check $?

func_print_head "Install app dependencies"
go mod init dispatch &>>$log_file
go get &>>$log_file
go build &>>$log_file
func_status_check $?

func_print_head "Copy dispatch service files"
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service &>>$log_file
func_status_check $?

func_print_head "Restart dispatch service"
systemctl daemon-reload &>>$log_file
systemctl enable dispatch &>>$log_file
systemctl restart dispatch &>>$log_file
func_status_check $?