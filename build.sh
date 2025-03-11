#!/bin/bash

# Set default values
DOCKER_HUB_USERNAME="srikanth6520"
IMAGE_NAME="test"
IMAGE_TAG="latest" # Default tag

# Allow overriding with environment variables
DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME:-$DOCKER_HUB_USERNAME}"
IMAGE_NAME="${DOCKER_IMAGE:-$IMAGE_NAME}" # Use DOCKER_IMAGE if set
IMAGE_TAG="${BUILD_TAG:-$IMAGE_TAG}"     # Use BUILD_TAG if set

# Construct full image name
FULL_IMAGE_NAME="${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"

# Check if Dockerfile exists
if [ ! -f Dockerfile ]; then
  echo "Error: Dockerfile not found in current directory."
  exit 1
fi

# Build the Docker image
docker build -t "${FULL_IMAGE_NAME}" .

# Check build status
if [ $? -ne 0 ]; then
  echo "Error: Docker image build failed."
  exit 1
fi

echo "Docker image built successfully: ${FULL_IMAGE_NAME}"

# Optional: Print the image ID
# docker images -q "${FULL_IMAGE_NAME}"
