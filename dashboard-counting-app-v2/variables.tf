variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the region set in the provider configuration"
  type        = string
  default     = null
}


################################################################################
# Variables for Dashboard VPC
################################################################################
variable "dashboard_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "dashboard_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}


################################################################################
# Public Subnets for Dashboard VPC
################################################################################

variable "public_subnets_for_dashboard" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}


################################################################################
# Availability Zones
################################################################################
variable "dashboard_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

################################################################################
# Private Subnets for Dashboard VPC
################################################################################
variable "private_subnets_for_dashboard" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

################################################################################
# NAT Gateway
################################################################################
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

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}
