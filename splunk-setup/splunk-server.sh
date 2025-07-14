#!/bin/bash

# update and upgrade the system
sudo apt update -y && sudo apt upgrade -y

# create ~/Downloads directory if it doesn't exist
mkdir -p ~/Downloads

# install server
wget -O ~/Downloads/splunk-9.4.3-237ebbd22314-linux-amd64.deb "https://download.splunk.com/products/splunk/releases/9.4.3/linux/splunk-9.4.3-237ebbd22314-linux-amd64.deb"

chmod +x ~/Downloads/splunk-9.4.3-237ebbd22314-linux-amd64.deb

sudo dpkg -i ~/Downloads/splunk-9.4.3-237ebbd22314-linux-amd64.deb

# initial startup
sudo /opt/splunk/bin/splunk start --accept-license --answer-yes

# if you want to start Splunk automatically at boot time
#sudo /opt/splunk/bin/splunk enable boot-start 

# check if Splunk is running
# sudo /opt/splunk/bin/splunk status

# start Splunk
# sudo /opt/splunk/bin/splunk start

# remove 
rm -rf ~/Downloads/splunk-9.4.3-237ebbd22314-linux-amd64.deb

# after installation, you access Splunk web interface
# -> setting -> indexes -> add new index
# -> setting -> receiving and forwarding -> add port receiving: 9997