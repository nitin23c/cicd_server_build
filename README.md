
# Terraform IasC for AWS to build a demo CI Server

This repository contains Terraform code that enables you to provision a network infrastructure and compute instances on AWS with pre-installed Jenkins, SonarQube, Docker, Trivy, and AWS CLI. Additionally, it includes the creation of an IAM policy and role that grants EC2 instances permissions to upload Docker images to Amazon ECR (Elastic Container Registry).

## Features
- Easily deploy network infrastructure and compute instances on AWS using Terraform.
- Pre-configured instances with Jenkins, SonarQube, Docker, Trivy, and AWS CLI.
- Simplified management of AWS resources and permissions.
- Can be modified to spin up multiple instances.
- user_data can be modified to suit ones need

## Prerequisites
Before using this Terraform code, ensure you have:

- An AWS account.
- Installed Terraform locally.
- AWS CLI configured with appropriate credentials.

## Usage
Before using create a terraform.tfvars file in the main directory and pass values of 

- access_ip
- key_path
- inst_type

## Example of terraform.tfvars file

```HCL
access_ip = "0.0.0.0/0"
key_path  = "/location_of_your_public_key/.ssh/rsa_key.pub"
inst_type = "t2.medium"
```

```diff
- Update access_ip to your own public IP instead of 0.0.0.0/0.
- t2.medium instance type is recommended which will incur cost
```

## Future enhancments

- Deploy an EKS cluster
- Configure argoCD on eks cluster