#!/bin/bash

# Unified Deployment Script - Egyptian HCX Ecosystem
# This script builds, pushes, and deploys the complete HCX ecosystem

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Environment (dev, staging, prod)
ENV=${1:-dev}

# Deployment Mode (docker-compose, kubernetes)
MODE=${2:-docker-compose}

echo -e "${GREEN}🚀 Starting Egyptian HCX Ecosystem Deployment${NC}"
echo -e "${YELLOW}Environment: $ENV${NC}"
echo -e "${YELLOW}Mode: $MODE${NC}"

# ====================================================================
# Build HCX Platform Docker Images
# ====================================================================

echo -e "${GREEN}📦 Building HCX Platform Docker images...${NC}"
if [ -d "../hcx-platform" ]; then
    cd ../hcx-platform
    echo -e "${YELLOW}Building HCX Platform services...${NC}"
    docker-compose build
    cd -
else
    echo -e "${RED}❌ HCX Platform repository not found at ../hcx-platform${NC}"
    echo -e "${YELLOW}Please ensure the hcx-platform repository is cloned in the parent directory${NC}"
    exit 1
fi

# ====================================================================
# Build Egyptian KYC Registry Docker Images
# ====================================================================

echo -e "${GREEN}📦 Building Egyptian KYC Registry Docker images...${NC}"
if [ -d "../egyptian-healthcare-kyc-registry" ]; then
    cd ../egyptian-healthcare-kyc-registry
    echo -e "${YELLOW}Building Egyptian KYC Registry services...${NC}"
    docker-compose build
    cd -
else
    echo -e "${RED}❌ Egyptian Healthcare KYC Registry repository not found at ../egyptian-healthcare-kyc-registry${NC}"
    echo -e "${YELLOW}Please ensure the egyptian-healthcare-kyc-registry repository is cloned in the parent directory${NC}"
    exit 1
fi

# ====================================================================
# Push Docker Images (only for production)
# ====================================================================

if [ "$ENV" == "prod" ]; then
    echo -e "${GREEN}🚢 Pushing Docker images to registry...${NC}"
    
    # Push HCX Platform images
    cd ../hcx-platform
    docker-compose push
    cd -
    
    # Push Egyptian KYC Registry images
    cd ../egyptian-healthcare-kyc-registry
    docker-compose push
    cd -
fi

# ====================================================================
# Deploy to Target Environment
# ====================================================================

echo -e "${GREEN}🚀 Deploying to $ENV environment using $MODE...${NC}"

if [ "$MODE" == "docker-compose" ]; then
    echo -e "${YELLOW}Deploying with Docker Compose...${NC}"
    if [ "$ENV" == "prod" ]; then
        docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
    else
        docker-compose up -d
    fi
    
    echo -e "${GREEN}✅ Deployment complete!${NC}"
    echo -e "${YELLOW}Services are starting up. You can check status with:${NC}"
    echo -e "${YELLOW}docker-compose ps${NC}"
    echo ""
    echo -e "${GREEN}🌐 Access URLs:${NC}"
    echo -e "${YELLOW}HCX API Gateway: http://localhost:8090${NC}"
    echo -e "${YELLOW}HCX APIs: http://localhost:8080${NC}"
    echo -e "${YELLOW}Egyptian HCX Integration: http://localhost:8081${NC}"
    echo -e "${YELLOW}Egyptian KYC Service: http://localhost:8082${NC}"
    
elif [ "$MODE" == "kubernetes" ]; then
    echo -e "${YELLOW}Deploying with Kubernetes...${NC}"
    
    # Check if kubectl is available
    if ! command -v kubectl &> /dev/null; then
        echo -e "${RED}❌ kubectl is not installed or not in PATH${NC}"
        exit 1
    fi
    
    # Apply Kubernetes manifests
    echo -e "${YELLOW}Applying HCX Platform manifests...${NC}"
    kubectl apply -f kubernetes/hcx-platform/
    
    echo -e "${YELLOW}Applying Egyptian KYC Registry manifests...${NC}"
    kubectl apply -f kubernetes/kyc-registry/
    
    echo -e "${GREEN}✅ Kubernetes deployment complete!${NC}"
    echo -e "${YELLOW}You can check status with:${NC}"
    echo -e "${YELLOW}kubectl get pods${NC}"
    echo -e "${YELLOW}kubectl get services${NC}"
    
else
    echo -e "${RED}❌ Invalid deployment mode. Use 'docker-compose' or 'kubernetes'.${NC}"
    exit 1
fi

# ====================================================================
# Health Check
# ====================================================================

echo -e "${GREEN}🏥 Performing health checks...${NC}"

if [ "$MODE" == "docker-compose" ]; then
    echo -e "${YELLOW}Waiting for services to start...${NC}"
    sleep 30
    
    # Check HCX API Gateway
    if curl -f http://localhost:8090/actuator/health &> /dev/null; then
        echo -e "${GREEN}✅ HCX API Gateway is healthy${NC}"
    else
        echo -e "${RED}❌ HCX API Gateway health check failed${NC}"
    fi
    
    # Check HCX APIs
    if curl -f http://localhost:8080/actuator/health &> /dev/null; then
        echo -e "${GREEN}✅ HCX APIs are healthy${NC}"
    else
        echo -e "${RED}❌ HCX APIs health check failed${NC}"
    fi
    
    # Check Egyptian HCX Integration
    if curl -f http://localhost:8081/actuator/health &> /dev/null; then
        echo -e "${GREEN}✅ Egyptian HCX Integration is healthy${NC}"
    else
        echo -e "${RED}❌ Egyptian HCX Integration health check failed${NC}"
    fi
fi

echo -e "${GREEN}🎉 Egyptian HCX Ecosystem deployment completed successfully!${NC}"


