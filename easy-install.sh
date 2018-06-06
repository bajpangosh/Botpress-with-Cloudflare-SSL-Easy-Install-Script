#!/bin/bash
# GET ALL USER INPUT
echo "Domain Name (eg. example.com)?"
read DOMAIN

echo "Botname(eg. lovebot)?"
read BOTNAME

echo "Updating OS................."
sleep 2;
sudo apt-get update

echo "Installing Nginx................."
sleep 2;
sudo apt-get install nginx -y

echo 'Wellcome to Botpress easy install script';
sleep 2;
cd ~
echo 'installing python-software-properties';
sleep 2;
sudo apt-get install -y build-essential git python-software-properties

echo 'installing Node Js';
sleep 2;

sudo curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash  -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

echo 'installing Botpress';
sleep 2;
npm install -g botpress --unsafe-perm
npm install -g pm2@latest --no-optional --no-shrinkwrap

echo "Setting up Cloudflare FULL SSL"
sleep 2;
sudo mkdir /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
cd /etc/nginx/
sudo mv nginx.conf nginx.conf.backup
wget -O nginx.conf https://goo.gl/n8crcR
sudo mkdir /var/www/botpress
echo "Sit back and relax :) ......"
sleep 2;
cd /etc/nginx/sites-available/
wget -O "$DOMAIN" https://goo.gl/wLzhbv
sed -i -e "s/example.com/$DOMAIN/" "$DOMAIN"
sudo ln -s /etc/nginx/sites-available/"$DOMAIN" /etc/nginx/sites-enabled/
sudo systemctl restart nginx.service
cd /var/www/botpress
botpress init "$BOTNAME"
pm2 start npm -- start
