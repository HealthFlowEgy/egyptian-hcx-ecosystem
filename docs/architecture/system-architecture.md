# Egyptian HCX Ecosystem - System Architecture

## 🏗️ Overview

The Egyptian Healthcare Claims Exchange (HCX) Ecosystem is a comprehensive, microservices-based platform designed to facilitate seamless healthcare claims processing across Egypt's healthcare system. The architecture follows HCX Protocol v0.9 specifications and integrates with Egyptian government systems.

## 🎯 Architecture Principles

### 1. **Microservices Architecture**
- **Service Independence**: Each service can be developed, deployed, and scaled independently
- **Technology Diversity**: Services can use different technologies based on requirements
- **Fault Isolation**: Failure in one service doesn't cascade to others
- **Team Autonomy**: Different teams can own different services

### 2. **Event-Driven Architecture**
- **Asynchronous Communication**: Services communicate via events and message queues
- **Loose Coupling**: Services are decoupled through event streams
- **Scalability**: Easy to scale individual components based on load
- **Resilience**: System continues to function even if some services are down

### 3. **API-First Design**
- **Contract-First**: APIs are designed before implementation
- **Versioning**: Proper API versioning for backward compatibility
- **Documentation**: Comprehensive API documentation with OpenAPI/Swagger
- **Security**: OAuth2/JWT-based authentication and authorization

### 4. **Cloud-Native Design**
- **Containerization**: All services are containerized with Docker
- **Orchestration**: Kubernetes-ready for production deployments
- **Observability**: Comprehensive logging, monitoring, and tracing
- **DevOps**: CI/CD pipelines for automated testing and deployment

## 🏛️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           EGYPTIAN HCX ECOSYSTEM                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                        HCX PLATFORM (Core Gateway)                     │   │
│  │                                                                         │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │   │
│  │  │ API Gateway │  │ HCX APIs    │  │ Registry    │  │ Onboarding  │   │   │
│  │  │ :8090       │  │ :8080       │  │ Services    │  │ Platform    │   │   │
│  │  │             │  │             │  │             │  │             │   │   │
│  │  │ • Routing   │  │ • Claims    │  │ • Participants│ │ • KYC       │   │   │
│  │  │ • Auth      │  │ • Eligibility│ │ • Policies   │  │ • Enrollment│   │   │
│  │  │ • Rate Limit│  │ • Pre-auth  │  │ • Configs    │  │ • Validation│   │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                      │                                         │
│                                      │ HCX Protocol v0.9                      │
│                                      │ (JWE Encrypted)                        │
│                                      │                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │              EGYPTIAN HEALTHCARE KYC REGISTRY                          │   │
│  │                    (External Identity Provider)                        │   │
│  │                                                                         │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │   │
│  │  │ HCX Integ.  │  │ KYC Service │  │ Gov. Integ. │  │ Notification│   │   │
│  │  │ :8081       │  │ :8082       │  │ :8083       │  │ :8084       │   │   │
│  │  │             │  │             │  │             │  │             │   │   │
│  │  │ • Protocol  │  │ • Beneficiary│ │ • MOI eKYC  │  │ • SMS       │   │   │
│  │  │ • JWE       │  │ • ESHIC     │  │ • NTRA      │  │ • Email     │   │   │
│  │  │ • FHIR      │  │ • Enrollment│  │ • FRA       │  │ • Push      │   │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│                              INFRASTRUCTURE LAYER                              │
│                                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐   │
│  │ PostgreSQL  │  │ Redis Cache │  │ Apache      │  │ Hyperledger Fabric  │   │
│  │ :5432       │  │ :6379       │  │ Kafka       │  │ + Identus DID/VC    │   │
│  │             │  │             │  │ :9092       │  │                     │   │
│  │ • Primary   │  │ • Session   │  │             │  │ • Blockchain        │   │
│  │ • Replica   │  │ • Cache     │  │ • Events    │  │ • Smart Contracts   │   │
│  │ • Backup    │  │ • Queue     │  │ • Audit     │  │ • Digital Identity  │   │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## 🔧 Component Architecture

### 1. **HCX Platform Components**

#### API Gateway (:8090)
**Purpose**: Central entry point for all HCX protocol communications

**Responsibilities**:
- Request routing and load balancing
- Authentication and authorization (OAuth2/JWT)
- Rate limiting and throttling
- Request/response transformation
- API versioning and backward compatibility
- Monitoring and analytics

**Technology Stack**:
- Spring Boot 3.x
- Spring Cloud Gateway
- Spring Security OAuth2
- Redis for session management
- Micrometer for metrics

#### HCX APIs (:8080)
**Purpose**: Core business logic for HCX protocol operations

**Responsibilities**:
- Coverage eligibility checking
- Pre-authorization processing
- Claims submission and processing
- Communication request handling
- FHIR bundle validation and processing
- Participant registry management

**Technology Stack**:
- Spring Boot 3.x
- Spring Data JPA
- HAPI FHIR
- PostgreSQL
- Apache Kafka
- Redis caching

#### Registry Services
**Purpose**: Participant and configuration management

**Responsibilities**:
- Participant onboarding and management
- Policy configuration
- Network management
- Audit logging
- Compliance monitoring

#### Onboarding Platform
**Purpose**: Web-based participant registration and management

**Responsibilities**:
- Participant registration workflows
- Document verification
- KYC compliance
- User management
- Dashboard and reporting

### 2. **Egyptian KYC Registry Components**

#### HCX Integration Service (:8081)
**Purpose**: HCX Protocol v0.9 compliant integration layer

**Responsibilities**:
- HCX protocol message handling
- JWE encryption/decryption
- FHIR bundle creation and validation
- Egyptian healthcare context mapping
- Beneficiary lookup and verification

**Key Features**:
- RSA-OAEP + A256GCM encryption
- Mandatory HCX headers implementation
- FHIR R4 compliance
- Bilingual support (Arabic/English)

#### KYC Service (:8082)
**Purpose**: Beneficiary verification and management

**Responsibilities**:
- ESHIC (Egyptian Social Health Insurance Card) management
- National ID verification
- Beneficiary enrollment
- Family member management
- Insurance coverage tracking

**Data Models**:
- EgyptianBeneficiary entity
- PayerEnrollment tracking
- Bilingual name records
- Egyptian address formats

#### Government Integration Service (:8083)
**Purpose**: Integration with Egyptian government systems

**Responsibilities**:
- MOI (Ministry of Interior) eKYC integration
- NTRA (National Telecom Regulatory Authority) verification
- FRA (Financial Regulatory Authority) compliance
- Real-time government data synchronization

**API Integrations**:
- MOI eKYC API for identity verification
- NTRA API for telecom verification
- FRA API for financial compliance

#### Notification Service (:8084)
**Purpose**: Multi-channel communication system

**Responsibilities**:
- SMS notifications via Cequens
- Email notifications
- Push notifications
- Notification templates
- Delivery tracking and analytics

## 🗄️ Data Architecture

### 1. **Database Design**

#### Primary Database (PostgreSQL)
```sql
-- Core HCX Platform Tables
hcx_participants
hcx_policies
hcx_claims
hcx_eligibility_requests
hcx_audit_logs

-- Egyptian KYC Registry Tables
egyptian_beneficiaries
payer_enrollments
government_verifications
notification_logs
```

#### Caching Layer (Redis)
```
Session Management:
- session:{user_id} -> session_data
- jwt:{token_id} -> token_metadata

Application Cache:
- beneficiary:{eshic} -> beneficiary_data
- eligibility:{request_id} -> eligibility_response
- government:{national_id} -> verification_status

Rate Limiting:
- rate_limit:{api_key}:{endpoint} -> request_count
- throttle:{user_id} -> request_timestamps
```

### 2. **Message Queue Architecture (Apache Kafka)**

#### Topics Structure
```
hcx.claims.submitted
hcx.claims.processed
hcx.eligibility.requested
hcx.eligibility.responded
kyc.beneficiary.verified
kyc.enrollment.completed
government.verification.requested
government.verification.completed
notifications.sms.queued
notifications.email.queued
audit.events.logged
```

#### Event Schema
```json
{
  "eventId": "uuid",
  "eventType": "claim.submitted",
  "timestamp": "2024-01-01T00:00:00Z",
  "source": "hcx-apis",
  "data": {
    "participantId": "provider-123",
    "beneficiaryId": "ben-456",
    "claimAmount": 1000.00,
    "currency": "EGP"
  },
  "metadata": {
    "correlationId": "corr-789",
    "version": "1.0"
  }
}
```

## 🔐 Security Architecture

### 1. **Authentication & Authorization**

#### OAuth2 + JWT Implementation
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Client    │    │ Auth Server │    │ Resource    │
│ Application │    │ (Keycloak)  │    │ Server      │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       │ 1. Login Request  │                   │
       ├──────────────────►│                   │
       │                   │                   │
       │ 2. JWT Token      │                   │
       │◄──────────────────┤                   │
       │                   │                   │
       │ 3. API Request + JWT                  │
       ├──────────────────────────────────────►│
       │                   │                   │
       │                   │ 4. Validate JWT  │
       │                   │◄──────────────────┤
       │                   │                   │
       │                   │ 5. User Info     │
       │                   ├──────────────────►│
       │                   │                   │
       │ 6. API Response   │                   │
       │◄──────────────────────────────────────┤
```

#### Role-Based Access Control (RBAC)
```yaml
Roles:
  - hcx_admin:
      permissions: [manage_participants, view_all_claims, system_config]
  - provider_admin:
      permissions: [submit_claims, view_own_claims, manage_provider_users]
  - payer_admin:
      permissions: [process_claims, view_eligibility, manage_policies]
  - beneficiary:
      permissions: [view_own_data, update_profile, view_claims_history]
  - kyc_operator:
      permissions: [verify_beneficiaries, access_government_apis, manage_enrollments]
```

### 2. **Data Encryption**

#### At Rest Encryption
- **Database**: PostgreSQL with TDE (Transparent Data Encryption)
- **Files**: AES-256 encryption for stored documents
- **Backups**: Encrypted backup storage with key rotation

#### In Transit Encryption
- **TLS 1.3**: All API communications
- **HCX JWE**: RSA-OAEP + A256GCM for HCX protocol messages
- **VPN**: Secure tunnels for government API integrations

#### Key Management
```
┌─────────────────────────────────────────────────────────┐
│                 Key Management System                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ HSM/KMS     │  │ Certificate │  │ Key Rotation│     │
│  │ Integration │  │ Management  │  │ Policies    │     │
│  │             │  │             │  │             │     │
│  │ • AWS KMS   │  │ • TLS Certs │  │ • 90-day    │     │
│  │ • Azure KV  │  │ • JWT Keys  │  │ • Automated │     │
│  │ • HashiCorp │  │ • JWE Keys  │  │ • Audited   │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
```

## 🌐 Network Architecture

### 1. **Network Topology**

#### Production Environment
```
┌─────────────────────────────────────────────────────────────────┐
│                        INTERNET                                 │
└─────────────────────────┬───────────────────────────────────────┘
                          │
┌─────────────────────────┴───────────────────────────────────────┐
│                    LOAD BALANCER                                │
│                 (AWS ALB / NGINX)                               │
└─────────────────────────┬───────────────────────────────────────┘
                          │
┌─────────────────────────┴───────────────────────────────────────┐
│                     DMZ ZONE                                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ API Gateway │  │ Web App     │  │ Monitoring  │             │
│  │ (Public)    │  │ (Public)    │  │ (Internal)  │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────┬───────────────────────────────────────┘
                          │
┌─────────────────────────┴───────────────────────────────────────┐
│                  APPLICATION ZONE                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ HCX APIs    │  │ KYC Service │  │ Gov. Integ. │             │
│  │ (Private)   │  │ (Private)   │  │ (Private)   │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────┬───────────────────────────────────────┘
                          │
┌─────────────────────────┴───────────────────────────────────────┐
│                    DATABASE ZONE                                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ PostgreSQL  │  │ Redis       │  │ Kafka       │             │
│  │ (Private)   │  │ (Private)   │  │ (Private)   │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────────────────────────────────────────────┘
```

#### Security Groups / Firewall Rules
```yaml
DMZ Zone:
  Inbound:
    - Port 443 (HTTPS) from Internet
    - Port 80 (HTTP) from Internet (redirect to 443)
  Outbound:
    - Port 8080-8090 to Application Zone
    - Port 443 to Internet (for external APIs)

Application Zone:
  Inbound:
    - Port 8080-8090 from DMZ Zone
    - Port 22 (SSH) from Bastion Host
  Outbound:
    - Port 5432 to Database Zone (PostgreSQL)
    - Port 6379 to Database Zone (Redis)
    - Port 9092 to Database Zone (Kafka)
    - Port 443 to Internet (for government APIs)

Database Zone:
  Inbound:
    - Port 5432 from Application Zone
    - Port 6379 from Application Zone
    - Port 9092 from Application Zone
  Outbound:
    - None (except for replication)
```

## 📊 Monitoring & Observability

### 1. **Monitoring Stack**

#### Metrics Collection (Prometheus)
```yaml
Metrics Endpoints:
  - /actuator/prometheus (Spring Boot services)
  - /metrics (Custom metrics)
  - Node Exporter (System metrics)
  - PostgreSQL Exporter (Database metrics)
  - Redis Exporter (Cache metrics)
  - Kafka Exporter (Message queue metrics)

Key Metrics:
  Business Metrics:
    - hcx_claims_submitted_total
    - hcx_eligibility_requests_total
    - kyc_verifications_completed_total
    - government_api_calls_total
    
  Technical Metrics:
    - http_requests_duration_seconds
    - database_connections_active
    - cache_hit_ratio
    - queue_message_lag
    
  Infrastructure Metrics:
    - cpu_usage_percent
    - memory_usage_bytes
    - disk_usage_percent
    - network_bytes_transmitted
```

#### Visualization (Grafana)
```yaml
Dashboards:
  - HCX Platform Overview
  - Egyptian KYC Registry Status
  - Infrastructure Health
  - Business Metrics
  - Security Events
  - Performance Analytics

Alerts:
  Critical:
    - Service down for > 5 minutes
    - Database connection failure
    - High error rate (> 5%)
    - Government API timeout
    
  Warning:
    - High response time (> 2 seconds)
    - Low cache hit ratio (< 80%)
    - High memory usage (> 80%)
    - Queue lag (> 1000 messages)
```

#### Logging (ELK Stack)
```yaml
Log Sources:
  - Application logs (JSON format)
  - Access logs (NGINX/ALB)
  - Database logs (PostgreSQL)
  - System logs (syslog)
  - Security logs (audit events)

Log Processing:
  Logstash Pipelines:
    - Parse application logs
    - Enrich with metadata
    - Filter sensitive data
    - Route to appropriate indices
    
  Elasticsearch Indices:
    - hcx-platform-logs-YYYY.MM.DD
    - kyc-registry-logs-YYYY.MM.DD
    - security-events-YYYY.MM.DD
    - performance-metrics-YYYY.MM.DD

Kibana Dashboards:
  - Real-time log monitoring
  - Error tracking and analysis
  - Security event correlation
  - Performance troubleshooting
```

#### Distributed Tracing (Jaeger)
```yaml
Trace Collection:
  - OpenTelemetry instrumentation
  - Spring Cloud Sleuth integration
  - Custom span annotations
  - Cross-service correlation

Trace Analysis:
  - Request flow visualization
  - Performance bottleneck identification
  - Error propagation tracking
  - Dependency mapping
```

## 🔄 Integration Architecture

### 1. **HCX Protocol Integration**

#### Message Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Payer     │    │ HCX Gateway │    │ Provider    │
│             │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       │ 1. Eligibility    │                   │
       │    Request        │                   │
       ├──────────────────►│                   │
       │                   │                   │
       │                   │ 2. Route to      │
       │                   │    Provider      │
       │                   ├──────────────────►│
       │                   │                   │
       │                   │ 3. Eligibility   │
       │                   │    Response      │
       │                   │◄──────────────────┤
       │                   │                   │
       │ 4. Response       │                   │
       │◄──────────────────┤                   │
```

#### JWE Message Structure
```json
{
  "protected": {
    "alg": "RSA-OAEP",
    "enc": "A256GCM",
    "x-hcx-sender_code": "provider-123",
    "x-hcx-recipient_code": "payer-456",
    "x-hcx-api_call_id": "call-789",
    "x-hcx-correlation_id": "corr-abc",
    "x-hcx-timestamp": "2024-01-01T00:00:00.000Z"
  },
  "encrypted_key": "...",
  "iv": "...",
  "ciphertext": "...",
  "tag": "..."
}
```

### 2. **Government API Integration**

#### MOI eKYC Integration
```yaml
Endpoint: https://api.moi.gov.eg/ekyc/v1/verify
Method: POST
Authentication: API Key + Digital Certificate

Request:
  national_id: "12345678901234"
  verification_type: "full"
  request_id: "req-123"

Response:
  status: "verified"
  citizen_data:
    name_ar: "أحمد محمد علي"
    name_en: "Ahmed Mohamed Ali"
    birth_date: "1990-01-01"
    address: "..."
    photo: "base64_encoded_image"
```

#### NTRA Integration
```yaml
Endpoint: https://api.ntra.gov.eg/telecom/v1/verify
Method: POST
Authentication: OAuth2

Request:
  phone_number: "+201234567890"
  national_id: "12345678901234"
  verification_code: "123456"

Response:
  status: "verified"
  operator: "Orange Egypt"
  registration_date: "2020-01-01"
```

### 3. **Blockchain Integration**

#### Hyperledger Fabric Network
```yaml
Network Configuration:
  Organizations:
    - HealthFlowEgy (Orderer + Peer)
    - MOH (Ministry of Health - Peer)
    - Insurance Companies (Peers)
    
  Channels:
    - hcx-main: Main HCX transactions
    - kyc-registry: KYC verification records
    - audit-trail: Immutable audit logs
    
  Chaincodes:
    - EgyptianKycChaincode: Beneficiary verification
    - HcxAuditChaincode: Transaction auditing
    - IdentityChaincode: Digital identity management
```

#### Identus DID/VC Integration
```yaml
DID Method: did:prism
Credential Types:
  - EgyptianCitizenCredential
  - HealthInsuranceCredential
  - ProviderLicenseCredential
  - PayerRegistrationCredential

Verification Flow:
  1. Issue DID for beneficiary
  2. Create verifiable credential
  3. Store on blockchain
  4. Verify during HCX transactions
```

This comprehensive architecture documentation provides the foundation for understanding the Egyptian HCX ecosystem. The next sections will cover detailed deployment guides and infrastructure requirements.

