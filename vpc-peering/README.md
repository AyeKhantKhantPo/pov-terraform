# Retail Banking Lab (vpc-peering)

This folder contains a production-quality Terraform project for the Retail Banking Lab.

Usage
1. Set `my_public_ip` in `terraform.tfvars` to your IP (e.g. `1.2.3.4/32`).
2. Ensure the `script/` folder contains `setup-customer.sh`, `setup-account.sh`, `setup-statement.sh`.
3. Run:

```bash
terraform init
terraform validate
terraform plan -out plan.tfplan
terraform apply "plan.tfplan"
```

Generated keys are written to `generated-keys/` inside this folder.
