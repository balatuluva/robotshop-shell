cd /etc/yum.repos.d/
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
yum install redis -y

## Update listen address from 127.0.0.1 to 0.0.0.0 in **`vim /etc/redis.conf`**
##  & **`vim /etc/redis/redis.conf`**

systemctl enable redis
systemctl start redis