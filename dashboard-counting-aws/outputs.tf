output "dashboard_public_ip" {
  description = "Public IP to access the dashboard (use port 9002)"
  value       = aws_instance.dashboard_server.public_ip
}

output "dashboard_private_ip" {
  description = "Dashboard server private IP"
  value       = aws_instance.dashboard_server.private_ip
}

output "counting_private_ip" {
  description = "Counting server private IP (only reachable from dashboard)"
  value       = aws_instance.counting_server.private_ip
}

output "ssh_command" {
  description = "SSH command to connect to dashboard-server"
  value       = "ssh -i .ssh/dashboard-keypair.pem ubuntu@${aws_instance.dashboard_server.public_ip}"
}

output "dashboard_url" {
  description = "Dashboard URL"
  value       = "http://${aws_instance.dashboard_server.public_ip}:9002"
}