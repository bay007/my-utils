# basic-secure-traffic-docker


What the Script Does
Generates a self-signed SSL certificate and stores it in a certs directory.
Creates an Nginx configuration file to serve static content over HTTPS.
Builds a Docker image using the generated configuration and certificates.
Runs a Docker container with the image, mapping port 443 for HTTPS access.
Cleans up temporary files like the Dockerfile and Nginx configuration.
