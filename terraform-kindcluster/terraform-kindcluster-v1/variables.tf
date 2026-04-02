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