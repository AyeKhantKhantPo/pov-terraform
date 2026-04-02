# AWS Dashboard & Counting Service — Terraform

Provisions a two-server architecture on AWS using Terraform. A public **dashboard-server** serves the web UI and communicates with a private **counting-server** over the internal VPC network.

---

## Architecture

```
Internet
    │
    ▼ port 9002
dashboard-server (public subnet)        counting-server (private subnet)
  EC2 · Ubuntu 24.04                      EC2 · Ubuntu 24.04
  Public IP  · 13.212.x.x                Private IP · 172.31.x.x
  Private IP · 172.31.x.x   ──SSH/9003──▶  no internet access
```

- **dashboard-server** — publicly accessible, downloads all binaries, runs the dashboard app on port `9002`
- **counting-server** — private only, receives its binary via SCP from dashboard-server, runs the counting app on port `9003`

---

## Project Structure

```
.
├── .ssh/                    # Generated key pair (git-ignored)
├── data.tf                  # AMI data source (Ubuntu 24.04)
├── ec2.tf                   # Key pair, security groups, EC2 instances
├── outputs.tf               # Public IP, private IPs, SSH command
├── terraform.tfvars         # Your variable values
├── variables.tf             # Variable definitions
├── versions.tf              # Terraform & AWS provider versions
└── vpc.tf                   # VPC, subnets, IGW, route tables
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.9
- AWS CLI configured (`aws configure`)
- An AWS account with EC2/VPC permissions

---

## Usage

```bash
# 1. Initialize — downloads the AWS provider
terraform init

# 2. Preview what will be created
terraform plan

# 3. Apply — creates all resources on AWS
terraform apply
```

After `terraform apply`, outputs will print:

```
dashboard_public_ip  = "13.212.x.x"
ssh_command          = "ssh -i .ssh/dashboard-key-pair.pem ubuntu@13.212.x.x"
```

---

## Variables

| Variable | Description | Example |
|---|---|---|
| `prefix1` | Prefix for dashboard resources | `dashboard` |
| `prefix2` | Prefix for counting resources | `counting` |
| `region` | AWS region | `ap-southeast-1` |
| `environment` | Environment name | `main` |
| `address_space` | VPC CIDR block | `172.31.0.0/16` |
| `subnet_prefix1` | Public subnet CIDR | `172.31.0.0/20` |
| `subnet_prefix2` | Private subnet CIDR | `172.31.16.0/20` |
| `dashboard_instance_type` | EC2 type for dashboard | `t3.micro` |
| `counting_instance_type` | EC2 type for counting | `t3.micro` |

---

## How Automation Works

On first boot, `user_data` scripts run automatically:

1. **dashboard-server** saves the private key to `~/.ssh/`
2. Downloads both `dashboard-service` and `counting-service` binaries from GitHub
3. SCPs the counting binary to counting-server over the private network
4. Starts counting-service remotely on counting-server via SSH
5. Starts dashboard-service locally on port `9002`

> counting-server has no internet access — all files are transferred from dashboard-server via the internal VPC network.

---

## Debugging

```bash
# SSH into dashboard-server
ssh -i .ssh/dashboard-key-pair.pem ubuntu@<dashboard-public-ip>

# Check dashboard service logs
cat /tmp/dashboard.log

# Check cloud-init (user_data) full log
cat /var/log/cloud-init-output.log
```

---

## Cleanup

```bash
terraform destroy --auto-approve
```

This removes all AWS resources created by this project.

---

## Security Notes

- `.ssh/` and `*.pem` files are git-ignored — never commit private keys
- counting-server is only reachable from dashboard-server's private IP
- SSH on counting-server is restricted to `172.31.14.174/32` (dashboard private IP)