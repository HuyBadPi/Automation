#!/bin/bash

ip_database_server="192.168.x.x"
name_of_database="zabbix"
username_of_database="xxx"
password_of_database="xxx"

sudo apt update && sudo apt upgrade -y

wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu24.04_all.deb
sudo dpkg -i zabbix-release_latest_7.4+ubuntu24.04_all.deb
sudo apt update
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent -y

echo "Type password of user '$username_of_database' to import DB:"
sudo zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -h $ip_database_server -u $username_of_database -p $name_of_database

sudo sed -i "s/^# DBHost=.*/DBHost=${ip_database_server}/" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/^DBName=.*/DBName=${name_of_database}/" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/^DBUser=.*/DBUser=${username_of_database}/" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/^# DBPassword=.*/DBPassword=${password_of_database}/" /etc/zabbix/zabbix_server.conf

sudo sed -i 's|^#        listen .*|        listen          8080;|' /etc/zabbix/nginx.conf
sudo sed -i 's|^#        server_name .*|        server_name     example.com;|' /etc/zabbix/nginx.conf

sudo systemctl enable zabbix-server zabbix-agent nginx php8.3-fpm
sudo systemctl restart zabbix-server zabbix-agent nginx php8.3-fpm

if [ $? -eq 0 ]; then
    echo "Zabbix server and agent installed and configured successfully."
    rm -f zabbix-release_latest_7.4+ubuntu24.04_all.deb
else
    echo "Failed to configure Zabbix server and agent. Please check the configuration."
    exit 1
fi


