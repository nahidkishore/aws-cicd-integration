#!/bin/bash
set -e

# Stop and remove the container if it exists
docker rm -f flask-app || true