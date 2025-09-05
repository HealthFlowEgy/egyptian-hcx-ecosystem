# Egyptian HCX Ecosystem - Documentation

## 📚 Overview

This documentation provides comprehensive guidance for understanding, deploying, and operating the Egyptian Healthcare Claims Exchange (HCX) ecosystem. The documentation is organized into several key areas to support different stakeholders and use cases.

## 🗂️ Documentation Structure

### 1. **Architecture Documentation**
- **[System Architecture](architecture/system-architecture.md)** - Comprehensive system design, component architecture, and integration patterns

### 2. **Deployment Documentation**
- **[Deployment Guide](deployment/deployment-guide.md)** - Complete deployment instructions for all environments

### 3. **Infrastructure Documentation**
- **[Infrastructure Requirements](infrastructure/infrastructure-requirements.md)** - Detailed infrastructure specifications and capacity planning

### 4. **Security Documentation**
- **[Security Guide](security/security-guide.md)** - Comprehensive security framework and implementation

## 🎯 Quick Start

### For Developers
```bash
git clone https://github.com/HealthFlowEgy/egyptian-hcx-ecosystem.git
cd egyptian-hcx-ecosystem
./scripts/deploy.sh dev docker-compose
```

### For Production
```bash
./scripts/deploy.sh production kubernetes
```

## 🏗️ Architecture Overview

The Egyptian HCX ecosystem consists of two main components:

### HCX Platform (Core Gateway)
- **API Gateway** - Central entry point for all HCX communications
- **HCX APIs** - Core business logic for claims processing
- **Registry Services** - Participant and policy management
- **Onboarding Platform** - Web-based participant registration

### Egyptian KYC Registry (External Identity Provider)
- **HCX Integration Service** - HCX Protocol v0.9 compliant integration
- **KYC Service** - Beneficiary verification and management
- **Government Integration** - MOI, NTRA, FRA API integration
- **Notification Service** - Multi-channel communication system

## 📊 Key Features

### ✅ HCX Protocol Compliance
- **HCX v0.9 Specification** - Full compliance with latest HCX protocol
- **JWE Encryption** - RSA-OAEP + A256GCM encryption for all messages
- **FHIR R4 Support** - Complete FHIR bundle implementation
- **External Identity Provider** - Registered HCX participant type

### ✅ Egyptian Healthcare Integration
- **ESHIC Support** - Egyptian Social Health Insurance Card integration
- **Government APIs** - MOI eKYC, NTRA, FRA integration
- **Bilingual Support** - Arabic and English language support
- **Local Compliance** - Egyptian healthcare regulations compliance

### ✅ Enterprise Features
- **Microservices Architecture** - Scalable, maintainable design
- **Cloud Native** - Kubernetes-ready containerized deployment
- **High Availability** - Multi-region disaster recovery
- **Security First** - Comprehensive security framework
- **Observability** - Complete monitoring and logging

## 🔗 Related Repositories

- **[HCX Platform](https://github.com/HealthFlowEgy/hcx-platform)** - Core HCX gateway infrastructure
- **[Egyptian KYC Registry](https://github.com/HealthFlowEgy/egyptian-healthcare-kyc-registry)** - Egyptian healthcare KYC registry
- **[Healthcare Professional Registry](https://github.com/HealthFlowEgy/healthcare-professional-registry)** - Healthcare provider registry

## 📞 Support

For technical support, please create an issue in the respective repository or contact the HealthFlowEgy team.


