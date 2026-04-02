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
# Variables for Counting VPC
################################################################################
variable "counting_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "counting_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}


################################################################################
# Public Subnets for Dashboard VPC
################################################################################

variable "public_subnets_dashboard" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}


################################################################################
# Public Subnets for counting VPC
################################################################################
variable "public_subnets_counting" {
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

variable "counting_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}