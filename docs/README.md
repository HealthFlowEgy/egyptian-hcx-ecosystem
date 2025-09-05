# Egyptian HCX Ecosystem Documentation

This repository contains the deployment and orchestration configurations for the complete Egyptian HCX ecosystem.

## Components

- **HCX Platform**: The core HCX gateway.
- **Egyptian Healthcare KYC Registry**: An External Identity Provider for beneficiary verification.

## Deployment

To deploy the entire ecosystem, use the `deploy.sh` script:

```bash
./scripts/deploy.sh <environment> <mode>
```

- **environment**: `dev`, `staging`, or `prod`
- **mode**: `docker-compose` or `kubernetes`


