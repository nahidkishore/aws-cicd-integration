#!/bin/bash
set -e

# Pull the latest image
docker pull "$DOCKER_REGISTRY_USERNAME/simple-python-flask-app:latest"

# Run the container
docker run -d -p 80:5000 --name flask-app "$DOCKER_REGISTRY_USERNAME/simple-python-flask-app:latest"