# Egyptian HCX Ecosystem - Unified Deployment

🏥 **Complete Health Claims Exchange Platform for Egypt**

This repository orchestrates the deployment of the complete Egyptian HCX ecosystem, consisting of:
- **HCX Platform**: Core gateway and infrastructure
- **Egyptian Healthcare KYC Registry**: External Identity Provider for beneficiary verification

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    HCX PLATFORM (Core Gateway)             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ API Gateway │  │ HCX APIs    │  │ Registry Services   │ │
│  │ :8090       │  │ :8080       │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ HCX Protocol v0.9
                              │
┌─────────────────────────────────────────────────────────────┐
│         EGYPTIAN HEALTHCARE KYC REGISTRY                   │
│                (External Identity Provider)                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ HCX Integ.  │  │ KYC Service │  │ Gov. Integration    │ │
│  │ :8081       │  │ :8082       │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- Docker (version 20.0 or higher)
- Docker Compose (version 1.29 or higher)
- Git

### 1. Clone All Repositories

```bash
# Clone the orchestration repository
git clone https://github.com/HealthFlowEgy/egyptian-hcx-ecosystem.git
cd egyptian-hcx-ecosystem

# Clone the HCX platform (in parent directory)
cd ..
git clone https://github.com/HealthFlowEgy/hcx-platform.git

# Clone the Egyptian KYC registry (in parent directory)
git clone https://github.com/HealthFlowEgy/egyptian-healthcare-kyc-registry.git

# Return to orchestration directory
cd egyptian-hcx-ecosystem
```

### 2. Deploy the Complete Ecosystem

```bash
# Deploy for development
./scripts/deploy.sh dev docker-compose

# Deploy for production
./scripts/deploy.sh prod docker-compose
```

### 3. Verify Deployment

```bash
# Check service status
docker-compose ps

# View logs
docker-compose logs -f
```

## 🌐 Access URLs

After successful deployment:

- **HCX API Gateway**: http://localhost:8090
- **HCX Core APIs**: http://localhost:8080
- **Egyptian HCX Integration**: http://localhost:8081
- **Egyptian KYC Service**: http://localhost:8082
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379
- **Kafka**: localhost:9092

## 📋 Services Overview

### HCX Platform Services

| Service | Port | Description |
|---------|------|-------------|
| **hcx-api-gateway** | 8090 | Main entry point for HCX protocol |
| **hcx-apis** | 8080 | Core HCX business logic and APIs |

### Egyptian KYC Registry Services

| Service | Port | Description |
|---------|------|-------------|
| **egyptian-hcx-integration** | 8081 | HCX v0.9 compliant integration service |
| **egyptian-kyc-service** | 8082 | Beneficiary verification and management |

### Infrastructure Services

| Service | Port | Description |
|---------|------|-------------|
| **postgres** | 5432 | PostgreSQL database |
| **redis** | 6379 | Redis cache |
| **kafka** | 9092 | Apache Kafka message broker |
| **zookeeper** | 2181 | Zookeeper for Kafka |

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
# Database Configuration
POSTGRES_DB=hcx
POSTGRES_USER=hcx_user
POSTGRES_PASSWORD=hcx_password

# Egyptian Government APIs
MOI_EKYC_API_URL=https://api.moi.gov.eg/ekyc
MOI_EKYC_API_KEY=your_moi_api_key
NTRA_API_URL=https://api.ntra.gov.eg
NTRA_API_KEY=your_ntra_api_key
FRA_API_URL=https://api.fra.gov.eg
FRA_API_KEY=your_fra_api_key

# SMS Service
CEQUENS_SMS_API_URL=https://api.cequens.com
CEQUENS_SMS_API_KEY=your_cequens_api_key
```

## 🐳 Docker Commands

### Development

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f [service_name]

# Stop all services
docker-compose down

# Rebuild and restart
docker-compose up -d --build
```

### Production

```bash
# Deploy to production
./scripts/deploy.sh prod docker-compose

# Scale services
docker-compose up -d --scale hcx-apis=3

# Update services
docker-compose pull && docker-compose up -d
```

## ☸️ Kubernetes Deployment

### Prerequisites

- Kubernetes cluster (1.20+)
- kubectl configured
- Helm (optional)

### Deploy to Kubernetes

```bash
# Deploy using the script
./scripts/deploy.sh prod kubernetes

# Or manually apply manifests
kubectl apply -f kubernetes/hcx-platform/
kubectl apply -f kubernetes/kyc-registry/
```

### Monitor Deployment

```bash
# Check pods
kubectl get pods

# Check services
kubectl get services

# View logs
kubectl logs -f deployment/hcx-api-gateway
```

## 🔍 Health Checks

### Manual Health Checks

```bash
# HCX API Gateway
curl http://localhost:8090/actuator/health

# HCX APIs
curl http://localhost:8080/actuator/health

# Egyptian HCX Integration
curl http://localhost:8081/actuator/health

# Egyptian KYC Service
curl http://localhost:8082/actuator/health
```

### Automated Health Checks

The deployment script includes automated health checks that verify all services are running correctly.

## 📊 Monitoring

### Prometheus Metrics

Metrics are exposed on `/actuator/prometheus` for each service:

- HCX API Gateway: http://localhost:8090/actuator/prometheus
- HCX APIs: http://localhost:8080/actuator/prometheus
- Egyptian Services: http://localhost:8081/actuator/prometheus

### Grafana Dashboard

A Grafana dashboard configuration is available in the `monitoring/` directory.

## 🔐 Security

### Production Security Checklist

- [ ] Change default passwords
- [ ] Configure SSL/TLS certificates
- [ ] Set up firewall rules
- [ ] Enable audit logging
- [ ] Configure backup strategies
- [ ] Set up monitoring and alerting

### API Security

- JWT-based authentication
- Role-based access control (RBAC)
- API rate limiting
- Request/response encryption (HCX JWE)

## 🚨 Troubleshooting

### Common Issues

1. **Port Conflicts**
   ```bash
   # Check port usage
   netstat -tulpn | grep :8080
   
   # Stop conflicting services
   sudo systemctl stop service_name
   ```

2. **Database Connection Issues**
   ```bash
   # Check PostgreSQL logs
   docker-compose logs postgres
   
   # Reset database
   docker-compose down -v
   docker-compose up -d
   ```

3. **Service Startup Failures**
   ```bash
   # Check service logs
   docker-compose logs service_name
   
   # Restart specific service
   docker-compose restart service_name
   ```

### Log Locations

- Application logs: `docker-compose logs [service_name]`
- Database logs: `docker-compose logs postgres`
- Infrastructure logs: `docker-compose logs redis kafka`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:

- **Issues**: [GitHub Issues](https://github.com/HealthFlowEgy/egyptian-hcx-ecosystem/issues)
- **Documentation**: [Wiki](https://github.com/HealthFlowEgy/egyptian-hcx-ecosystem/wiki)
- **Email**: tech@healthflowegy.com

## 🔗 Related Repositories

- [HCX Platform](https://github.com/HealthFlowEgy/hcx-platform)
- [Egyptian Healthcare KYC Registry](https://github.com/HealthFlowEgy/egyptian-healthcare-kyc-registry)
- [Healthcare Professional Registry](https://github.com/HealthFlowEgy/healthcare-professional-registry)

---

**🇪🇬 Built for Egyptian Healthcare System**

This platform enables seamless healthcare claims processing across Egypt's healthcare ecosystem, supporting the digital transformation of Egyptian healthcare services.

