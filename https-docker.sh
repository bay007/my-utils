#!/bin/bash

# Variables for file paths and container details
CERT_DIR="./certs"
NGINX_CONF="./nginx.conf"
IMAGE_NAME="basic-https-server"
CONTAINER_NAME="https-server"
PORT=443

# Step 1: Create directories and generate a self-signed SSL certificate for 10 years
mkdir -p $CERT_DIR
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout $CERT_DIR/server.key -out $CERT_DIR/server.crt \
  -subj "/CN=localhost"

# Step 2: Create an Nginx configuration file
cat > $NGINX_CONF <<EOL
events {}

http {
    server {
        listen 443 ssl;
        server_name localhost;

        ssl_certificate     /etc/nginx/certs/server.crt;
        ssl_certificate_key /etc/nginx/certs/server.key;

        location / {
            root   /usr/share/nginx/html;
            index  index.html;
        }
    }
}
EOL

# Step 3: Create a Dockerfile
cat > Dockerfile <<EOL
FROM nginx:alpine

COPY certs/server.crt /etc/nginx/certs/server.crt
COPY certs/server.key /etc/nginx/certs/server.key
COPY nginx.conf /etc/nginx/nginx.conf
EOL

# Step 4: Build the Docker image
echo "Building Docker image..."
docker build -t $IMAGE_NAME .

# Step 5: Run the Docker container
echo "Running Docker container..."
docker run -d --name $CONTAINER_NAME -p $PORT:443 $IMAGE_NAME

# Cleanup temporary files
echo "Cleaning up..."
rm -f Dockerfile $NGINX_CONF

# Display success message
echo "HTTPS server is running at https://localhost:$PORT"
