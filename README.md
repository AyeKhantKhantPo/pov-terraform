# pov-terraform

Collection of Terraform projects for building AWS infrastructure and local Kubernetes (kind) clusters.

## 📦 Project Structure

### AWS (Dashboard Counting)

* `dashboard-counting-aws` → Full AWS setup (EC2, VPC, security group, scripts)
* `dashboard-counting-aws-module` → Modular version of AWS resources
* `dashboard-counting-app-v0/v1/v2` → Iterations of app infrastructure
* `dashboard-counting-app-module` → Shared module for app components

### Kubernetes (kind)

* `kind-cluster` → Simple kind cluster setup
* `terraform-kindcluster` → Advanced versions (v0 → v4) with examples and configs

## 🚀 Getting Started

```bash
terraform init
terraform plan
terraform apply
```

Each folder is independent — run Terraform inside the specific directory you want.

## ⚠️ Notes

* Some folders contain `.tfstate` files → for demo/testing only
* Use remote backend (e.g. S3) for real projects
* Check `terraform.tfvars` or `.example` files before applying

## 🧠 Purpose

This repo is for learning and experimenting with:

* Terraform modules
* AWS infrastructure provisioning
* Local Kubernetes (kind) automation

---
