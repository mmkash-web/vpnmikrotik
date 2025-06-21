#!/bin/bash

# Define the menu options
OPTIONS=("Add MikroTik Router" "Remove MikroTik Router" "List MikroTik Routers" "Configure NGINX" "Start NGINX" "Stop NGINX" "Restart NGINX" "Quit")

# The developer's name
DEVELOPER="Emmkash"

# Function to add a MikroTik router
add_router() {
  echo "Enter the IP address of the MikroTik router:"
  read ip
  echo "Enter the port number of the MikroTik router (default: 8728):"
  read port
  if [ -z "$port" ]; then
    port=8728
  fi
  echo "server $ip:$port;" >> /etc/nginx/mikrotik.conf
  echo "MikroTik router added successfully!"
}

# Function to remove a MikroTik router
remove_router() {
  echo "Enter the IP address of the MikroTik router to remove:"
  read ip
  sed -i "/$ip/d" /etc/nginx/mikrotik.conf
  echo "MikroTik router removed successfully!"
}

# Function to list MikroTik routers
list_routers() {
  cat /etc/nginx/mikrotik.conf
}

# Function to configure NGINX
configure_nginx() {
  echo "Configuring NGINX..."
  sudo tee /etc/nginx/nginx.conf <<EOF
http {
    upstream mikrotik {
        $(cat /etc/nginx/mikrotik.conf)
    }

    server {
        listen 443 ssl;
        ssl_certificate /etc/nginx/ssl.crt;
        ssl_certificate_key /etc/nginx/ssl.key;

        location /api {
            proxy_pass http://mikrotik;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";

            # Basic authentication
            auth_basic "Restricted";
            auth_basic_user_file /etc/nginx/.htpasswd;
        }
    }
}
EOF
  echo "NGINX configured successfully!"
}

# Function to start NGINX
start_nginx() {
  sudo systemctl start nginx
  echo "NGINX started successfully!"
}

# Function to stop NGINX
stop_nginx() {
  sudo systemctl stop nginx
  echo "NGINX stopped successfully!"
}

# Function to restart NGINX
restart_nginx() {
  sudo systemctl restart nginx
  echo "NGINX restarted successfully!"
}

# Main menu loop
while true; do
  echo "MikroTik NGINX Proxy Manager"
  echo "-------------------------------"
  echo "Developed by $DEVELOPER"
  echo "-------------------------------"
  for i in "${!OPTIONS[@]}"; do
    echo "$((i+1)). ${OPTIONS[$i]}"
  done
  echo "Enter your choice:"
  read choice
  case $choice in
    1) add_router ;;
    2) remove_router ;;
    3) list_routers ;;
    4) configure_nginx ;;
    5) start_nginx ;;
    6) stop_nginx ;;
    7) restart_nginx ;;
    8) exit ;;
    *) echo "Invalid choice. Please try again." ;;
  esac
done
