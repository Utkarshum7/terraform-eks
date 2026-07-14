# EKS Cluster Setup with Terraform

This repository contains the Infrastructure as Code (IaC) for deploying an Amazon Elastic Kubernetes Service (EKS) cluster using Terraform. The project leverages Terraform modules to provision a scalable and production-ready Kubernetes cluster on AWS, while ensuring state management and locking with Amazon S3 and DynamoDB.

## 🚀 Features

Automated provisioning of EKS cluster and associated resources.

S3 backend for storing Terraform remote state securely.

DynamoDB table for preventing concurrent state modifications (state locking).

Modular structure for easy extension and maintenance.

Creates VPC, subnets, security groups, IAM roles, and EKS cluster.

Supports node group configuration and autoscaling.

## 📂 Project Structure
terraform-eks/
│── main.tf              # Root Terraform configuration  
│── variables.tf         # Input variables for customization  
│── outputs.tf           # Output values after provisioning  
│── providers.tf         # AWS provider and backend config  
│── eks.tf               # EKS module and cluster resources  
│── vpc.tf               # VPC, subnets, and networking setup  
│── s3_backend.tf        # Remote backend (S3 + DynamoDB) configuration  
│── terraform.tfvars     # Variable values (not committed for security)  

## ⚙️ Prerequisites

AWS account with IAM permissions to create EKS resources.

Terraform
 installed (v1.5+ recommended).

Configured AWS CLI with valid credentials:

aws configure

🏗️ Setup Instructions
1. Clone the repository
git clone https://github.com/Utkarshum7/terraform-eks.git
cd terraform-eks

2. Initialize Terraform with remote backend

This project uses S3 and DynamoDB for remote state management. Update the s3_backend.tf with your S3 bucket and DynamoDB table names before initializing.

terraform {
  backend "s3" {
    bucket         = "my-eks-terraform-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "eks-terraform-locks"
    encrypt        = true
  }
}

3. Initialize Terraform
terraform init

4. Validate and plan the infrastructure
terraform validate
terraform plan

5. Apply to create resources
terraform apply -auto-approve

6. Destroy resources (when no longer needed)
terraform destroy -auto-approve

## 📌 Remote State Management

S3 bucket stores Terraform state (terraform.tfstate).

DynamoDB table prevents multiple users from applying changes simultaneously (state locking).

Ensures safe collaboration in team environments.

## 🔑 Outputs

After a successful apply, Terraform will output:

EKS Cluster Name

EKS Cluster Endpoint

Kubeconfig details

These can be used to connect via kubectl:

aws eks update-kubeconfig --region <region> --name <cluster_name>

## 🛠️ Future Enhancements

Add RDS integration for persistent databases.

Implement CI/CD pipelines for Terraform automation.

Add monitoring (CloudWatch, Prometheus, Grafana) for cluster observability.
