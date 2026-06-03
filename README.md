# Microservices Infrastructure

This repository contains Terraform modules and environment configurations for deploying microservices infrastructure on Azure.

## Infrastructure Components
- **Resource Groups**: Managed via `modules/resource_group`
- **Azure Container Registry (ACR)**: Managed via `modules/acr`
- **Azure Kubernetes Service (AKS)**: Managed via `modules/aks`

## CI/CD Pipeline
The project uses GitHub Actions for automation:
- **Quality & Security**: TFLint, tfsec, and Checkov.
- **Authentication**: Uses OIDC for secure Azure access.
- **Continuous Deployment**: Automatically plans and applies changes to the `dev` environment on push to `main`.

## Usage
Navigate to `environments/dev` and use standard Terraform commands.