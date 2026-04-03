# Dashboard & Counting App (AWS Module Deployment)

This project uses Terraform to deploy a two-tier application on AWS. It features a **Dashboard App** (Public) and a **Counting App** (Private backend), with automated installation via User Data and NAT Gateway routing.

## Architecture
*   **VPC**: Custom VPC with 1 Public Subnet and 1 Private Subnet.
*   **NAT Gateway**: Enables the private Counting instance to safely download updates and binaries from the internet.
*   **EC2**: Two Ubuntu 24.04 instances managed via standard AWS modules.
*   **Automation**: 
    *   **User Data**: Scripts automate the installation of `unzip`, downloading binaries, and setting up Systemd services.
    *   **Key Pair**: Automatically generated, uploaded to AWS, and saved locally to `.ssh/`.

---

## Module References

### VPC
*   [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
*   [Source Code (GitHub)](https://github.com/terraform-aws-modules/terraform-aws-vpc)

### EC2
*   [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
*   [Source Code (GitHub)](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance)

### Security Group
*   [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
*   [Source Code (GitHub)](https://github.com/terraform-aws-modules/terraform-aws-security-group)

### Key-Pair
*   [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/key-pair/aws/latest)
*   [Source Code (GitHub)](https://github.com/terraform-aws-modules/terraform-aws-key-pair)

---

## Important AWS Best Practice Note

### 1. Avoiding Circular Dependencies
To allow the Dashboard to talk to the Counting app, we reference the **Security Group ID** as the source, rather than a hardcoded IP address. This is more secure and prevents Terraform from crashing due to circular dependencies between the two EC2 instances.

### 2. Computed Ingress Rules
When using Security Group IDs as sources, we use `computed_ingress_with_source_security_group_id`. We must manually define the `number_of_computed_ingress_with_source_security_group_id` so Terraform can correctly calculate the resource count before the IDs are generated.

### 3. User Data Reliability
We use `user_data_base64` to prevent script corruption and `user_data_replace_on_change = true`. This ensures that any update to the application installation script correctly triggers a fresh deployment of the server.

---

## Quick Start

1.  **Initialize**:
    ```bash
    terraform init
    ```

2.  **Deploy**:
    ```bash
    terraform apply --auto-approve
    ```

3.  **Access the App**:
    *   **Dashboard URL**: Look for `dashboard_url` in the terminal output (Port 9002).
    *   **SSH**: 
        ```bash
        ssh -i .ssh/dashboard-counting-key.pem ubuntu@<PUBLIC_IP>
        ```

## Troubleshooting
If you cannot see the dashboard in your browser after 2 minutes:
1.  SSH into the Dashboard instance.
2.  Check the installation progress: `tail -f /var/log/cloud-init-output.log`
3.  Ensure the service is active: `systemctl status dashboard-api.service`

## Cleanup
```bash
terraform destroy --auto-approve
```