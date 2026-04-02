# Dashboard & Counting App (AWS Module Deployment)

This project uses Terraform to deploy a two-tier application on AWS. It features a **Dashboard App** in a public subnet and a **Counting App** in a private subnet, with automated installation via User Data.

## Architecture
*   **VPC**: Custom VPC with 1 Public Subnet and 1 Private Subnet.
*   **NAT Gateway**: Allows the private Counting app to download updates.
*   **Security Groups**: 
    *   Dashboard: Open to the internet on port `9002` and `22` (SSH).
    *   Counting: Restricted to Dashboard access only on port `9003` and `22`.
*   **EC2**: Two Ubuntu 24.04 instances managed via Terraform modules.
*   **Key Pair**: Automatically generated and saved to `.ssh/`.

## Prerequisites
*   [Terraform](https://www.terraform.io/downloads.html) (>= 1.14)
*   AWS CLI configured with a profile named `main-tf-admin`.
*   A `terraform.tfvars` file (use `terraform.tfvars.example` as a template).

## Quick Start

1.  **Initialize Terraform** (Downloads providers and modules):
    ```bash
    terraform init
    ```

2.  **Plan the Infrastructure**:
    ```bash
    terraform plan
    ```

3.  **Deploy**:
    ```bash
    terraform apply
    ```

## Verification & SSH

After a successful `apply`, Terraform will output the Dashboard URL and the SSH command.

*   **Access Dashboard**: Open the browser at the `dashboard_url` provided in the output (Port 9002).
*   **SSH into Dashboard**:
    ```bash
    ssh -i .ssh/dashboard-counting-key.pem ubuntu@<DASHBOARD_PUBLIC_IP>
    ```

## Project Structure
```text
.
├── scripts/
│   ├── counting.sh        # Setup script for the backend app
│   └── dashboard.sh.tpl   # Template script for the frontend app
├── ec2.tf                 # EC2 instance modules
├── vpc.tf                 # VPC and Networking module
├── security_group.tf      # Firewall rules
├── key_pair.tf            # Automatic SSH key generation
├── versions.tf            # Provider and version constraints
└── terraform.tfvars       # Your local configuration values
```

## Troubleshooting
*   **Logs**: If the app isn't loading, SSH into the instance and check the installation logs:
    `tail -f /var/log/cloud-init-output.log`
*   **Service Status**: Check if the service is running:
    `systemctl status dashboard-api.service`

## Cleanup
To delete all created resources:
```bash
terraform destroy --auto-approve
```