output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.dashboard_counting_app_vpc.vpc_id
}

output "dashboard_public_ip" {
  description = "Public IP of the Dashboard instance"
  value       = module.dashboard_ec2_instance.public_ip
}

output "dashboard_private_ip" {
  description = "Private IP of the Dashboard instance"
  value       = module.dashboard_ec2_instance.private_ip
}

output "counting_private_ip" {
  description = "Private IP of the Counting instance"
  value       = module.counting_ec2_instance.private_ip
}

output "ssh_command" {
  description = "SSH command to connect to dashboard-server"
  value       = "ssh -i .ssh/${var.key_name}.pem ubuntu@${module.dashboard_ec2_instance.public_ip}"
}

output "dashboard_url" {
  description = "Dashboard URL"
  value       = "http://${module.dashboard_ec2_instance.public_ip}:9002"
}