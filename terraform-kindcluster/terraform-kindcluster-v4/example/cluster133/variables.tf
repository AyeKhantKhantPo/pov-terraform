variable "cluster_name" {
  type        = string
  description = "This is the name of kind cluster"
  default     = "sg-cluster"
}

variable "k8s_image" {
  type        = string
  description = "This is node image of kind cluster"
  default     = "kindest/node:v1.33.7@sha256:d26ef333bdb2cbe9862a0f7c3803ecc7b4303d8cea8e814b481b09949d353040"
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