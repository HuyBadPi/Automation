#!/bin/bash

ip_zabbix_server="192.168.1.36"
hostname=$(hostname)

sudo apt update && sudo apt upgrade -y

wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu24.04_all.deb
sudo dpkg -i zabbix-release_latest_7.4+ubuntu24.04_all.deb
sudo apt update

sudo apt install zabbix-agent -y
sudo systemctl enable zabbix-agent
sudo systemctl start zabbix-agent

sudo sed -i "s/^Server=.*/Server=${ip_zabbix_server}/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^ServerActive=.*/ServerActive=${ip_zabbix_server}/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^Hostname=.*/Hostname=${hostname}/" /etc/zabbix/zabbix_agentd.conf

sudo systemctl restart zabbix-agent

if [ $? -eq 0 ]; then
    echo "Zabbix agent installed and configured successfully."
    rm -f zabbix-release_latest_7.4+ubuntu24.04_all.deb
else
    echo "Failed to configure Zabbix agent. Please check the configuration."
    exit 1
fi
