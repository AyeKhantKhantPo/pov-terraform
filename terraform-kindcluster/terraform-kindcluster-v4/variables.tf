variable "cluster_name" {
  type        = string
  description = "This is the name of kind cluster"
  default     = "sg-cluster"
}

variable "k8s_image" {
  type        = string
  description = "This is node image of kind cluster"
  default     = "kindest/node:v1.35.0@sha256:452d707d4862f52530247495d180205e029056831160e22870e37e3f6c1ac31f"
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
  type        = string
  description = "Pod Subnets CIDR"
  default     = "10.253.0.0/16"
}

variable "service_subnet" {
  type        = string
  description = "Service Subnets CIDR"
  default     = "10.133.0.0/16"
}