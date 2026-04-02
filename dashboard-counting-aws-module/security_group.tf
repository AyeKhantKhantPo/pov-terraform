# -------------------------------------------------------
# SECURITY GROUP: dashboard-sg
# Public facing — allows SSH and port 9002 from anywhere
# -------------------------------------------------------
resource "aws_security_group" "dashboard_sg" {
  name        = "dashboard-sg"
  description = "Security group for dashboard server"
  vpc_id      = aws_vpc.dashboard_counting.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Dashboard app port"
    from_port   = 9002
    to_port     = 9002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dashboard-sg"
  }
}

# -------------------------------------------------------
# SECURITY GROUP: counting-sg
# Private — created empty, rules added separately below
# -------------------------------------------------------
resource "aws_security_group" "counting_sg" {
  name        = "counting-sg"
  description = "Security group for counting server"
  vpc_id      = aws_vpc.dashboard_counting.id

  tags = {
    Name = "counting-sg"
  }
}

# Rules added AFTER dashboard_server exists — breaks the cycle
resource "aws_security_group_rule" "counting_sg_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.dashboard_server.private_ip}/32"]
  security_group_id = aws_security_group.counting_sg.id
  description       = "SSH from dashboard server only"
}

resource "aws_security_group_rule" "counting_sg_app" {
  type              = "ingress"
  from_port         = 9003
  to_port           = 9003
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.dashboard_server.private_ip}/32"]
  security_group_id = aws_security_group.counting_sg.id
  description       = "App port from dashboard server only"
}