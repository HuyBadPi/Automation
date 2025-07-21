#!/bin/bash

ip_zabbix_server="192.168.1.36"
username="huyzabbix"
password="huyzabbix"
name_of_database="zabbix"

echo "Enter MySQL root password:"
sudo mysql -u root -p <<EOF
CREATE DATABASE ${name_of_database} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER '${username}'@'localhost' IDENTIFIED BY '${password}';
CREATE USER '${username}'@'${ip_zabbix_server}' IDENTIFIED BY '${password}';
GRANT ALL PRIVILEGES ON ${name_of_database}.* TO '${username}'@'localhost';
GRANT ALL PRIVILEGES ON ${name_of_database}.* TO '${username}'@'${ip_zabbix_server}';
FLUSH PRIVILEGES;
QUIT;
EOF

echo "Database and user have been created and granted permissions."
