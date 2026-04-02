variable "cluster_name" {
  type        = string
  description = "This is the name of kind cluster"
  default     = "sg-cluster"
}

variable "k8s_image" {
  type        = string
  description = "This is node image of kind cluster"
  default     = "kindest/node:v1.31.14@sha256:6f86cf509dbb42767b6e79debc3f2c32e4ee01386f0489b3b2be24b0a55aac2b"
}

variable "masternode_count" {
  type        = number
  description = "The number of master nodes"
  default     = 1
}

variable "workernode_count" {
  type        = number
  description = "The number of worker nodes"
  default     = 3
}

variable "pod_subnet" {
  type = string
  description = "Pod Subnets CIDR"
  default = "10.253.0.0/16"
}

variable "service_subnet" {
  type = string
  description = "Service Subnets CIDR"
  default = "10.133.0.0/16"
}