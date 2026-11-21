variable "account_name" {
  type    = string
  default = "master-console-admin"
}

variable "my_public_ip" {
  description = "Your public IP in CIDR form for SSH access to bastion (e.g. 1.2.3.4/32)"
  type        = string
}

variable "key_output_dir" {
  description = "Local directory to write generated private keys"
  type        = string
  default     = "keypair"
}

variable "project_name" {
  type    = string
  default = "retail-banking-lab"
}

variable "profile" {
  description = "AWS CLI profile to use for provider authentication (set in terraform.tfvars)"
  type        = string
}
