#/bin/bash

ip_web_server="192.168.x.x"
domain_name="huybadpi.site"
path_ssl_certificate="~/Download/huybadpi.site_ssl_certificate.cer"
path_intermediate1="~/Download/intermediate1.cer"
path_intermediate2="~/Download/intermediate2.cer"
path_key="~/Download/_.huybadpi.site_private_key.key"

sudo apt update && sudo apt upgrade -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

sudo mv $path_ssl_certificate /etc/ssl/certs/
sudo mv $path_intermediate1 /etc/ssl/certs/
sudo mv $path_intermediate2 /etc/ssl/certs/
sudo mv $path_key /etc/ssl/private/

sudo cat /etc/ssl/certs/huybadpi.site_ssl_certificate.cer /etc/ssl/certs/intermediate1.cer /etc/ssl/certs/intermediate2.cer > /etc/ssl/certs/huybadpi.site_fullchain.cer
sudo chown root:root /etc/ssl/private/_.huybadpi.site_private_key.key
sudo chmod 600 /etc/ssl/private/_.huybadpi.site_private_key.key
sudo chown root:root /etc/ssl/certs/huybadpi.site_fullchain.cer
sudo chmod 644 /etc/ssl/certs/huybadpi.site_fullchain.cer

sudo tee /etc/nginx/sites-available/$domain_name <<EOF
server {
    listen 80;
    server_name $domain_name;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name $domain_name;

    ssl_certificate     /etc/ssl/certs/huybadpi.site_fullchain.cer;
    ssl_certificate_key /etc/ssl/private/_.huybadpi.site_private_key.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://$ip_web_server;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/
sudo nginx -t
if [ $? -eq 0 ]; then
    sudo systemctl restart nginx
    echo "Nginx configuration is valid and has been restarted."
else
    echo "Nginx configuration is invalid. Please check the configuration file."
    exit 1
fi


