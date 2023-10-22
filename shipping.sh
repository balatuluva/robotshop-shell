yum install maven -y
useradd roboshop
mkdir /app
cd /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
unzip /tmp/shipping.zip
mvn clean package
mv target/shipping-1.0.jar shipping.jar
cp shipping.service /etc/systemd/system/shipping.service
systemctl daemon-reload
yum install mysql -y
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql
systemctl enable shipping
systemctl start shipping