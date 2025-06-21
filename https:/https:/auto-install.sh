#!/bin/bash

# Update package list
apt update

# Install NGINX and OpenSSL
apt install -y nginx openssl

# Create mikrotik.conf file
touch /etc/nginx/mikrotik.conf

# Generate SSL certificates
openssl req -x509 -newkey rsa:2048 -nodes -keyout /etc/nginx/ssl.key -out /etc/nginx/ssl.crt -days 365 -subj "/C=US/ST=State/L=Locality/O=Organization/CN=example.com"

# Create .htpasswd file for basic authentication
htpasswd -c /etc/nginx/.htpasswd mikrotik

# Download the MikroTik NGINX Proxy Manager script
wget https://raw.githubusercontent.com/mmkash-web/vpnmikrotik/master/mikrotik-nginx-proxy-manager.sh -O /usr/local/bin/mikrotik-nginx-proxy-manager.sh

# Make the script executable
chmod +x /usr/local/bin/mikrotik-nginx-proxy-manager.sh

# Run the MikroTik NGINX Proxy Manager script
/usr/local/bin/mikrotik-nginx-proxy-manager.sh
