script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Install redis repos"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

func_print_head "Install redis"
dnf module enable redis:remi-6.2 -y
yum install redis -y

func_print_head "Update redis listen address"
sed -i -e 's|127.0.0.0|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

func_print_head "Start redis service"
systemctl enable redis
systemctl restart redis