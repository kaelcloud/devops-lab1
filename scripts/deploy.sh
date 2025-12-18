#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Starting deployment...${NC}"

IMAGE_NAME="devops-lab1"
CONTAINER_NAME="devops-lab1-app"
DOCKER_REGISTRY="ghcr.io"
GITHUB_USERNAME="${1}"

if [ -z "$GITHUB_USERNAME" ]; then
    echo -e "${RED}Error: GitHub username not provided${NC}"
    exit 1
fi

FULL_IMAGE_NAME="$DOCKER_REGISTRY/$GITHUB_USERNAME/$IMAGE_NAME:latest"

echo -e "${YELLOW}Pulling latest image: $FULL_IMAGE_NAME${NC}"

echo $GITHUB_TOKEN | docker login $DOCKER_REGISTRY -u $GITHUB_USERNAME --password-stdin

docker pull $FULL_IMAGE_NAME

echo -e "${YELLOW}Stopping old container...${NC}"
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

docker image prune -f

echo -e "${YELLOW}Starting new container...${NC}"
docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  -p 80:80 \
  $FULL_IMAGE_NAME

echo -e "${YELLOW}Performing health check...${NC}"
sleep 5

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo -e "${GREEN}✓ Deployment successful! Application is running.${NC}"
else
    echo -e "${RED}✗ Deployment failed! HTTP Status: $HTTP_STATUS${NC}"
    docker logs $CONTAINER_NAME
    exit 1
fi

echo -e "${GREEN}Deployment completed successfully!${NC}"