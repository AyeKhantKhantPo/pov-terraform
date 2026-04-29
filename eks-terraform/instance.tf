resource "aws_launch_template" "node_group" {
  name = "${var.cluster_name}-lt"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 80
      volume_type = "gp3"
      iops        = 3000
      throughput  = 125
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Forces IMDSv2
    http_put_response_hop_limit = 2
  }

  vpc_security_group_ids =[aws_security_group.node.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-ng-Node"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.cluster_name}-ng-Node"
    }
  }

  tag_specifications {
    resource_type = "network-interface"
    tags = {
      Name = "${var.cluster_name}-ng-Node"
    }
  }
}