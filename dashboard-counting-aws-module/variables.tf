variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the region set in the provider configuration"
  type        = string
  default     = null
}

################################################################################
# VPC
################################################################################
variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_for_dashboard" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets_for_counting" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags_for_dashboard" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags_for_counting" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

################################################################################
# Dashboard EC2 Instance
################################################################################
variable "dashboard_instance_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

variable "dashboard_instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "dashboard_user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead"
  type        = string
  default     = null
}

################################################################################
# Counting EC2 Instance
################################################################################
variable "counting_instance_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

variable "counting_instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "counting_user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead"
  type        = string
  default     = null
}

#################
# Security group
#################
variable "dashboard_sg_name" {
  description = "Name of security group - not required if create_sg is false"
  type        = string
  default     = null
}

variable "dashboard_sg_description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "counting_sg_name" {
  description = "Name of security group - not required if create_sg is false"
  type        = string
  default     = null
}

variable "counting_sg_description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

################################################################################
# Key Pair
################################################################################
variable "key_name" {
  description = "The name for the key pair. Conflicts with `key_name_prefix`"
  type        = string
  default     = null
}
