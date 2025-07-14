#!/bin/bash

SPLUNK_SERVER_IP="192.168.1.31"
SPLUNK_SERVER_PORT="9997"
NAME_MACHINE=$(cat /etc/hostname)
username="admin"
password="hhhuuuyyy"

# update and upgrade the system
sudo apt update -y && sudo apt upgrade -y

# create ~/Downloads directory if it doesn't exist
mkdir -p ~/Downloads

# install forwarder
wget -O ~/Downloads/splunkforwarder-9.4.3-237ebbd22314-linux-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/9.4.3/linux/splunkforwarder-9.4.3-237ebbd22314-linux-amd64.deb"

chmod +x ~/Downloads/splunkforwarder-9.4.3-237ebbd22314-linux-amd64.deb

sudo dpkg -i ~/Downloads/splunkforwarder-9.4.3-237ebbd22314-linux-amd64.deb

# initial startup
sudo /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes

chown -R splunkfwd:splunkfwd /opt/splunkforwarder

# start
sudo /opt/splunkforwarder/bin/splunk start

# add logs to monitor
sudo tee /opt/splunkforwarder/etc/system/local/inputs.conf > /dev/null << EOF
# Add the following lines to monitor various log files
[monitor:///var/log/syslog]
disabled = false
index = $NAME_MACHINE
sourcetype = syslog

[monitor:///var/log/auth.log]
disabled = false
index = $NAME_MACHINE
sourcetype = auth

[monitor:///var/log/kern.log]
disabled = false
index = $NAME_MACHINE
sourcetype = kern

[monitor:///var/log/dmesg]
disabled = false
index = $NAME_MACHINE
sourcetype = dmesg

[monitor:///var/log/dpkg.log]
disabled = false
index = $NAME_MACHINE
sourcetype = dpkg

[monitor:///var/log/boot.log]
disabled = false
index = $NAME_MACHINE
sourcetype = boot

[monitor:///var/log/apache2/access.log]
disabled = false
index = $NAME_MACHINE
sourcetype = access_combined

[monitor:///var/log/apache2/error.log]
disabled = false
index = $NAME_MACHINE
sourcetype = error_combined

[monitor:///var/log/nginx/access.log]
disabled = false
index = $NAME_MACHINE
sourcetype = access_combined

[monitor:///var/log/nginx/error.log]
disabled = false
index = $NAME_MACHINE
sourcetype = error_combined

[monitor:///var/log/btmp]
disabled = false
index = $NAME_MACHINE
sourcetype = btmp

[monitor:///var/log/wtmp]
disabled = false
index = $NAME_MACHINE
sourcetype = wtmp

[monitor:///var/log/mysql/error.log]
disabled = false
index = $NAME_MACHINE
sourcetype = mysql_error

[monitor:///var/log/mysql/mysql.log]
disabled = false
index = $NAME_MACHINE
sourcetype = mysql_log

[monitor:///var/log/apt/history.log]
disabled = false
index = $NAME_MACHINE
sourcetype = apt_history

[monitor:///var/log/cron]
disabled = false
index = $NAME_MACHINE
sourcetype = cron

[monitor:///var/log/audit/audit.log]
disabled = false
index = $NAME_MACHINE
sourcetype = audit

[monitor:///var/log/daemons.log]
disabled = false
index = $NAME_MACHINE
sourcetype = daemons

[monitor:///var/log/mail.log]
disabled = false
index = $NAME_MACHINE
sourcetype = mail
EOF

# add server to forwarder
sudo /opt/splunkforwarder/bin/splunk add forward-server $SPLUNK_SERVER_IP:$SPLUNK_SERVER_PORT -auth $username:$password

# restart the forwarder to apply changes
sudo /opt/splunkforwarder/bin/splunk restart

# remove downloaded file
rm ~/Downloads/splunkforwarder-9.4.3-237ebbd22314-linux-amd64.deb

# check connection
# sudo tail -f /opt/splunkforwarder/var/log/splunk/splunkd.log

# list forwarders
# sudo /opt/splunkforwarder/bin/splunk list forward-server

