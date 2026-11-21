data "aws_ami" "ubuntu_customer" {
  provider = aws.customer
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu_account" {
  provider = aws.account
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu_statement" {
  provider = aws.statement
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_route53_zone" "primary" {
  name         = "ayekhant.click."
  private_zone = false
}
