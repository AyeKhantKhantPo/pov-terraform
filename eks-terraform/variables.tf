variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "master-eks-admin"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "akkp-eks-sgp-cluster"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.33"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}
