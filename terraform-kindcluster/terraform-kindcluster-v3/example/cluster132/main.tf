module "cluster132" {
  source = "../../"

  cluster_name     = var.cluster_name
  k8s_image        = var.k8s_image
  masternode_count = var.masternode_count
  workernode_count = var.workernode_count
}
