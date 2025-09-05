# Egyptian HCX Ecosystem - Deployment Guide

## 🚀 Overview

This guide provides comprehensive instructions for deploying the Egyptian Healthcare Claims Exchange (HCX) ecosystem across different environments, from local development to production-scale deployments.

## 📋 Prerequisites

### 1. **System Requirements**

#### Minimum Requirements (Development)
```yaml
CPU: 4 cores
RAM: 8 GB
Storage: 50 GB SSD
Network: 100 Mbps
OS: Ubuntu 20.04+ / CentOS 8+ / macOS 11+ / Windows 10+
```

#### Recommended Requirements (Production)
```yaml
CPU: 16 cores (32 vCPUs)
RAM: 64 GB
Storage: 500 GB SSD (with backup)
Network: 1 Gbps
OS: Ubuntu 22.04 LTS / RHEL 9
```

### 2. **Software Dependencies**

#### Required Software
```bash
# Docker & Docker Compose
Docker Engine: 20.10+
Docker Compose: 2.0+

# Container Orchestration (Production)
Kubernetes: 1.25+
Helm: 3.8+

# Development Tools
Git: 2.30+
Java: 17+
Maven: 3.8+
Node.js: 18+ (for demo apps)

# Database & Infrastructure
PostgreSQL: 13+
Redis: 6+
Apache Kafka: 3.0+
```

#### Installation Commands
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y docker.io docker-compose git openjdk-17-jdk maven nodejs npm

# CentOS/RHEL
sudo dnf install -y docker docker-compose git java-17-openjdk maven nodejs npm

# macOS (using Homebrew)
brew install docker docker-compose git openjdk@17 maven node

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

## 🏗️ Deployment Architectures

### 1. **Local Development Environment**

#### Architecture
```
┌─────────────────────────────────────────────────────────┐
│                 Developer Laptop                       │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              Docker Compose                     │   │
│  │                                                 │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌───────┐ │   │
│  │  │HCX APIs │ │KYC Reg. │ │Database │ │ Cache │ │   │
│  │  │  :8080  │ │  :8081  │ │  :5432  │ │ :6379 │ │   │
│  │  └─────────┘ └─────────┘ └─────────┘ └───────┘ │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

#### Deployment Steps
```bash
# 1. Clone repositories
git clone https://github.com/HealthFlowEgy/egyptian-hcx-ecosystem.git
cd egyptian-hcx-ecosystem

# Clone dependencies
cd ..
git clone https://github.com/HealthFlowEgy/hcx-platform.git
git clone https://github.com/HealthFlowEgy/egyptian-healthcare-kyc-registry.git

# 2. Configure environment
cd egyptian-hcx-ecosystem
cp .env.example .env
# Edit .env with your configuration

# 3. Deploy
./scripts/deploy.sh dev docker-compose

# 4. Verify deployment
docker-compose ps
curl http://localhost:8090/actuator/health
```

### 2. **Staging Environment**

#### Architecture
```
┌─────────────────────────────────────────────────────────┐
│                   Cloud Provider                       │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              Load Balancer                      │   │
│  │                 (ALB/NLB)                       │   │
│  └─────────────────┬───────────────────────────────┘   │
│                    │                                   │
│  ┌─────────────────┴───────────────────────────────┐   │
│  │              Auto Scaling Group                 │   │
│  │                                                 │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌───────┐ │   │
│  │  │Instance1│ │Instance2│ │Instance3│ │  RDS  │ │   │
│  │  │ Docker  │ │ Docker  │ │ Docker  │ │Postgres│ │   │
│  │  └─────────┘ └─────────┘ └─────────┘ └───────┘ │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

#### Deployment Steps
```bash
# 1. Infrastructure setup (using Terraform)
cd infrastructure/terraform/staging
terraform init
terraform plan
terraform apply

# 2. Configure CI/CD
# GitHub Actions will automatically deploy on push to 'develop' branch

# 3. Manual deployment (if needed)
./scripts/deploy.sh staging kubernetes

# 4. Verify deployment
kubectl get pods -n hcx-staging
kubectl get services -n hcx-staging
```

### 3. **Production Environment**

#### Architecture
```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              Production Cloud Environment                       │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                            Internet Gateway                             │   │
│  └─────────────────────────┬───────────────────────────────────────────────┘   │
│                            │                                                   │
│  ┌─────────────────────────┴───────────────────────────────────────────────┐   │
│  │                        Application Load Balancer                       │   │
│  │                         (Multi-AZ, SSL Termination)                    │   │
│  └─────────────────────────┬───────────────────────────────────────────────┘   │
│                            │                                                   │
│  ┌─────────────────────────┴───────────────────────────────────────────────┐   │
│  │                      Kubernetes Cluster (EKS/AKS/GKE)                  │   │
│  │                                                                         │   │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐         │   │
│  │  │   Namespace:    │  │   Namespace:    │  │   Namespace:    │         │   │
│  │  │  hcx-platform   │  │  kyc-registry   │  │  infrastructure │         │   │
│  │  │                 │  │                 │  │                 │         │   │
│  │  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │         │   │
│  │  │ │API Gateway  │ │  │ │HCX Integ.   │ │  │ │ Monitoring  │ │         │   │
│  │  │ │(3 replicas) │ │  │ │(3 replicas) │ │  │ │ (Prometheus)│ │         │   │
│  │  │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │         │   │
│  │  │                 │  │                 │  │                 │         │   │
│  │  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │         │   │
│  │  │ │HCX APIs     │ │  │ │KYC Service  │ │  │ │ Logging     │ │         │   │
│  │  │ │(5 replicas) │ │  │ │(3 replicas) │ │  │ │ (ELK Stack) │ │         │   │
│  │  │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │         │   │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘         │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                           Managed Services                              │   │
│  │                                                                         │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │   │
│  │  │ RDS         │  │ ElastiCache │  │ MSK/Kafka   │  │ S3/Blob     │   │   │
│  │  │ PostgreSQL  │  │ Redis       │  │ Cluster     │  │ Storage     │   │   │
│  │  │ Multi-AZ    │  │ Cluster     │  │ Multi-AZ    │  │ Encrypted   │   │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## 🔧 Environment-Specific Configurations

### 1. **Development Environment**

#### .env Configuration
```bash
# Database Configuration
POSTGRES_DB=hcx_dev
POSTGRES_USER=hcx_dev_user
POSTGRES_PASSWORD=dev_password_123
DATABASE_URL=jdbc:postgresql://localhost:5432/hcx_dev

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# Kafka Configuration
KAFKA_BOOTSTRAP_SERVERS=localhost:9092

# HCX Configuration
HCX_GATEWAY_URL=http://localhost:8090
HCX_PARTICIPANT_CODE=dev-kyc-registry
HCX_ENCRYPTION_ENABLED=false

# Egyptian Government APIs (Mock/Sandbox)
MOI_EKYC_API_URL=https://sandbox.moi.gov.eg/ekyc
MOI_EKYC_API_KEY=dev_moi_key_123
NTRA_API_URL=https://sandbox.ntra.gov.eg
NTRA_API_KEY=dev_ntra_key_123
FRA_API_URL=https://sandbox.fra.gov.eg
FRA_API_KEY=dev_fra_key_123

# Notification Services (Mock)
CEQUENS_SMS_API_URL=https://sandbox.cequens.com
CEQUENS_SMS_API_KEY=dev_cequens_key_123

# Logging
LOG_LEVEL=DEBUG
LOG_FORMAT=JSON

# Security
JWT_SECRET=dev_jwt_secret_key_very_long_and_secure
ENCRYPTION_KEY=dev_encryption_key_32_chars_long
```

#### Docker Compose Override
```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  hcx-api-gateway:
    environment:
      - SPRING_PROFILES_ACTIVE=dev
      - LOGGING_LEVEL_ROOT=DEBUG
    volumes:
      - ./logs:/app/logs

  hcx-apis:
    environment:
      - SPRING_PROFILES_ACTIVE=dev
      - LOGGING_LEVEL_ROOT=DEBUG
    volumes:
      - ./logs:/app/logs

  egyptian-hcx-integration:
    environment:
      - SPRING_PROFILES_ACTIVE=dev
      - LOGGING_LEVEL_ROOT=DEBUG
    volumes:
      - ./logs:/app/logs

  postgres:
    ports:
      - "5432:5432"
    volumes:
      - ./data/postgres:/var/lib/postgresql/data
      - ./scripts/init-dev-data.sql:/docker-entrypoint-initdb.d/init-dev-data.sql

  redis:
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - ./data/redis:/data
```

### 2. **Staging Environment**

#### Kubernetes Configuration
```yaml
# k8s/staging/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: hcx-staging
  labels:
    environment: staging
    project: egyptian-hcx

---
# k8s/staging/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: hcx-config
  namespace: hcx-staging
data:
  SPRING_PROFILES_ACTIVE: "staging"
  DATABASE_URL: "jdbc:postgresql://postgres-staging.internal:5432/hcx_staging"
  REDIS_HOST: "redis-staging.internal"
  KAFKA_BOOTSTRAP_SERVERS: "kafka-staging.internal:9092"
  HCX_GATEWAY_URL: "https://hcx-staging.healthflowegy.com"
  LOG_LEVEL: "INFO"

---
# k8s/staging/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: hcx-secrets
  namespace: hcx-staging
type: Opaque
data:
  DATABASE_PASSWORD: <base64-encoded-password>
  JWT_SECRET: <base64-encoded-jwt-secret>
  MOI_EKYC_API_KEY: <base64-encoded-api-key>
  NTRA_API_KEY: <base64-encoded-api-key>
  FRA_API_KEY: <base64-encoded-api-key>
  CEQUENS_SMS_API_KEY: <base64-encoded-api-key>
```

#### Deployment Configuration
```yaml
# k8s/staging/hcx-api-gateway.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hcx-api-gateway
  namespace: hcx-staging
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hcx-api-gateway
  template:
    metadata:
      labels:
        app: hcx-api-gateway
    spec:
      containers:
      - name: hcx-api-gateway
        image: ghcr.io/healthflowegy/hcx-platform/api-gateway:latest
        ports:
        - containerPort: 8090
        env:
        - name: SPRING_PROFILES_ACTIVE
          valueFrom:
            configMapKeyRef:
              name: hcx-config
              key: SPRING_PROFILES_ACTIVE
        envFrom:
        - configMapRef:
            name: hcx-config
        - secretRef:
            name: hcx-secrets
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8090
          initialDelaySeconds: 60
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8090
          initialDelaySeconds: 30
          periodSeconds: 10

---
apiVersion: v1
kind: Service
metadata:
  name: hcx-api-gateway
  namespace: hcx-staging
spec:
  selector:
    app: hcx-api-gateway
  ports:
  - port: 8090
    targetPort: 8090
  type: ClusterIP

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hcx-api-gateway
  namespace: hcx-staging
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - hcx-staging.healthflowegy.com
    secretName: hcx-staging-tls
  rules:
  - host: hcx-staging.healthflowegy.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hcx-api-gateway
            port:
              number: 8090
```

### 3. **Production Environment**

#### Infrastructure as Code (Terraform)
```hcl
# infrastructure/terraform/production/main.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Configuration
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "hcx-production-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Environment = "production"
    Project     = "egyptian-hcx"
  }
}

# EKS Cluster
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  
  cluster_name    = "hcx-production"
  cluster_version = "1.27"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  node_groups = {
    main = {
      desired_capacity = 6
      max_capacity     = 12
      min_capacity     = 3
      
      instance_types = ["m5.xlarge"]
      
      k8s_labels = {
        Environment = "production"
        NodeGroup   = "main"
      }
    }
  }
  
  tags = {
    Environment = "production"
    Project     = "egyptian-hcx"
  }
}

# RDS PostgreSQL
resource "aws_db_instance" "main" {
  identifier = "hcx-production-db"
  
  engine         = "postgres"
  engine_version = "13.7"
  instance_class = "db.r5.2xlarge"
  
  allocated_storage     = 500
  max_allocated_storage = 1000
  storage_type          = "gp2"
  storage_encrypted     = true
  
  db_name  = "hcx_production"
  username = "hcx_admin"
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  backup_retention_period = 30
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  multi_az               = true
  publicly_accessible    = false
  
  tags = {
    Environment = "production"
    Project     = "egyptian-hcx"
  }
}

# ElastiCache Redis
resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = "hcx-production-redis"
  description                = "Redis cluster for HCX production"
  
  node_type                  = "cache.r5.xlarge"
  port                       = 6379
  parameter_group_name       = "default.redis6.x"
  
  num_cache_clusters         = 3
  automatic_failover_enabled = true
  multi_az_enabled          = true
  
  subnet_group_name = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.redis.id]
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  
  tags = {
    Environment = "production"
    Project     = "egyptian-hcx"
  }
}

# MSK Kafka Cluster
resource "aws_msk_cluster" "main" {
  cluster_name           = "hcx-production-kafka"
  kafka_version          = "3.2.0"
  number_of_broker_nodes = 3
  
  broker_node_group_info {
    instance_type   = "kafka.m5.xlarge"
    ebs_volume_size = 100
    client_subnets  = module.vpc.private_subnets
    security_groups = [aws_security_group.kafka.id]
  }
  
  encryption_info {
    encryption_at_rest_kms_key_id = aws_kms_key.kafka.arn
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }
  
  tags = {
    Environment = "production"
    Project     = "egyptian-hcx"
  }
}
```

#### Production Kubernetes Configuration
```yaml
# k8s/production/hcx-api-gateway.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hcx-api-gateway
  namespace: hcx-production
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  selector:
    matchLabels:
      app: hcx-api-gateway
  template:
    metadata:
      labels:
        app: hcx-api-gateway
        version: v1
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - hcx-api-gateway
              topologyKey: kubernetes.io/hostname
      containers:
      - name: hcx-api-gateway
        image: ghcr.io/healthflowegy/hcx-platform/api-gateway:v1.0.0
        ports:
        - containerPort: 8090
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "production"
        - name: JVM_OPTS
          value: "-Xms1g -Xmx2g -XX:+UseG1GC"
        envFrom:
        - configMapRef:
            name: hcx-config
        - secretRef:
            name: hcx-secrets
        resources:
          requests:
            memory: "2Gi"
            cpu: "500m"
          limits:
            memory: "4Gi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /actuator/health/liveness
            port: 8090
          initialDelaySeconds: 120
          periodSeconds: 30
          timeoutSeconds: 10
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8090
          initialDelaySeconds: 60
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        securityContext:
          runAsNonRoot: true
          runAsUser: 1000
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
        volumeMounts:
        - name: tmp
          mountPath: /tmp
        - name: logs
          mountPath: /app/logs
      volumes:
      - name: tmp
        emptyDir: {}
      - name: logs
        emptyDir: {}

---
apiVersion: v1
kind: Service
metadata:
  name: hcx-api-gateway
  namespace: hcx-production
spec:
  selector:
    app: hcx-api-gateway
  ports:
  - port: 8090
    targetPort: 8090
  type: ClusterIP

---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: hcx-api-gateway
  namespace: hcx-production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hcx-api-gateway
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

## 🚀 Deployment Procedures

### 1. **Automated Deployment (CI/CD)**

#### GitHub Actions Workflow
```yaml
# .github/workflows/deploy-production.yml
name: Deploy to Production

on:
  push:
    branches: [main]
    tags: ['v*']

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1
    
    - name: Configure kubectl
      run: |
        aws eks update-kubeconfig --name hcx-production --region us-east-1
    
    - name: Deploy to Kubernetes
      run: |
        kubectl apply -f k8s/production/
        kubectl rollout status deployment/hcx-api-gateway -n hcx-production
        kubectl rollout status deployment/hcx-apis -n hcx-production
        kubectl rollout status deployment/egyptian-hcx-integration -n hcx-production
    
    - name: Run health checks
      run: |
        ./scripts/health-check.sh production
    
    - name: Notify deployment
      uses: 8398a7/action-slack@v3
      with:
        status: ${{ job.status }}
        channel: '#deployments'
        webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### 2. **Manual Deployment**

#### Step-by-Step Production Deployment
```bash
# 1. Pre-deployment checks
./scripts/pre-deployment-check.sh production

# 2. Database migration (if needed)
kubectl exec -it deployment/hcx-apis -n hcx-production -- \
  java -jar app.jar --spring.profiles.active=production \
  --spring.liquibase.contexts=production

# 3. Deploy infrastructure updates
cd infrastructure/terraform/production
terraform plan
terraform apply

# 4. Deploy application updates
kubectl apply -f k8s/production/

# 5. Rolling update with zero downtime
kubectl set image deployment/hcx-api-gateway \
  hcx-api-gateway=ghcr.io/healthflowegy/hcx-platform/api-gateway:v1.1.0 \
  -n hcx-production

# 6. Verify deployment
kubectl rollout status deployment/hcx-api-gateway -n hcx-production
kubectl get pods -n hcx-production

# 7. Run smoke tests
./scripts/smoke-test.sh production

# 8. Monitor for 30 minutes
./scripts/monitor-deployment.sh production 30
```

### 3. **Rollback Procedures**

#### Automated Rollback
```bash
# Quick rollback to previous version
kubectl rollout undo deployment/hcx-api-gateway -n hcx-production
kubectl rollout undo deployment/hcx-apis -n hcx-production
kubectl rollout undo deployment/egyptian-hcx-integration -n hcx-production

# Rollback to specific revision
kubectl rollout undo deployment/hcx-api-gateway --to-revision=2 -n hcx-production

# Verify rollback
kubectl rollout status deployment/hcx-api-gateway -n hcx-production
./scripts/health-check.sh production
```

#### Database Rollback
```bash
# Restore from backup (if schema changes)
kubectl exec -it deployment/postgres -n hcx-production -- \
  pg_restore -U hcx_admin -d hcx_production /backups/pre-deployment-backup.sql

# Run rollback migrations
kubectl exec -it deployment/hcx-apis -n hcx-production -- \
  java -jar app.jar --spring.profiles.active=production \
  --spring.liquibase.rollback-count=1
```

## 🔍 Monitoring & Health Checks

### 1. **Health Check Scripts**

#### Application Health Check
```bash
#!/bin/bash
# scripts/health-check.sh

ENVIRONMENT=$1
NAMESPACE="hcx-${ENVIRONMENT}"

echo "🏥 Running health checks for ${ENVIRONMENT} environment..."

# Check pod status
echo "📊 Checking pod status..."
kubectl get pods -n $NAMESPACE

# Check service endpoints
echo "🌐 Checking service endpoints..."
SERVICES=("hcx-api-gateway" "hcx-apis" "egyptian-hcx-integration" "egyptian-kyc-service")

for service in "${SERVICES[@]}"; do
  echo "Checking $service..."
  
  # Get service URL
  if [ "$ENVIRONMENT" = "production" ]; then
    URL="https://hcx.healthflowegy.com"
  elif [ "$ENVIRONMENT" = "staging" ]; then
    URL="https://hcx-staging.healthflowegy.com"
  else
    URL="http://localhost:8090"
  fi
  
  # Health check
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL/actuator/health")
  
  if [ $HTTP_CODE -eq 200 ]; then
    echo "✅ $service is healthy"
  else
    echo "❌ $service is unhealthy (HTTP $HTTP_CODE)"
    exit 1
  fi
done

echo "🎉 All health checks passed!"
```

#### Database Health Check
```bash
#!/bin/bash
# scripts/db-health-check.sh

ENVIRONMENT=$1

echo "🗄️ Running database health checks..."

# Check database connectivity
kubectl exec -it deployment/hcx-apis -n hcx-$ENVIRONMENT -- \
  java -jar app.jar --spring.profiles.active=$ENVIRONMENT \
  --spring.datasource.hikari.connection-test-query="SELECT 1"

# Check database size
kubectl exec -it deployment/postgres -n hcx-$ENVIRONMENT -- \
  psql -U hcx_admin -d hcx_$ENVIRONMENT -c "
    SELECT 
      pg_size_pretty(pg_database_size('hcx_$ENVIRONMENT')) as database_size,
      count(*) as table_count
    FROM information_schema.tables 
    WHERE table_schema = 'public';
  "

# Check recent activity
kubectl exec -it deployment/postgres -n hcx-$ENVIRONMENT -- \
  psql -U hcx_admin -d hcx_$ENVIRONMENT -c "
    SELECT 
      schemaname,
      tablename,
      n_tup_ins as inserts,
      n_tup_upd as updates,
      n_tup_del as deletes
    FROM pg_stat_user_tables 
    ORDER BY n_tup_ins DESC 
    LIMIT 10;
  "

echo "✅ Database health check completed!"
```

### 2. **Monitoring Setup**

#### Prometheus Configuration
```yaml
# monitoring/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "rules/*.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

scrape_configs:
  - job_name: 'hcx-api-gateway'
    static_configs:
      - targets: ['hcx-api-gateway:8090']
    metrics_path: '/actuator/prometheus'
    scrape_interval: 30s

  - job_name: 'hcx-apis'
    static_configs:
      - targets: ['hcx-apis:8080']
    metrics_path: '/actuator/prometheus'
    scrape_interval: 30s

  - job_name: 'egyptian-hcx-integration'
    static_configs:
      - targets: ['egyptian-hcx-integration:8081']
    metrics_path: '/actuator/prometheus'
    scrape_interval: 30s

  - job_name: 'postgres-exporter'
    static_configs:
      - targets: ['postgres-exporter:9187']

  - job_name: 'redis-exporter'
    static_configs:
      - targets: ['redis-exporter:9121']

  - job_name: 'kafka-exporter'
    static_configs:
      - targets: ['kafka-exporter:9308']
```

#### Grafana Dashboards
```json
{
  "dashboard": {
    "title": "Egyptian HCX Ecosystem Overview",
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{service}} - {{method}} {{status}}"
          }
        ]
      },
      {
        "title": "Response Time",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "95th percentile"
          }
        ]
      },
      {
        "title": "Error Rate",
        "type": "singlestat",
        "targets": [
          {
            "expr": "rate(http_requests_total{status=~\"5..\"}[5m]) / rate(http_requests_total[5m]) * 100",
            "legendFormat": "Error Rate %"
          }
        ]
      }
    ]
  }
}
```

This comprehensive deployment guide provides detailed instructions for deploying the Egyptian HCX ecosystem across all environments. The next sections will cover infrastructure requirements and security considerations.

