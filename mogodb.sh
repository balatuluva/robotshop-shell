cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -yum

systemctl enable mongod
systemctl start mongod