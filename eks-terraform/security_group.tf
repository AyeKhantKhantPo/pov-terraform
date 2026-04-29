# Control Plane Security Group
resource "aws_security_group" "control_plane" {
  name        = "ControlPlaneSecurityGroup"
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ControlPlaneSecurityGroup"
  }
}

# Shared Node Security Group
resource "aws_security_group" "node" {
  name        = "ClusterSharedNodeSecurityGroup"
  description = "Communication between all nodes in the cluster"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ClusterSharedNodeSecurityGroup"
  }
}

# Ingress: Node to Control Plane
resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow unmanaged nodes to communicate with control plane (all ports)"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.node.id
}

resource "aws_security_group_rule" "cluster_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.control_plane.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Ingress: Control Plane to Node
resource "aws_security_group_rule" "node_inbound_cluster" {
  description              = "Allow managed and unmanaged nodes to communicate with each other (all ports)"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.control_plane.id
}

# Ingress: Node to Node
resource "aws_security_group_rule" "node_inbound_self" {
  description              = "Allow nodes to communicate with each other (all ports)"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.node.id
}

resource "aws_security_group_rule" "node_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.node.id
  cidr_blocks       = ["0.0.0.0/0"]
}