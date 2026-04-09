#!/bin/bash
set -e

# Pull the latest image
# Note: Ensure your Docker Hub username is hardcoded here or fetched from SSM 
# because CodeBuild environment variables don't persist to the EC2 instance.
DOCKER_IMAGE="nahidkishore/simple-python-flask-app:latest"

docker pull "$DOCKER_IMAGE"

# Run the container
docker run -d -p 80:5000 --name flask-app "$DOCKER_IMAGE"