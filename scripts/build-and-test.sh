#!/bin/bash

# Script ni untuk build dan test Docker image locally
# Shebang #!/bin/bash tell system untuk run script ni guna bash shell

set -e  # Exit immediately if any command fails
# Explanation: set -e ni safety net. Kalau mana-mana command error, script terus stop.
# Without this, script akan continue walaupun ada error, boleh cause unexpected issues.

# Color codes untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Docker build and test...${NC}"

# Variables
IMAGE_NAME="devops-lab1"
CONTAINER_NAME="devops-lab1-test"
PORT=8080

# Step 1: Build Docker image
echo -e "${YELLOW}Building Docker image...${NC}"
docker build -t $IMAGE_NAME:latest .
# Explanation:
# docker build - command untuk build image dari Dockerfile
# -t $IMAGE_NAME:latest - tag image dengan nama dan version (latest)
# . - build context (current directory)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Docker image built successfully${NC}"
else
    echo -e "${RED}✗ Docker build failed${NC}"
    exit 1
fi
# Explanation: $? ni special variable yang hold exit status of last command
# 0 = success, non-zero = error

# Step 2: Stop and remove existing container if running
echo -e "${YELLOW}Cleaning up existing containers...${NC}"
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true
# Explanation: 
# 2>/dev/null - redirect error messages ke /dev/null (ignore errors)
# || true - ensure command always return success, even if container doesn't exist

# Step 3: Run container
echo -e "${YELLOW}Starting container...${NC}"
docker run -d \
  --name $CONTAINER_NAME \
  -p $PORT:80 \
  $IMAGE_NAME:latest
# Explanation:
# -d - detached mode (run in background)
# --name - assign nama to container
# -p 8080:80 - map port 8080 on host to port 80 in container
#   Format: HOST_PORT:CONTAINER_PORT

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Container started successfully${NC}"
else
    echo -e "${RED}✗ Failed to start container${NC}"
    exit 1
fi

# Step 4: Wait for container to be ready
echo -e "${YELLOW}Waiting for application to be ready...${NC}"
sleep 3
# Explanation: Give Nginx time to start. In production, better guna health check loop.

# Step 5: Test if application is accessible
echo -e "${YELLOW}Testing application...${NC}"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT)
# Explanation:
# curl - tool untuk make HTTP requests
# -s - silent mode (no progress bar)
# -o /dev/null - discard response body
# -w "%{http_code}" - output only HTTP status code

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo -e "${GREEN}✓ Application is responding correctly (HTTP $HTTP_STATUS)${NC}"
    echo -e "${GREEN}✓ Access application at: http://localhost:$PORT${NC}"
else
    echo -e "${RED}✗ Application test failed (HTTP $HTTP_STATUS)${NC}"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Step 6: Show container info
echo -e "${YELLOW}Container Details:${NC}"
docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Build and test completed successfully!${NC}"
echo -e "${GREEN}================================${NC}"