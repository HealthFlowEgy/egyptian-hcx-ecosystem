#!/bin/bash

# Unified Deployment Script - Egyptian HCX Ecosystem

set -e

# Environment (dev, staging, prod)
ENV=${1:-dev}

# Deployment Mode (docker-compose, kubernetes)
MODE=${2:-docker-compose}

# ====================================================================
# Build Docker Images
# ====================================================================

echo "Building HCX Platform Docker images..."
cd ../hcx-platform
docker-compose build
cd -

echo "Building Egyptian KYC Registry Docker images..."
cd ../egyptian-healthcare-kyc-registry
docker-compose build
cd -

# ====================================================================
# Push Docker Images
# ====================================================================

echo "Pushing Docker images to registry..."
docker-compose push

# ====================================================================
# Deploy to Target Environment
# ====================================================================

if [ "$MODE" == "docker-compose" ]; then
  echo "Deploying with Docker Compose to $ENV environment..."
  if [ "$ENV" == "prod" ]; then
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
  else
    docker-compose up -d
  fi
elif [ "$MODE" == "kubernetes" ]; then
  echo "Deploying with Kubernetes to $ENV environment..."
  kubectl apply -f kubernetes/hcx-platform/
  kubectl apply -f kubernetes/kyc-registry/
else
  echo "Invalid deployment mode. Use 'docker-compose' or 'kubernetes'."
  exit 1
fi

echo "Deployment complete!"


