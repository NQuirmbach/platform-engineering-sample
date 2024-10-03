# Terraform Azure Kubernetes Cluster with GitHub Actions

This project provisions and manages a Kubernetes cluster on **Azure** using **Terraform** and **Ansible**, with files organized in the `ops` folder. It leverages **Terraform Workspaces** to handle different environments such as **development** and **production** and uses **GitHub Actions** for continuous integration and deployment.

## Project Overview

The goal of this project is to automate the deployment of infrastructure using **Infrastructure as Code (IaC)** practices. A Kubernetes cluster is provisioned on Azure manually (without AKS), and **Ansible** is used for configuration tasks such as SSH hardening. The project utilizes **Terraform Workspaces** to manage separate environments (dev/prod) and **GitHub Actions** for automation.

### Key Features

- **Kubernetes Cluster on Azure**: Provisioned manually with Terraform (non-AKS).
- **Terraform Workspaces**: Manages multiple environments (dev, prod).
- **GitHub Actions CI/CD**: Automatically provisions infrastructure based on branch (`dev` for development, `main` for production).
- **Ansible Configuration**: Handles post-provisioning tasks like SSH certificate-based access and security hardening.

## Usage

### Prerequisites

- Azure Subscription
- Terraform installed
- Ansible installed
- GitHub repository with Secrets configured for Azure Service Principal

### Steps to Run

1. Clone this repository.
2. Navigate to the `ops/terraform/` directory.
3. Set up an Azure Service Principal and add its credentials as GitHub Secrets.
4. Modify the `tfvars` files located in `ops/terraform/environments/` to customize for your specific environment.
5. Commit and push your changes:
   - **Push to `dev` branch** for deployment to the development environment.
   - **Push to `main` branch** for deployment to the production environment.
6. The **GitHub Actions** pipeline will automatically handle provisioning and configuration based on the branch.

### Workspaces

**Terraform Workspaces** are used to manage different environments, with separate variable files and Terraform state:

- **Development**: Workspace `dev` uses `ops/terraform/environments/dev.tfvars`.
- **Production**: Workspace `prod` uses `ops/terraform/environments/prod.tfvars`.

## Future Improvements

- [ ] Migrate Service Principal login to OpenID Connect for enhanced security and simplified GitHub Actions integration.
- [ ] Implement Terraform state locking with Azure Blob Storage for safe parallel execution.
- [ ] Add monitoring and alerting integration using Azure Monitor and Prometheus.
- [ ] Extend support for multi-region Kubernetes clusters with automated failover.
- [ ] Automate the certificate renewal process for SSH access using Let's Encrypt.
- [ ] Set up testing infrastructure to validate infrastructure changes in a staging environment before production.

## License

This project is licensed under the MIT License.
