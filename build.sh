#!/bin/bash

# Set default values
IMAGE_NAME="test"
IMAGE_TAG="latest" # Default tag

# Allow overriding with environment variables
IMAGE_NAME="${DOCKER_IMAGE:-$IMAGE_NAME}" # Use DOCKER_IMAGE if set
IMAGE_TAG="${BUILD_TAG:-$IMAGE_TAG}"     # Use BUILD_TAG if set

# Check if Dockerfile exists
if [ ! -f Dockerfile ]; then
  echo "Error: Dockerfile not found in current directory."
  exit 1
fi

# Build the Docker image
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

# Check build status
if [ $? -ne 0 ]; then
  echo "Error: Docker image build failed."
  exit 1
fi

echo "Docker image built successfully: ${IMAGE_NAME}:${IMAGE_TAG}"

# Optional: Print the image ID
# docker images -q "${IMAGE_NAME}:${IMAGE_TAG}"
