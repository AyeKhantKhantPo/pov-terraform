resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    security_group_ids      =[aws_security_group.control_plane.id]
    
    # Passing both public and private subnets matching eksctl defaults
    subnet_ids = concat(
      [for s in aws_subnet.public : s.id],[for s in aws_subnet.private : s.id]
    )
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on =[
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.vpc_resource_controller
  ]
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "ng-23f10bf2"
  node_role_arn   = aws_iam_role.node_role.arn
  
  subnet_ids      = [for s in aws_subnet.private : s.id]

  ami_type       = "AL2023_x86_64_STANDARD"
  instance_types =["t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.node_group.id
    version = aws_launch_template.node_group.latest_version
  }

  labels = {
    "alpha.eksctl.io/cluster-name"   = var.cluster_name
    "alpha.eksctl.io/nodegroup-name" = "ng-23f10bf2"
  }

  tags = {
    "alpha.eksctl.io/nodegroup-name" = "ng-23f10bf2"
    "alpha.eksctl.io/nodegroup-type" = "managed"
  }

  depends_on =[
    aws_iam_role_policy_attachment.node_policy
  ]
}
