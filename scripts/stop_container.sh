#!/bin/bash
set -e

# Stop and remove the container if it exists

# Stop and remove running container (if any)
containerid=$(docker ps -q)
if [ -n "$containerid" ]; then
  docker rm -f $containerid
  echo "Removed running container: $containerid"
else
  echo "No running containers to remove."
fi