#!/bin/bash
set -e

# Stop and remove the container if it exists
if [ "$(docker ps -aq -f name=flask-app)" ]; then
    echo "Stopping and removing existing container: flask-app"
    docker rm -f flask-app
else
    echo "No container named flask-app found."
fi