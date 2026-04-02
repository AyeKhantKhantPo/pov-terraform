variable "profile" {
  description = "AWS CLI profile name"
  type        = string
}

variable "prefix1" {
  description = "Prefix for dashboard resources"
  type        = string
}

variable "prefix2" {
  description = "Prefix for counting resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "address_space" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet" {
  description = "Public subnet CIDR"
  type        = string
}

variable "private_subnet" {
  description = "Private subnet CIDR"
  type        = string
}

variable "dashboard_instance_type" {
  description = "EC2 instance type for dashboard"
  type        = string
  default     = "t3.micro"
}

variable "counting_instance_type" {
  description = "EC2 instance type for counting"
  type        = string
  default     = "t3.micro"
}