yum install golang -y
useradd roboshop
mkdir /app
cd /app
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
unzip /tmp/dispatch.zip
go mod init dispatch
go get
go build
cp dispatch.service /etc/systemd/system/dispatch.service
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch